import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/charge.dart';
import 'package:erp_global/features/billing/data/models/payment.dart';
import 'package:erp_global/features/billing/domain/payments.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/payment_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Charge _charge(String id, int amount, DateTime due, {int discount = 0}) =>
    Charge(
      id: id,
      institutionId: 'i',
      createdAt: DateTime.utc(2025, 9),
      updatedAt: DateTime.utc(2025, 9),
      studentId: 's',
      feeItemId: 'f',
      dueDate: due,
      amountMinor: amount,
      discountMinor: discount,
    );

Payment _payment(
  String id,
  int amount,
  List<PaymentAllocation> allocs, {
  PaymentMethod method = PaymentMethod.cash,
}) => Payment(
  id: id,
  institutionId: 'i',
  createdAt: DateTime.utc(2025, 10),
  updatedAt: DateTime.utc(2025, 10),
  studentId: 's',
  method: method,
  amountMinor: amount,
  paidAt: DateTime.utc(2025, 10),
  allocations: allocs,
);

void main() {
  group('lógica de alocação', () {
    final c1 = _charge('a', 1000, DateTime.utc(2025, 10, 5));
    final c2 = _charge('b', 2000, DateTime.utc(2025, 9, 5), discount: 500);

    test('aloca primeiro a cobrança mais antiga e guarda o excedente', () {
      final r = autoAllocate(
        charges: [c1, c2],
        allocated: const {},
        amountMinor: 2000,
      );
      expect(r.allocations.map((a) => (a.chargeId, a.amountMinor)), [
        ('b', 1500),
        ('a', 500),
      ]);
      expect(r.remainderMinor, 0);
      final big = autoAllocate(
        charges: [c1, c2],
        allocated: const {},
        amountMinor: 5000,
      );
      expect(big.remainderMinor, 2500);
    });

    test('desconta o já alocado e ignora cobranças pagas/anuladas', () {
      final r = autoAllocate(
        charges: [
          c1,
          c2.copyWith(status: ChargeStatus.paid),
          _charge(
            'x',
            100,
            DateTime.utc(2025, 8),
          ).copyWith(status: ChargeStatus.cancelled),
        ],
        allocated: const {'a': 400},
        amountMinor: 700,
      );
      expect(r.allocations.single.amountMinor, 600);
      expect(r.remainderMinor, 100);
    });

    test('estado após alocação', () {
      expect(statusAfterAllocation(c1, 1000), ChargeStatus.paid);
      expect(statusAfterAllocation(c1, 300), ChargeStatus.partiallyPaid);
      expect(
        statusAfterAllocation(c1.copyWith(status: ChargeStatus.overdue), 300),
        ChargeStatus.overdue,
      );
    });

    test('conta corrente reconcilia: saldo = pré-pago - em dívida', () {
      final charges = [c1, c2];
      final payments = [
        _payment('p1', 3000, const [
          PaymentAllocation(chargeId: 'b', amountMinor: 1500),
          PaymentAllocation(chargeId: 'a', amountMinor: 400),
        ]),
        _payment('p2', 300, const [
          PaymentAllocation(chargeId: 'a', amountMinor: 300),
        ], method: PaymentMethod.prepaidBalance),
      ];
      final acc = buildStudentAccount(
        studentId: 's',
        institutionId: 'i',
        charges: charges,
        payments: payments,
        now: DateTime.utc(2025, 11),
      );
      // pago em dinheiro 3000; 1900 alocado -> 1100 adiantado; 300 usados.
      expect(acc.prepaidMinor, 800);
      expect(acc.outstandingMinor, 300);
      expect(acc.balanceMinor, acc.prepaidMinor - acc.outstandingMinor);
      final debits = acc.entries.fold<int>(0, (a, e) => a + e.debitMinor);
      final credits = acc.entries.fold<int>(0, (a, e) => a + e.creditMinor);
      expect(debits, 2500);
      expect(credits - debits, 500);
      expect(acc.balanceMinor, 500);
    });
  });

  group('API mock de pagamentos', () {
    late ProviderContainer container;

    Future<List<Charge>> setUpCharges([String enrollmentId = 'enr-1']) async {
      final billing = container.read(billingMockHandlersProvider);
      await container
          .read(billingPlanRepositoryProvider)
          .generateForEnrollment(
            EnrollmentConfirmed(
              enrollmentId: enrollmentId,
              studentId: 'stu-1',
              academicYearId: MockRef.academicYearId,
              gradeId: MockRef.gradeId(3),
              classroomId: MockRef.classroomId(3, 0),
              type: 'new_enrollment',
              feeMinor: 1700000,
              occurredAt: DateTime.utc(2025, 9, 1),
            ),
          );
      return billing.chargesOf('stu-1');
    }

    setUp(() {
      container = ProviderContainer(
        overrides: [
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(billingMockHandlersProvider),
              ref.watch(paymentMockHandlersProvider),
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
    });
    tearDown(() => container.dispose());

    Future<void> expectReconciled() async {
      final billing = container.read(billingMockHandlersProvider);
      final repo = container.read(paymentRepositoryProvider);
      final acc = (await repo.account('stu-1')).getOrThrow();
      final payments = (await repo.list(studentId: 'stu-1')).getOrThrow().items;
      final charges = billing.chargesOf('stu-1');
      final allocated = allocatedByCharge(payments);
      for (final c in charges) {
        final a = allocated[c.id] ?? 0;
        expect(a <= chargeNetMinor(c), isTrue);
        expect(
          c.status == ChargeStatus.paid,
          a == chargeNetMinor(c),
          reason: c.id,
        );
      }
      for (final p in payments) {
        final s = p.allocations.fold<int>(0, (x, y) => x + y.amountMinor);
        expect(s <= p.amountMinor, isTrue);
      }
      final debits = acc.entries.fold<int>(0, (a, e) => a + e.debitMinor);
      final credits = acc.entries.fold<int>(0, (a, e) => a + e.creditMinor);
      expect(acc.balanceMinor, acc.prepaidMinor - acc.outstandingMinor);
      expect(acc.balanceMinor, credits - debits);
    }

    test(
      'pagamento parcial, total, adiantado e uso do saldo reconciliam',
      () async {
        final charges = await setUpCharges();
        final repo = container.read(paymentRepositoryProvider);
        final total = charges.fold<int>(0, (a, c) => a + chargeNetMinor(c));
        await expectReconciled();

        final first = (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.cash,
          amountMinor: 500000,
        )).getOrThrow();
        expect(first.receipt!.number, 'RC ${first.payment.paidAt.year}/000001');
        expect(first.payment.allocations.first.amountMinor, 500000);
        var open = container
            .read(billingMockHandlersProvider)
            .chargesOf('stu-1');
        expect(
          open.where((c) => c.status == ChargeStatus.partiallyPaid),
          hasLength(1),
        );
        await expectReconciled();

        // Adiantamento: paga tudo e mais 1.000,00.
        final acc0 = (await repo.account('stu-1')).getOrThrow();
        final adv = (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.bankTransfer,
          amountMinor: acc0.outstandingMinor + 100000,
        )).getOrThrow();
        expect(
          adv.payment.allocations.fold<int>(0, (a, x) => a + x.amountMinor),
          acc0.outstandingMinor,
        );
        open = container.read(billingMockHandlersProvider).chargesOf('stu-1');
        expect(open.every((c) => c.status == ChargeStatus.paid), isTrue);
        final acc1 = (await repo.account('stu-1')).getOrThrow();
        expect(acc1.prepaidMinor, 100000);
        expect(acc1.outstandingMinor, 0);
        expect(acc1.balanceMinor, 100000);
        expect(total, greaterThan(0));
        await expectReconciled();

        // Sem dívida o saldo pré-pago não pode pagar nada.
        final none = await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.prepaidBalance,
          amountMinor: 1000,
        );
        expect(none.isOk, isFalse);
      },
    );

    test('uso de saldo pré-pago paga cobranças novas sem recibo', () async {
      await setUpCharges();
      final repo = container.read(paymentRepositoryProvider);
      final billing = container.read(billingMockHandlersProvider);
      final all = billing
          .chargesOf('stu-1')
          .fold<int>(0, (a, c) => a + chargeNetMinor(c));
      // Paga tudo e deixa 800,00 de adiantamento.
      await repo.create(
        studentId: 'stu-1',
        method: PaymentMethod.cash,
        amountMinor: all + 80000,
      );
      var acc = (await repo.account('stu-1')).getOrThrow();
      expect(acc.prepaidMinor, 80000);
      expect(acc.outstandingMinor, 0);
      // Nova matrícula gera novas cobranças.
      await setUpCharges('enr-2');
      final fresh = (await repo.account('stu-1')).getOrThrow();
      expect(fresh.prepaidMinor, 80000);
      expect(fresh.outstandingMinor, greaterThan(80000));

      final tooMuch = await repo.create(
        studentId: 'stu-1',
        method: PaymentMethod.prepaidBalance,
        amountMinor: 80001,
      );
      expect(tooMuch.isOk, isFalse);

      final used = (await repo.create(
        studentId: 'stu-1',
        method: PaymentMethod.prepaidBalance,
        amountMinor: 80000,
      )).getOrThrow();
      expect(used.receipt, isNull);
      acc = (await repo.account('stu-1')).getOrThrow();
      expect(acc.prepaidMinor, 0);
      expect(acc.outstandingMinor, fresh.outstandingMinor - 80000);
      await expectReconciled();
    });

    test('alocação explícita e validações 422/409', () async {
      final charges = await setUpCharges();
      final repo = container.read(paymentRepositoryProvider);
      final target = charges.last;
      final net = chargeNetMinor(target);
      expect(
        (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.cash,
          amountMinor: 0,
        )).isOk,
        isFalse,
      );
      // Excede o em dívida da cobrança.
      expect(
        (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.cash,
          amountMinor: net + 1,
          allocations: [
            PaymentAllocation(chargeId: target.id, amountMinor: net + 1),
          ],
        )).isOk,
        isFalse,
      );
      // Cobrança de outro aluno / inexistente.
      expect(
        (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.cash,
          amountMinor: 10,
          allocations: const [
            PaymentAllocation(chargeId: 'nope', amountMinor: 10),
          ],
        )).isOk,
        isFalse,
      );
      final ok = (await repo.create(
        studentId: 'stu-1',
        method: PaymentMethod.card,
        amountMinor: net,
        allocations: [PaymentAllocation(chargeId: target.id, amountMinor: net)],
      )).getOrThrow();
      expect(ok.payment.allocations.single.chargeId, target.id);
      expect(
        container
            .read(billingMockHandlersProvider)
            .chargeById(target.id)!
            .status,
        ChargeStatus.paid,
      );
      // Já paga: nova alocação recusada.
      expect(
        (await repo.create(
          studentId: 'stu-1',
          method: PaymentMethod.cash,
          amountMinor: 10,
          allocations: [
            PaymentAllocation(chargeId: target.id, amountMinor: 10),
          ],
        )).isOk,
        isFalse,
      );
      await expectReconciled();
    });

    test('recibos listáveis por pagamento', () async {
      await setUpCharges();
      final repo = container.read(paymentRepositoryProvider);
      final r = (await repo.create(
        studentId: 'stu-1',
        method: PaymentMethod.cash,
        amountMinor: 1000,
      )).getOrThrow();
      final list = (await repo.receipts(paymentId: r.payment.id)).getOrThrow();
      expect(list.items.single.id, r.receipt!.id);
      expect(list.items.single.amountMinor, 1000);
    });
  });
}
