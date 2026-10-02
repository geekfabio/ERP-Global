import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/billing/data/mock_api/billing_mock_handlers.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/fee_item.dart';
import 'package:erp_global/features/billing/data/repositories/api_billing_repositories.dart';
import 'package:erp_global/features/billing/domain/billing_plan.dart';
import 'package:erp_global/features/billing/domain/billing_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

({ApiFeeItemRepository fees, ApiBillingPlanRepository plan}) _env() {
  final registry = MockApiRegistry()..addModule(BillingMockHandlers());
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return (
    fees: ApiFeeItemRepository(client),
    plan: ApiBillingPlanRepository(client),
  );
}

EnrollmentConfirmed _event({String id = 'enr-1', int grade = 3}) =>
    EnrollmentConfirmed(
      enrollmentId: id,
      studentId: 'stu-1',
      academicYearId: MockRef.academicYearId,
      gradeId: MockRef.gradeId(grade),
      classroomId: MockRef.classroomId(grade, 0),
      type: 'new_enrollment',
      feeMinor: 1700000,
      occurredAt: DateTime.utc(2025, 9, 1),
    );

void main() {
  group('computeLateFee', () {
    final due = DateTime.utc(2025, 9, 5);
    test('zero dentro da tolerância', () {
      expect(
        computeLateFee(
          amountMinor: 1000000,
          dueDate: due,
          asOf: DateTime.utc(2025, 9, 10),
        ),
        0,
      );
    });

    test('multa 2 % + juro 1 % por mês de atraso, em inteiros', () {
      // 20 dias de atraso: 1 mês -> 20000 + 10000.
      expect(
        computeLateFee(
          amountMinor: 1000000,
          dueDate: due,
          asOf: DateTime.utc(2025, 9, 25),
        ),
        30000,
      );
      // 40 dias: 2 meses -> 20000 + 20000.
      expect(
        computeLateFee(
          amountMinor: 1000000,
          dueDate: due,
          asOf: DateTime.utc(2025, 10, 15),
        ),
        40000,
      );
    });

    test('inclui multa fixa', () {
      expect(
        computeLateFee(
          amountMinor: 1000000,
          dueDate: due,
          asOf: DateTime.utc(2025, 9, 25),
          rules: const LateFeeRules(lateFeeBp: 0, lateFeeFixedMinor: 5000),
        ),
        15000,
      );
    });
  });

  test('vencimentos: 10 prestações de Setembro a Junho', () {
    final d = tuitionDueDates(2025);
    expect(d, hasLength(10));
    expect(d.first, DateTime.utc(2025, 9, 5));
    expect(d.last, DateTime.utc(2026, 6, 5));
    expect(schoolYearStart(DateTime.utc(2026, 3, 1)), 2025);
    expect(schoolYearStart(DateTime.utc(2025, 9, 1)), 2025);
  });

  group('tabela de preços', () {
    test('lista, cria (409 duplicado, 422 inválido) e desactiva', () async {
      final r = _env().fees;
      final all = (await r.list(pageSize: 100)).getOrThrow();
      expect(all.items, hasLength(MockRef.gradeCount * 2));
      final draft = FeeItem(
        id: '',
        institutionId: MockRef.institutionId,
        createdAt: DateTime.utc(2025),
        updatedAt: DateTime.utc(2025),
        academicYearId: MockRef.academicYearId,
        gradeId: MockRef.gradeId(1),
        type: FeeType.uniform,
        amountMinor: 800000,
      );
      final created = (await r.create(draft)).getOrThrow();
      expect(created.id, isNotEmpty);
      expect((await r.create(draft)).failureOrNull?.code, 'CONFLICT');
      expect(
        (await r.create(draft.copyWith(amountMinor: 0))).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
      final off = (await r.update(
        created.id,
        status: FeeItemStatus.inactive,
      )).getOrThrow();
      expect(off.status, FeeItemStatus.inactive);
      final byType = (await r.list(type: FeeType.uniform)).getOrThrow();
      expect(byType.items, hasLength(1));
    });
  });

  group('geração ao confirmar matrícula', () {
    test('cria matrícula + 10 propinas e é idempotente', () async {
      final p = _env().plan;
      final created = (await p.generateForEnrollment(_event())).getOrThrow();
      expect(created, hasLength(11));
      expect(created.first.amountMinor, 1700000);
      expect(created[1].dueDate, DateTime.utc(2025, 9, 5));
      expect(created.last.dueDate, DateTime.utc(2026, 6, 5));
      final again = (await p.generateForEnrollment(_event())).getOrThrow();
      expect(again.map((c) => c.id), created.map((c) => c.id));
      final list = (await p.charges(studentId: 'stu-1')).getOrThrow();
      expect(list.meta.total, 11);
    });

    test('listener ignora o evento sem licença billing', () async {
      final p = _env().plan;
      final bus = DomainEventBus();
      var licensed = false;
      final listener = EnrollmentBillingListener(
        bus: bus,
        repository: p,
        isLicensed: () => licensed,
      );
      expect(await listener.handle(_event()), isNull);
      expect((await p.charges()).getOrThrow().meta.total, 0);
      licensed = true;
      expect((await listener.handle(_event()))!.getOrThrow(), hasLength(11));
      await listener.dispose();
      bus.dispose();
    });
  });

  test('multas: marca vencidas, cria multa uma só vez', () async {
    final p = _env().plan;
    await p.generateForEnrollment(_event());
    final first = (await p.applyLateFees(
      asOf: DateTime.utc(2025, 10, 20),
    )).getOrThrow();
    // Propinas de Setembro e Outubro (05/09, 05/10) em atraso; a matrícula
    // vence na data da geração.
    expect(first, hasLength(2));
    expect(first.every((a) => a.penaltyMinor > 0), isTrue);
    final again = (await p.applyLateFees(
      asOf: DateTime.utc(2025, 10, 20),
    )).getOrThrow();
    expect(again, isEmpty);
  });
}
