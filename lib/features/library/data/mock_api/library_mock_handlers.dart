import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/library_seed.dart';
import '../models/library_models.dart';

/// Prazo de empréstimo, limite por leitor e multa por dia de atraso (Kz 50).
const loanDays = 14;
const maxActiveLoans = 3;
const finePerDayCents = 5000;

/// Handlers de `/v1/library/*` (docs/07-mock-api.md). Estado mutável em
/// memória; `POST /__mock/reset` repõe o seed.
class LibraryMockHandlers implements MockApiModule {
  LibraryMockHandlers({DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final DateTime Function() _now;

  late Map<String, BookModel> _books;
  late Map<String, CopyModel> _copies;
  late Map<String, LibraryReader> _readers;
  late Map<String, LoanModel> _loans;
  late Map<String, FineModel> _fines;
  late Map<String, ReservationModel> _reservations;
  late SeedGenerator _ids;

  void _reset() {
    final s = buildLibrarySeed();
    _ids = SeedGenerator(710);
    _books = {for (final b in s.books) b.id: b};
    _copies = {for (final c in s.copies) c.id: c};
    _readers = {for (final r in s.readers) r.id: r};
    _loans = {for (final l in s.loans) l.id: l};
    _fines = {for (final f in s.fines) f.id: f};
    _reservations = {for (final r in s.reservations) r.id: r};
  }

  String _newId() => _ids.ulid(_now());

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/library/books', _listBooks)
      ..post('/v1/library/books', _createBook)
      ..get('/v1/library/books/{id}/copies', _listCopies)
      ..post('/v1/library/books/{id}/copies', _addCopy)
      ..patch('/v1/library/copies/{id}', _setCopyStatus)
      ..get('/v1/library/loans', _listLoans)
      ..post('/v1/library/loans', _checkout)
      ..post('/v1/library/loans/{id}/return', _giveBack)
      ..get('/v1/library/fines', _listFines)
      ..post('/v1/library/fines/{id}/pay', _payFine)
      ..get('/v1/library/reservations', _listReservations)
      ..post('/v1/library/reservations', _reserve)
      ..post('/v1/library/reservations/{id}/cancel', _cancelReservation);
  }

  // ---- Acervo -----------------------------------------------------------

  late final _bookSpec = MockListSpec<BookModel>(
    searchText: (b) => '${b.title} ${b.author} ${b.isbn} ${b.category}',
    sortable: {'title': (b) => foldText(b.title), 'author': (b) => b.author},
    filterable: {'category': (b) => b.category},
    defaultSort: const ['title'],
  );

  Iterable<CopyModel> _copiesOf(String bookId) =>
      _copies.values.where((c) => c.bookId == bookId);

  BookModel _bookView(BookModel b) => b.copyWith(
    totalCopies: _copiesOf(b.id).length,
    availableCopies: _copiesOf(
      b.id,
    ).where((c) => c.status == CopyStatus.available).length,
  );

  BookModel _book(String? id) =>
      _books[id] ?? (throw const MockApiException.notFound());

  MockResponse _listBooks(MockRequest req) => mockPaginate(
    _books.values.map(_bookView),
    req,
    toJson: (b) => b.toJson(),
    spec: _bookSpec,
  );

  MockResponse _createBook(MockRequest req) {
    final body = req.jsonBody;
    final copies = body['copies'] ?? 1;
    final year = body['year'];
    MockValidator(body)
      ..required('isbn')
      ..required('title')
      ..required('author')
      ..required('category')
      ..check(
        'copies',
        copies is int && copies >= 1 && copies <= 50,
        'Entre 1 e 50 exemplares',
      )
      ..check('year', year == null || year is int, 'Ano inválido')
      ..throwIfInvalid();
    final isbn = '${body['isbn']}'.trim();
    if (_books.values.any((b) => b.isbn == isbn)) {
      throw const MockApiException.conflict('ISBN já existe');
    }
    final book = BookModel(
      id: _newId(),
      isbn: isbn,
      title: '${body['title']}'.trim(),
      author: '${body['author']}'.trim(),
      category: '${body['category']}'.trim(),
      publisher: (body['publisher'] as String?)?.trim(),
      year: year as int?,
    );
    _books[book.id] = book;
    for (var i = 0; i < (copies as int); i++) {
      _newCopy(book, _nextBarcode(book));
    }
    return MockResponse.created(_bookView(book).toJson());
  }

  String _nextBarcode(BookModel book) {
    final tail = book.isbn.replaceAll(RegExp(r'\D'), '');
    var n = _copiesOf(book.id).length + 1;
    while (_copies.values.any((c) => c.barcode == 'LIV-$tail-$n')) {
      n++;
    }
    return 'LIV-$tail-$n';
  }

  CopyModel _newCopy(BookModel book, String barcode) {
    final copy = CopyModel(id: _newId(), bookId: book.id, barcode: barcode);
    _copies[copy.id] = copy;
    return copy;
  }

  MockResponse _listCopies(MockRequest req) {
    final book = _book(req.params['id']);
    final list = _copiesOf(book.id).toList()
      ..sort((a, b) => a.barcode.compareTo(b.barcode));
    return MockResponse.ok([for (final c in list) c.toJson()]);
  }

  MockResponse _addCopy(MockRequest req) {
    final book = _book(req.params['id']);
    MockValidator(req.jsonBody)
      ..required('barcode')
      ..throwIfInvalid();
    final barcode = '${req.jsonBody['barcode']}'.trim().toUpperCase();
    if (_copies.values.any((c) => c.barcode == barcode)) {
      throw const MockApiException.conflict('Código de barras já existe');
    }
    return MockResponse.created(_newCopy(book, barcode).toJson());
  }

  MockResponse _setCopyStatus(MockRequest req) {
    final copy =
        _copies[req.params['id']] ?? (throw const MockApiException.notFound());
    final raw = req.jsonBody['status'];
    final target = CopyStatus.values.where((s) => s.name == raw).firstOrNull;
    MockValidator(req.jsonBody)
      ..check(
        'status',
        target == CopyStatus.available ||
            target == CopyStatus.lost ||
            target == CopyStatus.damaged,
        'Só é possível marcar como disponível, perdido ou danificado',
      )
      ..throwIfInvalid();
    if (copy.status == CopyStatus.loaned ||
        copy.status == CopyStatus.reserved) {
      throw const MockApiException.conflict(
        'O exemplar está emprestado ou reservado',
      );
    }
    final updated = copy.copyWith(status: target!);
    _copies[copy.id] = updated;
    if (target == CopyStatus.available) _offerCopy(updated);
    return MockResponse.ok(_copies[copy.id]!.toJson());
  }

  // ---- Circulação -------------------------------------------------------

  LoanModel _loanView(LoanModel l) =>
      l.status == LoanStatus.active && l.dueAt.isBefore(_now())
      ? l.copyWith(status: LoanStatus.overdue)
      : l;

  late final _loanSpec = MockListSpec<LoanModel>(
    searchText: (l) => '${l.bookTitle} ${l.borrowerName} ${l.barcode}',
    sortable: {'loanedAt': (l) => l.loanedAt, 'dueAt': (l) => l.dueAt},
    filterable: {'status': (l) => l.status.wire},
    defaultSort: const ['-loanedAt'],
  );

  MockResponse _listLoans(MockRequest req) => mockPaginate(
    _loans.values.map(_loanView),
    req,
    toJson: (l) => l.toJson(),
    spec: _loanSpec,
  );

  LibraryReader _readerByCard(Object? uid) {
    final key = '$uid'.trim().toUpperCase();
    return _readers.values.where((r) => r.cardUid == key).firstOrNull ??
        (throw const MockApiException.notFound(
          'Cartão de leitor não encontrado',
        ));
  }

  Iterable<ReservationModel> _openReservations(String bookId) =>
      _reservations.values.where(
        (r) =>
            r.bookId == bookId &&
            (r.status == ReservationStatus.pending ||
                r.status == ReservationStatus.ready),
      );

  /// Um exemplar ficou livre: guarda-o para a reserva mais antiga ou torna-o
  /// disponível.
  void _offerCopy(CopyModel copy) {
    final next =
        (_reservations.values
                .where(
                  (r) =>
                      r.bookId == copy.bookId &&
                      r.status == ReservationStatus.pending,
                )
                .toList()
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt)))
            .firstOrNull;
    if (next == null) {
      _copies[copy.id] = copy.copyWith(status: CopyStatus.available);
      return;
    }
    _copies[copy.id] = copy.copyWith(status: CopyStatus.reserved);
    _reservations[next.id] = next.copyWith(status: ReservationStatus.ready);
  }

  bool _hasPendingFine(String borrowerId) => _fines.values.any(
    (f) => f.borrowerId == borrowerId && f.status == FineStatus.pending,
  );

  MockResponse _checkout(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('cardUid')
      ..required('barcode')
      ..throwIfInvalid();
    final reader = _readerByCard(body['cardUid']);
    final barcode = '${body['barcode']}'.trim().toUpperCase();
    final copy =
        _copies.values.where((c) => c.barcode == barcode).firstOrNull ??
        (throw const MockApiException.notFound('Exemplar não encontrado'));
    if (_hasPendingFine(reader.id)) {
      throw const MockApiException.conflict('O leitor tem multas por pagar');
    }
    final active = _loans.values.where(
      (l) => l.borrowerId == reader.id && l.status == LoanStatus.active,
    );
    if (active.length >= maxActiveLoans) {
      throw const MockApiException.conflict(
        'O leitor atingiu o limite de empréstimos',
      );
    }
    ReservationModel? held;
    if (copy.status == CopyStatus.reserved) {
      held = _openReservations(copy.bookId)
          .where(
            (r) =>
                r.borrowerId == reader.id &&
                r.status == ReservationStatus.ready,
          )
          .firstOrNull;
      if (held == null) {
        throw const MockApiException.conflict(
          'O exemplar está reservado para outro leitor',
        );
      }
    } else if (copy.status != CopyStatus.available) {
      throw const MockApiException.conflict('O exemplar não está disponível');
    }
    if (held != null) {
      _reservations[held.id] = held.copyWith(
        status: ReservationStatus.fulfilled,
      );
    }
    _copies[copy.id] = copy.copyWith(status: CopyStatus.loaned);
    final now = _now();
    final loan = LoanModel(
      id: _newId(),
      copyId: copy.id,
      bookTitle: _book(copy.bookId).title,
      barcode: copy.barcode,
      borrowerId: reader.id,
      borrowerName: reader.name,
      loanedAt: now,
      dueAt: now.add(const Duration(days: loanDays)),
    );
    _loans[loan.id] = loan;
    return MockResponse.created(loan.toJson());
  }

  MockResponse _giveBack(MockRequest req) {
    final loan =
        _loans[req.params['id']] ?? (throw const MockApiException.notFound());
    if (loan.status == LoanStatus.returned) {
      throw const MockApiException.conflict('O exemplar já foi devolvido');
    }
    final now = _now();
    var fine = 0;
    if (loan.dueAt.isBefore(now)) {
      final days = (now.difference(loan.dueAt).inHours / 24).ceil();
      fine = days * finePerDayCents;
      final f = FineModel(
        id: _newId(),
        loanId: loan.id,
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerName,
        bookTitle: loan.bookTitle,
        daysLate: days,
        amountCents: fine,
        createdAt: now,
      );
      _fines[f.id] = f;
    }
    final returned = loan.copyWith(
      status: LoanStatus.returned,
      returnedAt: now,
      fineCents: fine,
    );
    _loans[loan.id] = returned;
    final copy = _copies[loan.copyId];
    if (copy != null && copy.status == CopyStatus.loaned) _offerCopy(copy);
    return MockResponse.ok(returned.toJson());
  }

  // ---- Multas -----------------------------------------------------------

  late final _fineSpec = MockListSpec<FineModel>(
    searchText: (f) => '${f.borrowerName} ${f.bookTitle}',
    sortable: {'createdAt': (f) => f.createdAt},
    filterable: {'status': (f) => f.status.wire},
    defaultSort: const ['-createdAt'],
  );

  MockResponse _listFines(MockRequest req) => mockPaginate(
    _fines.values,
    req,
    toJson: (f) => f.toJson(),
    spec: _fineSpec,
  );

  MockResponse _payFine(MockRequest req) {
    final fine =
        _fines[req.params['id']] ?? (throw const MockApiException.notFound());
    if (fine.status == FineStatus.paid) {
      throw const MockApiException.conflict('A multa já foi paga');
    }
    final paid = fine.copyWith(status: FineStatus.paid, paidAt: _now());
    _fines[fine.id] = paid;
    return MockResponse.ok(paid.toJson());
  }

  // ---- Reservas ---------------------------------------------------------

  late final _reservationSpec = MockListSpec<ReservationModel>(
    searchText: (r) => '${r.borrowerName} ${r.bookTitle}',
    sortable: {'createdAt': (r) => r.createdAt},
    filterable: {'status': (r) => r.status.wire},
    defaultSort: const ['-createdAt'],
  );

  MockResponse _listReservations(MockRequest req) => mockPaginate(
    _reservations.values,
    req,
    toJson: (r) => r.toJson(),
    spec: _reservationSpec,
  );

  MockResponse _reserve(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('bookId')
      ..required('cardUid')
      ..throwIfInvalid();
    final book = _book('${body['bookId']}');
    final reader = _readerByCard(body['cardUid']);
    if (_copiesOf(book.id).any((c) => c.status == CopyStatus.available)) {
      throw const MockApiException.conflict(
        'Há exemplares disponíveis; faça o empréstimo',
      );
    }
    if (_openReservations(book.id).any((r) => r.borrowerId == reader.id)) {
      throw const MockApiException.conflict('O leitor já reservou esta obra');
    }
    final reservation = ReservationModel(
      id: _newId(),
      bookId: book.id,
      bookTitle: book.title,
      borrowerId: reader.id,
      borrowerName: reader.name,
      createdAt: _now(),
    );
    _reservations[reservation.id] = reservation;
    return MockResponse.created(reservation.toJson());
  }

  MockResponse _cancelReservation(MockRequest req) {
    final r =
        _reservations[req.params['id']] ??
        (throw const MockApiException.notFound());
    if (r.status == ReservationStatus.fulfilled ||
        r.status == ReservationStatus.cancelled) {
      throw const MockApiException.conflict('A reserva já está encerrada');
    }
    final cancelled = r.copyWith(status: ReservationStatus.cancelled);
    _reservations[r.id] = cancelled;
    if (r.status == ReservationStatus.ready) {
      // Liberta o exemplar guardado para esta reserva.
      final held = _copiesOf(
        r.bookId,
      ).where((c) => c.status == CopyStatus.reserved).firstOrNull;
      if (held != null) _offerCopy(held);
    }
    return MockResponse.ok(cancelled.toJson());
  }
}
