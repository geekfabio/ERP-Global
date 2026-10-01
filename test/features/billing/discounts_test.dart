import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/discount.dart';
import 'package:erp_global/features/billing/domain/billing_plan.dart';
import 'package:erp_global/features/billing/domain/discounts.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/discount_providers.dart';
import 'package:erp_global/features/billing/presentation/widgets/discount_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Discount _d({
  DiscountKind kind = DiscountKind.percentage,
  int value = 1000,
  FeeType? type,
  DateTime? from,
  DateTime? until,
  DiscountStatus status = DiscountStatus.approved,
}) => Discount(
  id: 'd',
  institutionId: 'i',
  createdAt: DateTime.utc(2025),
  updatedAt: DateTime.utc(2025),
  studentId: 's',
  kind: kind,
  reason: DiscountReason.merit,
  value: value,
  feeType: type,
  validFrom: from ?? DateTime.utc(2025, 9),
  validUntil: until,
  status: status,
);

void main() {
  group('cálculo', () {
    final due = DateTime.utc(2025, 10, 5);

    int total(List<Discount> l, {int amount = 10000, FeeType? t}) =>
        totalDiscountMinor(
          l,
          type: t ?? FeeType.tuition,
          due: due,
          amountMinor: amount,
        );

    test('percentagem e valor fixo, em aritmética inteira', () {
      expect(total([_d()]), 1000);
      expect(total([_d(value: 333)], amount: 1000), 33);
      expect(total([_d(kind: DiscountKind.fixed, value: 700)]), 700);
    });

    test('soma descontos (irmãos + mérito) sem passar do valor', () {
      expect(total([_d(), _d(kind: DiscountKind.fixed, value: 500)]), 1500);
      expect(total([_d(value: 8000), _d(value: 8000)]), 10000);
    });

    test('só aprovados, do tipo certo e dentro da validade', () {
      expect(total([_d(status: DiscountStatus.pending)]), 0);
      expect(total([_d(status: DiscountStatus.rejected)]), 0);
      expect(total([_d(type: FeeType.uniform)]), 0);
      expect(total([_d(type: FeeType.tuition)]), 1000);
      expect(total([_d(until: DateTime.utc(2025, 10, 4))]), 0);
      expect(total([_d(until: DateTime.utc(2025, 10, 5))]), 1000);
      expect(total([_d(from: DateTime.utc(2025, 10, 6))]), 0);
    });

    test('parsePercentBp', () {
      expect(parsePercentBp('12,5'), 1250);
      expect(parsePercentBp('100'), 10000);
      expect(parsePercentBp('0'), isNull);
      expect(parsePercentBp('101'), isNull);
      expect(parsePercentBp('x'), isNull);
    });
  });

  group('API mock', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(billingMockHandlersProvider),
              ref.watch(discountMockHandlersProvider),
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
    });

    Future<void> enroll(String student, String enrollment) async {
      (await container
              .read(billingPlanRepositoryProvider)
              .generateForEnrollment(
                EnrollmentConfirmed(
                  enrollmentId: enrollment,
                  studentId: student,
                  academicYearId: MockRef.academicYearId,
                  gradeId: MockRef.gradeId(3),
                  classroomId: MockRef.classroomId(3, 0),
                  type: 'new_enrollment',
                  feeMinor: 1700000,
                  occurredAt: DateTime.utc(2025, 9, 1),
                ),
              ))
          .getOrThrow();
    }

    Future<List<int>> chargeDiscounts(String student) async {
      final plan = container.read(billingPlanRepositoryProvider);
      final items = (await plan.charges(
        pageSize: 100,
        studentId: student,
      )).getOrThrow().items;
      return [for (final c in items) c.discountMinor];
    }

    Future<Discount> request({
      String student = 'stu-1',
      DiscountKind kind = DiscountKind.percentage,
      int value = 1000,
    }) async =>
        (await container
                .read(discountRepositoryProvider)
                .request(
                  studentId: student,
                  kind: kind,
                  reason: DiscountReason.sibling,
                  value: value,
                  feeType: FeeType.tuition,
                  validFrom: DateTime.utc(2025, 9),
                ))
            .getOrThrow();

    test('valida o pedido (422)', () async {
      final repo = container.read(discountRepositoryProvider);
      Future<Result<Discount>> bad(DiscountKind k, int v, {DateTime? until}) =>
          repo.request(
            studentId: 'stu-1',
            kind: k,
            reason: DiscountReason.merit,
            value: v,
            validFrom: DateTime.utc(2025, 9),
            validUntil: until,
          );
      expect((await bad(DiscountKind.percentage, 10001)).isErr, isTrue);
      expect((await bad(DiscountKind.fixed, 0)).isErr, isTrue);
      expect(
        (await bad(
          DiscountKind.fixed,
          100,
          until: DateTime.utc(2025, 8),
        )).isErr,
        isTrue,
      );
    });

    test(
      'pendente não afecta a cobrança; aprovar reflecte-se; revogar repõe',
      () async {
        await enroll('stu-1', 'enr-1');
        final repo = container.read(discountRepositoryProvider);
        final d = await request();
        expect(d.status, DiscountStatus.pending);
        expect((await chargeDiscounts('stu-1')).every((v) => v == 0), isTrue);

        final approved = (await repo.approve(d.id)).getOrThrow();
        expect(approved.status, DiscountStatus.approved);
        // A matrícula (outro tipo) fica intacta; as propinas têm 10 %.
        final after = await chargeDiscounts('stu-1');
        expect(after.where((v) => v > 0).length, tuitionInstallments);
        expect((await repo.approve(d.id)).isErr, isTrue);

        (await repo.revoke(d.id)).getOrThrow();
        expect((await chargeDiscounts('stu-1')).every((v) => v == 0), isTrue);
        expect((await repo.revoke(d.id)).isErr, isTrue);
      },
    );

    test(
      'rejeitado não se reflecte; cobranças novas usam o aprovado',
      () async {
        final repo = container.read(discountRepositoryProvider);
        final rejected = await request(student: 'stu-2');
        (await repo.reject(rejected.id)).getOrThrow();
        final ok = await request(
          student: 'stu-2',
          kind: DiscountKind.fixed,
          value: 100000,
        );
        (await repo.approve(ok.id)).getOrThrow();
        await enroll('stu-2', 'enr-2');
        final values = await chargeDiscounts('stu-2');
        expect(values.where((v) => v == 100000).length, tuitionInstallments);
      },
    );

    test('lista filtra por estado', () async {
      final repo = container.read(discountRepositoryProvider);
      final a = await request();
      await request(student: 'stu-2');
      (await repo.approve(a.id)).getOrThrow();
      final pending = (await repo.list(
        status: DiscountStatus.pending,
      )).getOrThrow();
      expect(pending.items.map((d) => d.studentId), ['stu-2']);
    });
  });
}
