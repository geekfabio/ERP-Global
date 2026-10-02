import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_finance_mock_handlers.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_mock_handlers.dart';
import 'package:erp_global/features/portal/data/repositories/api_portal_finance_repository.dart';
import 'package:erp_global/features/portal/data/repositories/api_portal_repository.dart';
import 'package:erp_global/features/portal/domain/portal_finance_metrics.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_card_page.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_finance_page.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_summaries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer _container() {
  final auth = AuthMockHandlers();
  final students = StudentsMockHandlers(count: 60);
  final handlers = [
    auth,
    students,
    PortalMockHandlers(
      authenticate: auth.authenticate,
      pupilsFor: students.pupilsForPortalUser,
    ),
    PortalFinanceMockHandlers(
      authenticate: auth.authenticate,
      pupilsFor: students.pupilsForPortalUser,
    ),
  ];
  return ProviderContainer(
    overrides: [
      licenseGateProvider.overrideWithValue(
        LicenseGate(
          enabledModules: {'core', 'guardian_portal', 'billing', 'cards'},
        ),
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
      mockApiModulesProvider.overrideWithValue(handlers),
    ],
  );
}

Future<void> _login(ProviderContainer c, String profile) async {
  (await ApiAuthRepository(
        c.read(apiClientProvider),
        InMemorySessionStorage(),
      ).login(identifier: '$profile@erp-global.local', password: 'Dev@12345'))
      .getOrThrow();
}

void main() {
  group('API mock', () {
    late ProviderContainer c;
    late ApiPortalFinanceRepository repo;
    late String pupilId;

    setUp(() async {
      c = _container();
      await _login(c, 'encarregado');
      final client = c.read(apiClientProvider);
      repo = ApiPortalFinanceRepository(client);
      pupilId = (await ApiPortalRepository(
        client,
      ).pupils()).getOrThrow().first.student.id;
    });
    tearDown(() => c.dispose());

    test('conta corrente com cobranças e recibos só dos pagos', () async {
      final f = (await repo.finance(pupilId)).getOrThrow();
      expect(f.charges, isNotEmpty);
      expect(f.receipts.length, f.charges.where((x) => x.paidMinor > 0).length);
    });

    test('referência de pagamento cobre o valor em dívida', () async {
      final f = (await repo.finance(pupilId)).getOrThrow();
      final due = totalOutstandingMinor(f.charges);
      final r = (await repo.paymentReference(pupilId)).getOrThrow();
      expect(r.amountMinor, due);
      expect(r.reference, hasLength(9));
      final again = (await repo.paymentReference(pupilId)).getOrThrow();
      expect(again.reference, r.reference);
    });

    test('extracto do cartão é coerente com o saldo', () async {
      final card = (await repo.card(pupilId)).getOrThrow();
      expect(card.entries, isNotEmpty);
      expect(card.entries.first.balanceAfterMinor, card.balanceMinor);
      for (var i = 0; i + 1 < card.entries.length; i++) {
        final e = card.entries[i];
        expect(
          e.balanceAfterMinor - e.signedMinor,
          card.entries[i + 1].balanceAfterMinor,
        );
      }
      expect(card.entries.every((e) => e.balanceAfterMinor >= 0), isTrue);
    });

    test('educando não vinculado → 403 FORBIDDEN', () async {
      final other = _container();
      addTearDown(other.dispose);
      await _login(other, 'aluno');
      final otherId = (await ApiPortalRepository(
        other.read(apiClientProvider),
      ).pupils()).getOrThrow().single.student.id;
      expect((await repo.finance(otherId)).failureOrNull?.code, 'FORBIDDEN');
      expect((await repo.card(otherId)).failureOrNull?.code, 'FORBIDDEN');
      expect(
        (await repo.paymentReference(otherId)).failureOrNull?.code,
        'FORBIDDEN',
      );
    });
  });

  test('payableCharges ignora pagas e ordena por vencimento', () {
    StudentChargeLine line(
      String id,
      int day,
      StudentChargeStatus s,
      int paid,
    ) => StudentChargeLine(
      id: id,
      description: id,
      dueOn: DateTime.utc(2026, 1, day),
      amountMinor: 1000,
      paidMinor: paid,
      status: s,
    );
    final list = payableCharges([
      line('b', 9, StudentChargeStatus.overdue, 0),
      line('p', 1, StudentChargeStatus.paid, 1000),
      line('a', 5, StudentChargeStatus.partial, 400),
    ]);
    expect(list.map((x) => x.id), ['a', 'b']);
    expect(totalOutstandingMinor(list), 1600);
  });

  Future<void> pump(WidgetTester tester, Widget page) async {
    await PtAoFormatters.initialize();
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = _container();
    addTearDown(c.dispose);
    await tester.runAsync(() => _login(c, 'encarregado'));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: page),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('página de pagamentos mostra dívida, cobranças e recibos', (
    tester,
  ) async {
    await pump(tester, const PortalFinancePage());
    expect(find.text('Total em dívida'), findsOneWidget);
    expect(find.text('Cobranças'), findsOneWidget);
    expect(find.text('Referência de pagamento'), findsOneWidget);
    await tester.tap(find.text('Referência de pagamento'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Entidade: 11223'), findsOneWidget);
  });

  testWidgets('página do cartão mostra saldo, extracto e acessos', (
    tester,
  ) async {
    await pump(tester, const PortalCardPage());
    expect(find.text('Saldo do refeitório'), findsOneWidget);
    expect(find.text('Extracto'), findsOneWidget);
    expect(find.text('Entradas e saídas'), findsOneWidget);
  });
}
