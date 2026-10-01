import '../../../../core/utils/seed_generator.dart';
import '../models/library_models.dart';

/// Leitor da biblioteca, identificado pelo cartão escolar. A biblioteca
/// mantém o seu próprio directório (não importa internals de outros módulos).
class LibraryReader {
  const LibraryReader({
    required this.id,
    required this.name,
    required this.cardUid,
  });

  final String id;
  final String name;
  final String cardUid;
}

/// Acervo, exemplares, leitores e circulação de desenvolvimento.
class LibrarySeed {
  const LibrarySeed({
    required this.books,
    required this.copies,
    required this.readers,
    required this.loans,
    required this.fines,
    required this.reservations,
  });

  final List<BookModel> books;
  final List<CopyModel> copies;
  final List<LibraryReader> readers;
  final List<LoanModel> loans;
  final List<FineModel> fines;
  final List<ReservationModel> reservations;
}

const _titles = [
  ('Mayombe', 'Pepetela', 'Romance'),
  ('Os Transparentes', 'Ondjaki', 'Romance'),
  ('Ualalapi', 'Ungulani Ba Ka Khosa', 'Romance'),
  ('O Alquimista', 'Paulo Coelho', 'Romance'),
  ('Matemática 10.ª Classe', 'Equipa Editorial', 'Didáctico'),
  ('Física 11.ª Classe', 'Equipa Editorial', 'Didáctico'),
  ('Química 12.ª Classe', 'Equipa Editorial', 'Didáctico'),
  ('Gramática da Língua Portuguesa', 'Maria Santos', 'Língua'),
  ('Atlas de Angola', 'Instituto Geográfico', 'Referência'),
  ('História de Angola', 'Alberto Oliveira', 'História'),
  ('Dicionário Português-Inglês', 'Porto Editora', 'Referência'),
  ('Biologia 9.ª Classe', 'Equipa Editorial', 'Didáctico'),
];

const _readerCount = 8;

/// Valor fixo para a seed ser determinística (mesma seed → mesmos dados).
final _base = DateTime.utc(2025, 9, 1);

LibrarySeed buildLibrarySeed({int seed = 71}) {
  final gen = SeedGenerator(seed);
  String id(int n) => gen.ulid(_base.add(Duration(minutes: n)));

  final readers = [
    for (var i = 0; i < _readerCount; i++)
      LibraryReader(
        id: id(500 + i),
        name: gen.fullName(),
        cardUid: 'CARD-L-${(100 + i).toString()}',
      ),
  ];

  final books = <BookModel>[];
  final copies = <CopyModel>[];
  for (var i = 0; i < _titles.length; i++) {
    final (title, author, category) = _titles[i];
    // A obra 3 tem um só exemplar (serve para demonstrar reservas).
    final count = i == 3 ? 1 : 2 + i % 2;
    final bookId = id(i);
    books.add(
      BookModel(
        id: bookId,
        isbn:
            '978-972-${(1000 + i).toString()}-${(10 + i).toString()}-${i % 10}',
        title: title,
        author: author,
        category: category,
        year: 2000 + i,
      ),
    );
    for (var c = 0; c < count; c++) {
      copies.add(
        CopyModel(
          id: id(100 + i * 4 + c),
          bookId: bookId,
          barcode: 'LIV-${(i + 1).toString().padLeft(3, '0')}-${c + 1}',
        ),
      );
    }
  }

  CopyModel firstCopyOf(int bookIndex) =>
      copies.firstWhere((c) => c.bookId == books[bookIndex].id);

  final loans = <LoanModel>[];
  final fines = <FineModel>[];

  LoanModel loan(
    int n,
    int bookIndex,
    int reader, {
    required int daysAgo,
    int? returnedAfterDays,
    int fineCents = 0,
  }) {
    final copy = firstCopyOf(bookIndex);
    final loanedAt = _base.subtract(Duration(days: daysAgo));
    return LoanModel(
      id: id(300 + n),
      copyId: copy.id,
      bookTitle: books[bookIndex].title,
      barcode: copy.barcode,
      borrowerId: readers[reader].id,
      borrowerName: readers[reader].name,
      loanedAt: loanedAt,
      dueAt: loanedAt.add(const Duration(days: 14)),
      returnedAt: returnedAfterDays == null
          ? null
          : loanedAt.add(Duration(days: returnedAfterDays)),
      status: returnedAfterDays == null
          ? LoanStatus.active
          : LoanStatus.returned,
      fineCents: fineCents,
    );
  }

  // Activos (os exemplares ficam emprestados).
  final active = [
    loan(0, 0, 0, daysAgo: 3),
    loan(1, 1, 1, daysAgo: 20),
    loan(2, 2, 2, daysAgo: 5),
    loan(3, 3, 3, daysAgo: 2),
  ];
  loans.addAll(active);
  // Devolvidos: um com multa pendente (leitor 5) e outro com multa paga (6).
  final late = loan(
    4,
    4,
    5,
    daysAgo: 40,
    returnedAfterDays: 18,
    fineCents: 20000,
  );
  final paid = loan(
    5,
    5,
    6,
    daysAgo: 60,
    returnedAfterDays: 17,
    fineCents: 15000,
  );
  loans
    ..add(late)
    ..add(paid)
    ..add(loan(6, 7, 7, daysAgo: 30, returnedAfterDays: 10));
  fines.addAll([
    FineModel(
      id: id(400),
      loanId: late.id,
      borrowerId: late.borrowerId,
      borrowerName: late.borrowerName,
      bookTitle: late.bookTitle,
      daysLate: 4,
      amountCents: 20000,
      createdAt: late.returnedAt!,
    ),
    FineModel(
      id: id(401),
      loanId: paid.id,
      borrowerId: paid.borrowerId,
      borrowerName: paid.borrowerName,
      bookTitle: paid.bookTitle,
      daysLate: 3,
      amountCents: 15000,
      status: FineStatus.paid,
      createdAt: paid.returnedAt!,
      paidAt: paid.returnedAt!.add(const Duration(days: 1)),
    ),
  ]);

  final loanedCopies = {for (final l in active) l.copyId};
  return LibrarySeed(
    books: books,
    copies: [
      for (final c in copies)
        loanedCopies.contains(c.id) ? c.copyWith(status: CopyStatus.loaned) : c,
    ],
    readers: readers,
    loans: loans,
    fines: fines,
    reservations: [
      ReservationModel(
        id: id(450),
        bookId: books[3].id,
        bookTitle: books[3].title,
        borrowerId: readers[4].id,
        borrowerName: readers[4].name,
        createdAt: _base,
      ),
    ],
  );
}
