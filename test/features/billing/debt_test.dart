import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/charge.dart';
import 'package:erp_global/features/billing/data/models/payment_agreement.dart';
import 'package:erp_global/features/billing/domain/debt.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/debt_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/payment_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Charge _charge(
  String id,
  DateTime due, {
  int amount = 1000,
  String student = 's',
  ChargeStatus status = ChargeStatus.pending,
}) => Charge(
  id: id,
  institutionId: 'i',
  createdAt: DateTime.utc(2025, 9),
  updatedAt: DateTime.utc(2025, 9),
  studentId: student,
  feeItemId: 'f',
  dueDate: due,
  amountMinor: amount,
  status: status,
);

void main() {
  setUpAll(PtAoFormatters.initialize);
  final asOf = DateTime.utc(2025, 11, 10);

  group('devedores', () {
    final charges = [
      _charge('a', DateTime.utc(2025, 10, 5), amount: 3000),
      _charge('b', DateTime.utc(2025, 11, 5), amount: 2000),
      _charge('c', DateTime.utc(2025, 12, 5)),
      _charge('d', DateTime.utc(2025, 10, 5), student: 't', amount: 500),
      _charge(
        'e',
        DateTime.utc(2025, 9, 5),
        student: 'u',
        status: ChargeStatus.paid,
      ),
    ];
    String? room(String s) => s == 't' ? 'room-2' : 'room-1';

    test('só vencidas e em aberto, maior dívida primeiro', () {
      final d = buildDebtors(
        charges: charges,
        allocated: const {'a': 1000},
        asOf: asOf,
        classroomOf: room,
      );
      expect(d.map((x) => x.studentId), ['s', 't']);
      expect(d.first.overdueMinor, 2000 + 2000);
      expect(d.first.overdueCount, 2);
      expect(d.first.daysOverdue, 36);
    });

    test('filtra por turma e por mês de vencimento', () {
      final byRoom = buildDebtors(
        charges: charges,
        allocated: const {},
        asOf: asOf,
        classroomOf: room,
        classroomId: 'room-2',
      );
      expect(byRoom.map((x) => x.studentId), ['t']);
      final byMonth = buildDebtors(
        charges: charges,
        allocated: const {},
        asOf: asOf,
        classroomOf: room,
        month: '2025-11',
      );
      expect(byMonth.single.overdueMinor, 2000);
    });

    test('totalmente pago deixa de ser devedor', () {
      final d = buildDebtors(
        charges: charges,
        allocated: const {'d': 500},
        asOf: asOf,
        classroomOf: room,
        month: '2025-10',
      );
      expect(d.map((x) => x.studentId), ['s']);
    });
  });

  group('avisos', () {
    final charges = [
      _charge('a', DateTime.utc(2025, 11, 12)),
      _charge('b', DateTime.utc(2025, 11, 20)),
      _charge('c', DateTime.utc(2025, 11, 1)),
      _charge('d', DateTime.utc(2025, 11, 1)),
    ];

    test('pré-vencimento dentro da janela e pós-vencimento', () {
      final p = planNotices(
        charges: charges,
        allocated: const {},
        asOf: asOf,
        preDueDays: 3,
        exempt: const {'d'},
      );
      expect(p.map((n) => (n.charge.id, n.kind)), [
        ('a', NoticeKind.preDue),
        ('c', NoticeKind.postDue),
      ]);
    });

    test('não repete o que já foi enviado', () {
      final p = planNotices(
        charges: charges,
        allocated: const {},
        asOf: asOf,
        preDueDays: 3,
        sent: {noticeKey('a', NoticeKind.preDue)},
      );
      expect(p.map((n) => n.charge.id), ['c', 'd']);
    });
  });

  group('acordos', () {
    test('reparte o total em prestações mensais sem perder cêntimos', () {
      final i = splitInstallments(
        totalMinor: 1001,
        count: 3,
        firstDue: DateTime.utc(2025, 1, 31),
      );
      expect(i.map((x) => x.amountMinor), [334, 334, 333]);
      expect(i.fold<int>(0, (a, x) => a + x.amountMinor), 1001);
      expect(i.map((x) => x.dueDate), [
        DateTime.utc(2025, 1, 31),
        DateTime.utc(2025, 2, 28),
        DateTime.utc(2025, 3, 31),
      ]);
    });
  });

  group('API mock', () {
    late ProviderContainer container;

    setUp(() async {
      container = ProviderContainer(
        overrides: [
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(billingMockHandlersProvider),
              ref.watch(paymentMockHandlersProvider),
              ref.watch(debtMockHandlersProvider),
            ],
          ),
          apiClientProvider.overrideWith(
            (ref) => ApiClient.create(
              baseUrl: 'https://api.test',
              useMockApi: true,
              registry: ref.watch(mockApiRegistryProvider),
              mockConfig: const MockApiConfig.instant(),
              logging: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      // Matrícula em 2024: as primeiras prestações já estão vencidas.
      for (final (student, grade) in [('stu-1', 3), ('stu-2', 4)]) {
        (await container
                .read(billingPlanRepositoryProvider)
                .generateForEnrollment(
                  EnrollmentConfirmed(
                    enrollmentId: 'enr-$student',
                    studentId: student,
                    academicYearId: MockRef.academicYearId,
                    gradeId: MockRef.gradeId(grade),
                    classroomId: MockRef.classroomId(grade, 0),
                    type: 'new_enrollment',
                    feeMinor: 1700000,
                    occurredAt: DateTime.utc(2024, 9, 1),
                  ),
                ))
            .getOrThrow();
      }
    });

    test('lista devedores e filtra por turma e mês', () async {
      final repo = container.read(debtRepositoryProvider);
      final all = (await repo.debtors()).getOrThrow();
      expect(all.items.map((d) => d.studentId).toSet(), {'stu-1', 'stu-2'});
      expect(all.items.first.overdueCount, greaterThan(1));

      final room = (await repo.debtors(
        classroomId: MockRef.classroomId(4, 0),
      )).getOrThrow();
      expect(room.items.map((d) => d.studentId), ['stu-2']);

      final month = (await repo.debtors(
        month: '2024-09',
        asOf: DateTime.utc(2024, 10, 20),
      )).getOrThrow();
      expect(month.items.every((d) => d.overdueCount == 1), isTrue);

      final bad = await repo.debtors(month: '2024-13');
      expect(bad.failureOrNull?.code, 'VALIDATION_ERROR');
    });

    test('avisos são idempotentes e validam a antecedência', () async {
      final repo = container.read(debtRepositoryProvider);
      final first = (await repo.runNotices()).getOrThrow();
      expect(first, isNotEmpty);
      expect(first.every((n) => n.message.isNotEmpty), isTrue);
      expect((await repo.runNotices()).getOrThrow(), isEmpty);
      final list = (await repo.notices(kind: NoticeKind.postDue)).getOrThrow();
      expect(list.items, isNotEmpty);
      expect(
        (await repo.runNotices(preDueDays: 99)).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
    });

    test(
      'acordo: cria, bloqueia duplicado, calcula progresso e cancela',
      () async {
        final repo = container.read(debtRepositoryProvider);
        final debtor = (await repo.debtors()).getOrThrow().items.firstWhere(
          (d) => d.studentId == 'stu-1',
        );
        final soon = DateTime.now().toUtc().add(const Duration(days: 20));
        final a = (await repo.createAgreement(
          studentId: 'stu-1',
          installmentCount: 4,
          firstDueDate: soon,
        )).getOrThrow();
        expect(a.totalMinor, debtor.overdueMinor);
        expect(a.installments, hasLength(4));
        expect(a.status, AgreementStatus.active);

        expect(
          (await repo.createAgreement(
            studentId: 'stu-1',
            installmentCount: 2,
            firstDueDate: soon,
          )).failureOrNull?.code,
          'CONFLICT',
        );

        // Aluno com acordo em curso fica marcado e deixa de receber avisos
        // de atraso das cobranças abrangidas.
        final marked = (await repo.debtors()).getOrThrow().items.firstWhere(
          (d) => d.studentId == 'stu-1',
        );
        expect(marked.hasAgreement, isTrue);
        final notices = (await repo.runNotices()).getOrThrow();
        expect(
          notices.where(
            (n) => n.studentId == 'stu-1' && n.kind == NoticeKind.postDue,
          ),
          isEmpty,
        );
        expect(notices.where((n) => n.studentId == 'stu-2'), isNotEmpty);

        // Pagamento total das cobranças abrangidas cumpre o acordo.
        await container
            .read(paymentRepositoryProvider)
            .create(
              studentId: 'stu-1',
              method: PaymentMethod.cash,
              amountMinor: a.totalMinor,
            );
        final done = (await repo.agreements(
          studentId: 'stu-1',
        )).getOrThrow().items.single;
        expect(done.status, AgreementStatus.completed);
        expect(done.paidMinor, a.totalMinor);
        expect(done.installments.every((i) => i.paid), isTrue);

        final other = (await repo.createAgreement(
          studentId: 'stu-2',
          installmentCount: 2,
          firstDueDate: soon,
        )).getOrThrow();
        final cancelled = (await repo.cancelAgreement(other.id)).getOrThrow();
        expect(cancelled.status, AgreementStatus.cancelled);
      },
    );

    test('acordo valida prestações, data e aluno sem dívida', () async {
      final repo = container.read(debtRepositoryProvider);
      final soon = DateTime.now().toUtc().add(const Duration(days: 5));
      for (final r in [
        await repo.createAgreement(
          studentId: 'stu-1',
          installmentCount: 1,
          firstDueDate: soon,
        ),
        await repo.createAgreement(
          studentId: 'stu-1',
          installmentCount: 3,
          firstDueDate: DateTime.utc(2020),
        ),
        await repo.createAgreement(
          studentId: 'ninguem',
          installmentCount: 3,
          firstDueDate: soon,
        ),
      ]) {
        expect(r.failureOrNull?.code, 'VALIDATION_ERROR');
      }
    });

    test('acordo incumprido quando uma prestação vencida não foi paga', () {
      final base = splitInstallments(
        totalMinor: 3000,
        count: 3,
        firstDue: DateTime.utc(2025, 1, 10),
      );
      final a = evaluateAgreement(
        _agreement(base),
        outstandingMinor: 2500,
        asOf: DateTime.utc(2025, 1, 20),
      );
      expect(a.status, AgreementStatus.broken);
      final ok = evaluateAgreement(
        _agreement(base),
        outstandingMinor: 2000,
        asOf: DateTime.utc(2025, 1, 20),
      );
      expect(ok.status, AgreementStatus.active);
      expect(ok.installments.first.paid, isTrue);
    });
  });
}

PaymentAgreement _agreement(List<AgreementInstallment> installments) =>
    PaymentAgreement(
      id: 'ag',
      institutionId: 'i',
      createdAt: DateTime.utc(2025, 1),
      updatedAt: DateTime.utc(2025, 1),
      studentId: 's',
      chargeIds: const ['a'],
      totalMinor: 3000,
      installments: installments,
    );
