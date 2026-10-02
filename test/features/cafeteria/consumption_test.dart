import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/cafeteria/data/models/consumption_rows.dart';
import 'package:erp_global/features/cafeteria/data/models/wallet.dart';
import 'package:erp_global/features/cafeteria/domain/consumption.dart';
import 'package:erp_global/features/cafeteria/presentation/pages/cafeteria_page.dart';
import 'package:erp_global/features/cafeteria/presentation/providers/consumption_providers.dart';
import 'package:erp_global/features/cafeteria/presentation/providers/menu_providers.dart';
import 'package:erp_global/features/cafeteria/presentation/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

WalletTransaction _tx(
  String id,
  WalletTransactionType type,
  int amount,
  DateTime at, {
  String? cls,
  String? meal,
  String? refundOf,
}) => WalletTransaction(
  id: id,
  walletId: 'w',
  type: type,
  amountMinor: amount,
  balanceAfterMinor: 0,
  occurredAt: at,
  className: cls,
  mealTypeId: meal,
  refundOfId: refundOf,
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('buildConsumption', () {
    const p = WalletTransactionType.purchase;
    final d1 = DateTime.utc(2025, 9, 1, 12);
    final d2 = DateTime.utc(2025, 9, 2, 12);
    final txs = [
      _tx('a', p, 100, d1, cls: '7.ª A', meal: 'm1'),
      _tx('b', p, 300, d1, cls: '7.ª B', meal: 'm2'),
      _tx('c', p, 50, d2, cls: '7.ª A', meal: 'm1'),
      _tx('d', p, 70, d2),
      _tx('r', WalletTransactionType.refund, 50, d2, refundOf: 'c'),
      _tx('t', WalletTransactionType.topup, 999, d1),
    ];

    test('por turma exclui estornos e recargas', () {
      final rows = buildConsumption(
        transactions: txs,
        group: ConsumptionGroup.classroom,
      );
      expect(rows.map((r) => r.key), ['', '7.ª A', '7.ª B']);
      expect(rows[1].totalMinor, 100);
      expect(rows[1].purchaseCount, 1);
      expect(rows[0].totalMinor, 70);
    });

    test('por dia em ordem cronológica e com filtro de datas', () {
      final all = buildConsumption(
        transactions: txs,
        group: ConsumptionGroup.day,
      );
      expect(all.map((r) => r.key), ['2025-09-01', '2025-09-02']);
      expect(all.map((r) => r.totalMinor), [400, 70]);
      final one = buildConsumption(
        transactions: txs,
        group: ConsumptionGroup.day,
        from: DateTime.utc(2025, 9, 2),
      );
      expect(one.map((r) => r.key), ['2025-09-02']);
    });

    test('por refeição ordena por valor e resolve o nome', () {
      final rows = buildConsumption(
        transactions: txs,
        group: ConsumptionGroup.meal,
        mealName: (id) => 'Nome $id',
      );
      expect(rows.first.key, 'm2');
      expect(rows.first.label, 'Nome m2');
    });

    test('saldo pré-pago soma as carteiras', () {
      final now = DateTime.utc(2025);
      Wallet w(int b, {bool blocked = false}) => Wallet(
        id: '$b',
        holderId: 'h',
        holderName: 'n',
        balanceMinor: b,
        blocked: blocked,
        createdAt: now,
        updatedAt: now,
      );
      final b = buildPrepaidBalance([w(100), w(250, blocked: true)]);
      expect(b.totalBalanceMinor, 350);
      expect(b.walletCount, 2);
      expect(b.blockedCount, 1);
    });
  });

  group('API mock e página', () {
    ProviderContainer container(List<String> permissions, {ExportHandler? ex}) {
      final c = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          if (ex != null) ...[
            exportHandlerProvider.overrideWithValue(ex),
            licenseGateProvider.overrideWithValue(
              const LicenseGate(enabledModules: {'import_export'}),
            ),
          ],
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(walletMockHandlersProvider),
              ref.watch(menuMockHandlersProvider),
              ref.watch(consumptionMockHandlersProvider),
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

    test('endpoints devolvem consumo e saldo do seed', () async {
      final c = container(['cafeteria.*']);
      final repo = c.read(consumptionRepositoryProvider);
      final byClass = (await repo.consumption(
        group: ConsumptionGroup.classroom,
      )).getOrThrow();
      expect(byClass.map((r) => r.key), ['7.ª A', '7.ª B', '8.ª A']);
      final byMeal = (await repo.consumption(
        group: ConsumptionGroup.meal,
      )).getOrThrow();
      expect(byMeal.map((r) => r.label), containsAll(['Almoço', 'Lanche']));
      // 12 carteiras: 12 × (80000 + 30000) consumidos.
      expect(byMeal.fold<int>(0, (s, r) => s + r.totalMinor), 12 * 110000);
      final balance = (await repo.prepaidBalance()).getOrThrow();
      expect(balance.walletCount, 12);
      final wallets = c.read(walletMockHandlersProvider).allWallets;
      expect(
        balance.totalBalanceMinor,
        wallets.fold<int>(0, (s, w) => s + w.balanceMinor),
      );
    });

    test('intervalo invertido dá 422', () async {
      final c = container(['cafeteria.*']);
      final r = await c
          .read(consumptionRepositoryProvider)
          .consumption(
            group: ConsumptionGroup.day,
            from: DateTime.utc(2025, 9, 5),
            to: DateTime.utc(2025, 9, 1),
          );
      expect(r.failureOrNull, isNotNull);
    });

    Future<void> pump(WidgetTester tester, ProviderContainer c) async {
      tester.view.physicalSize = const Size(1600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: CafeteriaPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Consumo'));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra consumo, saldo e exporta', (tester) async {
      ExportDataset? got;
      final c = container(
        ['cafeteria.*'],
        ex: (d, f) async {
          got = d;
        },
      );
      await pump(tester, c);
      expect(find.byKey(const Key('prepaid_total')), findsOneWidget);
      expect(find.byKey(const Key('consumption_total')), findsOneWidget);
      expect(find.text('7.ª A'), findsOneWidget);

      await tester.tap(find.byTooltip('Exportar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CSV'));
      await tester.pumpAndSettle();
      expect(got!.permission, consumptionExportPermission);
      expect(got!.columns.map((c) => c.label), contains('Consumos'));
    });

    testWidgets('sem permissão de leitura não mostra relatórios', (
      tester,
    ) async {
      await pump(tester, container(['cafeteria.wallet.read']));
      expect(find.byKey(const Key('prepaid_total')), findsNothing);
      expect(find.text('Sem permissão para os relatórios'), findsOneWidget);
    });
  });
}
