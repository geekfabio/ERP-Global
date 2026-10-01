import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/library/data/mock_api/library_mock_handlers.dart';
import 'package:erp_global/features/library/data/models/library_models.dart';
import 'package:erp_global/features/library/data/repositories/api_library_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

({ApiBookRepository books, ApiCirculationRepository loans}) _env() {
  final registry = MockApiRegistry()..addModule(LibraryMockHandlers());
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return (
    books: ApiBookRepository(client),
    loans: ApiCirculationRepository(client),
  );
}

BookModel _draft([String isbn = '978-1']) => BookModel(
  id: '',
  isbn: isbn,
  title: 'Livro Novo',
  author: 'Autor',
  category: 'Romance',
);

void main() {
  group('acervo e exemplares', () {
    test('lista paginada com contagem de exemplares', () async {
      final r = _env().books;
      final page = (await r.list(pageSize: 5)).getOrThrow();
      expect(page.items, hasLength(5));
      expect(page.meta.total, 12);
      expect(page.items.every((b) => b.totalCopies >= 1), isTrue);
    });

    test('criar gera exemplares; 409 ISBN repetido; 422 inválido', () async {
      final r = _env().books;
      final b = (await r.create(_draft(), copies: 3)).getOrThrow();
      expect((b.totalCopies, b.availableCopies), (3, 3));
      expect((await r.copies(b.id)).getOrThrow(), hasLength(3));
      expect((await r.create(_draft())).failureOrNull?.code, 'CONFLICT');
      expect(
        (await r.create(_draft('x'), copies: 0)).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
    });

    test(
      'estados do exemplar: perdido, reposto e bloqueio se emprestado',
      () async {
        final env = _env();
        final b = (await env.books.create(_draft(), copies: 1)).getOrThrow();
        final copy = (await env.books.copies(b.id)).getOrThrow().single;
        final lost = (await env.books.setCopyStatus(
          copy.id,
          CopyStatus.lost,
        )).getOrThrow();
        expect(lost.status, CopyStatus.lost);
        final blocked = await env.loans.checkout(
          cardUid: 'CARD-L-100',
          barcode: copy.barcode,
        );
        expect(blocked.failureOrNull?.code, 'CONFLICT');
        await env.books.setCopyStatus(copy.id, CopyStatus.available);
        await env.loans.checkout(cardUid: 'CARD-L-100', barcode: copy.barcode);
        expect(
          (await env.books.setCopyStatus(
            copy.id,
            CopyStatus.lost,
          )).failureOrNull?.code,
          'CONFLICT',
        );
        expect(
          (await env.books.setCopyStatus(
            copy.id,
            CopyStatus.loaned,
          )).failureOrNull?.code,
          'VALIDATION_ERROR',
        );
      },
    );

    test('código de barras duplicado é 409', () async {
      final r = _env().books;
      final b = (await r.create(_draft(), copies: 1)).getOrThrow();
      final first = (await r.addCopy(b.id, barcode: 'z-1')).getOrThrow();
      expect(first.barcode, 'Z-1');
      final dup = await r.addCopy(b.id, barcode: 'z-1');
      expect(dup.failureOrNull?.code, 'CONFLICT');
    });
  });

  group('empréstimos e multas', () {
    test('empréstimo por cartão, devolução sem atraso e reposição', () async {
      final env = _env();
      final b = (await env.books.create(_draft(), copies: 1)).getOrThrow();
      final copy = (await env.books.copies(b.id)).getOrThrow().single;
      final loan = (await env.loans.checkout(
        cardUid: 'card-l-100',
        barcode: copy.barcode,
      )).getOrThrow();
      expect(loan.status, LoanStatus.active);
      expect(loan.dueAt.difference(loan.loanedAt).inDays, loanDays);
      expect(
        (await env.books.copies(b.id)).getOrThrow().single.status,
        CopyStatus.loaned,
      );
      final again = await env.loans.checkout(
        cardUid: 'CARD-L-101',
        barcode: copy.barcode,
      );
      expect(again.failureOrNull?.code, 'CONFLICT');
      final back = (await env.loans.giveBack(loan.id)).getOrThrow();
      expect((back.status, back.fineCents), (LoanStatus.returned, 0));
      expect(
        (await env.books.copies(b.id)).getOrThrow().single.status,
        CopyStatus.available,
      );
      expect(
        (await env.loans.giveBack(loan.id)).failureOrNull?.code,
        'CONFLICT',
      );
    });

    test('cartão ou exemplar desconhecido é 404; campos vazios 422', () async {
      final r = _env().loans;
      final noCard = await r.checkout(cardUid: 'nope', barcode: 'LIV-001-1');
      expect(noCard.failureOrNull?.code, 'NOT_FOUND');
      final noCopy = await r.checkout(cardUid: 'CARD-L-100', barcode: 'nope');
      expect(noCopy.failureOrNull?.code, 'NOT_FOUND');
      final empty = await r.checkout(cardUid: '', barcode: '');
      expect(empty.failureOrNull?.code, 'VALIDATION_ERROR');
    });

    test('devolução em atraso gera multa que bloqueia empréstimos', () async {
      final env = _env();
      final overdue = (await env.loans.loans(
        status: LoanStatus.overdue,
        pageSize: 100,
      )).getOrThrow().items;
      expect(overdue, isNotEmpty);
      final loan = overdue.first;
      final back = (await env.loans.giveBack(loan.id)).getOrThrow();
      expect(back.fineCents, greaterThan(0));
      expect(back.fineCents % finePerDayCents, 0);
      final fines = (await env.loans.fines(
        status: FineStatus.pending,
        pageSize: 100,
      )).getOrThrow().items;
      final fine = fines.firstWhere((f) => f.loanId == loan.id);
      expect(fine.amountCents, back.fineCents);

      final b = (await env.books.create(_draft(), copies: 8)).getOrThrow();
      final copies = (await env.books.copies(b.id)).getOrThrow();
      var blocked = 0;
      for (var i = 0; i < 8; i++) {
        final r = await env.loans.checkout(
          cardUid: 'CARD-L-${100 + i}',
          barcode: copies[i].barcode,
        );
        if (r.failureOrNull?.message == 'O leitor tem multas por pagar') {
          blocked++;
        }
      }
      // Leitor 5 já tinha uma multa por pagar na seed; o da devolução é outro.
      expect(blocked, 2);

      final paid = (await env.loans.payFine(fine.id)).getOrThrow();
      expect(paid.status, FineStatus.paid);
      expect(
        (await env.loans.payFine(fine.id)).failureOrNull?.code,
        'CONFLICT',
      );
    });

    test('limite de empréstimos por leitor', () async {
      final env = _env();
      final b = (await env.books.create(_draft(), copies: 4)).getOrThrow();
      final copies = (await env.books.copies(b.id)).getOrThrow();
      for (final c in copies.take(maxActiveLoans)) {
        (await env.loans.checkout(
          cardUid: 'CARD-L-107',
          barcode: c.barcode,
        )).getOrThrow();
      }
      final over = await env.loans.checkout(
        cardUid: 'CARD-L-107',
        barcode: copies.last.barcode,
      );
      expect(over.failureOrNull?.code, 'CONFLICT');
    });
  });

  group('reservas', () {
    test('devolução guarda o exemplar para quem reservou', () async {
      final env = _env();
      final b = (await env.books.create(_draft(), copies: 1)).getOrThrow();
      final copy = (await env.books.copies(b.id)).getOrThrow().single;
      final early = await env.loans.reserve(
        bookId: b.id,
        cardUid: 'CARD-L-101',
      );
      expect(early.failureOrNull?.code, 'CONFLICT');
      final loan = (await env.loans.checkout(
        cardUid: 'CARD-L-100',
        barcode: copy.barcode,
      )).getOrThrow();
      final res = (await env.loans.reserve(
        bookId: b.id,
        cardUid: 'CARD-L-101',
      )).getOrThrow();
      expect(res.status, ReservationStatus.pending);
      final dup = await env.loans.reserve(bookId: b.id, cardUid: 'CARD-L-101');
      expect(dup.failureOrNull?.code, 'CONFLICT');

      await env.loans.giveBack(loan.id);
      expect(
        (await env.books.copies(b.id)).getOrThrow().single.status,
        CopyStatus.reserved,
      );
      final other = await env.loans.checkout(
        cardUid: 'CARD-L-102',
        barcode: copy.barcode,
      );
      expect(other.failureOrNull?.code, 'CONFLICT');
      (await env.loans.checkout(
        cardUid: 'CARD-L-101',
        barcode: copy.barcode,
      )).getOrThrow();
      final all = (await env.loans.reservations(
        pageSize: 100,
      )).getOrThrow().items;
      expect(
        all.firstWhere((r) => r.id == res.id).status,
        ReservationStatus.fulfilled,
      );
    });

    test('cancelar reserva pronta liberta o exemplar', () async {
      final env = _env();
      final b = (await env.books.create(_draft(), copies: 1)).getOrThrow();
      final copy = (await env.books.copies(b.id)).getOrThrow().single;
      final loan = (await env.loans.checkout(
        cardUid: 'CARD-L-100',
        barcode: copy.barcode,
      )).getOrThrow();
      final res = (await env.loans.reserve(
        bookId: b.id,
        cardUid: 'CARD-L-101',
      )).getOrThrow();
      await env.loans.giveBack(loan.id);
      final cancelled = (await env.loans.cancelReservation(
        res.id,
      )).getOrThrow();
      expect(cancelled.status, ReservationStatus.cancelled);
      expect(
        (await env.books.copies(b.id)).getOrThrow().single.status,
        CopyStatus.available,
      );
      expect(
        (await env.loans.cancelReservation(res.id)).failureOrNull?.code,
        'CONFLICT',
      );
    });
  });
}
