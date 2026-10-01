import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/cash_session.dart';
import 'package:erp_global/features/billing/domain/cash.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/cash_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/payment_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

CashMovement _m(CashMovementType type, int amount) => CashMovement(
  id: '$type$amount',
  institutionId: 'i',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  sessionId: 's',
  type: type,
  amountMinor: amount,
  occurredAt: DateTime.utc(2026),
);

ProviderContainer _container() {
  final c = ProviderContainer(
    overrides: [
      mockApiModulesProvider.overrideWith(
        (ref) => [
          ref.watch(billingMockHandlersProvider),
          ref.watch(paymentMockHandlersProvider),
          ref.watch(cashMockHandlersProvider),
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
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('lógica de caixa', () {
    test('esperado = abertura + entradas - sangrias', () {
      final list = [
        _m(CashMovementType.cashPayment, 5000),
        _m(CashMovementType.supply, 1000),
        _m(CashMovementType.withdrawal, 2500),
      ];
      expect(expectedCashMinor(10000, list), 13500);
      expect(totalOfType(list, CashMovementType.withdrawal), 2500);
      expect(
        cashDifferenceMinor(countedMinor: 13000, expectedMinor: 13500),
        -500,
      );
    });
  });

  group('API de caixa (mock)', () {
    test('abre, movimenta, confere e fecha a sessão', () async {
      final c = _container();
      final repo = c.read(cashRepositoryProvider);
      final registers = (await repo.registers()).getOrThrow();
      expect(registers, hasLength(2));

      final session = (await repo.open(
        cashRegisterId: registers.first.id,
        operatorId: 'op1',
        openingMinor: 10000,
      )).getOrThrow();
      expect(session.status, CashSessionStatus.open);

      // um caixa e um operador só têm uma sessão aberta
      final dupRegister = await repo.open(
        cashRegisterId: registers.first.id,
        operatorId: 'op2',
        openingMinor: 0,
      );
      expect(dupRegister.failureOrNull?.code, 'CONFLICT');
      final dupOperator = await repo.open(
        cashRegisterId: registers.last.id,
        operatorId: 'op1',
        openingMinor: 0,
      );
      expect(dupOperator.failureOrNull?.code, 'CONFLICT');

      final tooBig = await repo.addMovement(
        sessionId: session.id,
        type: CashMovementType.withdrawal,
        amountMinor: 20000,
      );
      expect(tooBig.failureOrNull?.code, 'VALIDATION_ERROR');
      final invalidType = await repo.addMovement(
        sessionId: session.id,
        type: CashMovementType.cashPayment,
        amountMinor: 100,
      );
      expect(invalidType.failureOrNull?.code, 'VALIDATION_ERROR');

      (await repo.addMovement(
        sessionId: session.id,
        type: CashMovementType.withdrawal,
        amountMinor: 4000,
        description: 'Entrega ao cofre',
      )).getOrThrow();
      final movements = (await repo.movements(session.id)).getOrThrow();
      expect(movements, hasLength(1));
      expect(expectedCashMinor(session.openingMinor, movements), 6000);

      // diferença exige justificação
      final noNotes = await repo.close(
        sessionId: session.id,
        countedMinor: 5500,
      );
      expect(noNotes.failureOrNull?.code, 'VALIDATION_ERROR');
      final closed = (await repo.close(
        sessionId: session.id,
        countedMinor: 5500,
        notes: 'Troco em falta',
      )).getOrThrow();
      expect(closed.status, CashSessionStatus.closed);
      expect(closed.expectedMinor, 6000);
      expect(closed.differenceMinor, -500);
      expect(closed.closedAt, isNotNull);

      // fechada: imutável
      final again = await repo.close(sessionId: session.id, countedMinor: 6000);
      expect(again.failureOrNull?.code, 'CONFLICT');
      final move = await repo.addMovement(
        sessionId: session.id,
        type: CashMovementType.supply,
        amountMinor: 100,
      );
      expect(move.failureOrNull?.code, 'CONFLICT');

      // o operador pode abrir nova sessão depois do fecho
      final next = await repo.open(
        cashRegisterId: registers.first.id,
        operatorId: 'op1',
        openingMinor: 0,
      );
      expect(next.isOk, isTrue);
      final open = (await repo.sessions(
        status: CashSessionStatus.open,
      )).getOrThrow();
      expect(open.items, hasLength(1));
    });

    test('pagamentos em numerário entram na sessão aberta', () async {
      final c = _container();
      await c
          .read(billingPlanRepositoryProvider)
          .generateForEnrollment(
            EnrollmentConfirmed(
              enrollmentId: 'enr-1',
              studentId: 'stu-1',
              academicYearId: MockRef.academicYearId,
              gradeId: MockRef.gradeId(3),
              classroomId: MockRef.classroomId(3, 0),
              type: 'new_enrollment',
              feeMinor: 1700000,
              occurredAt: DateTime.utc(2025, 9, 1),
            ),
          );
      final cash = c.read(cashRepositoryProvider);
      final payments = c.read(paymentRepositoryProvider);
      final register = (await cash.registers()).getOrThrow().first;
      final session = (await cash.open(
        cashRegisterId: register.id,
        operatorId: 'op1',
        openingMinor: 1000,
      )).getOrThrow();

      (await payments.create(
        studentId: 'stu-1',
        method: PaymentMethod.cash,
        amountMinor: 3000,
      )).getOrThrow();
      (await payments.create(
        studentId: 'stu-1',
        method: PaymentMethod.bankTransfer,
        amountMinor: 2000,
      )).getOrThrow();

      final movements = (await cash.movements(session.id)).getOrThrow();
      expect(movements.map((m) => m.type), [CashMovementType.cashPayment]);
      expect(movements.single.paymentId, isNotNull);
      expect(expectedCashMinor(session.openingMinor, movements), 4000);
    });
  });
}
