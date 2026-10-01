import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/database/app_database.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/sync/sync_binding.dart';
import 'package:erp_global/core/sync/sync_controller.dart';
import 'package:erp_global/core/sync/sync_indicator.dart';
import 'package:erp_global/core/sync/sync_mock_handlers.dart';
import 'package:erp_global/core/sync/sync_providers.dart';
import 'package:erp_global/core/sync/sync_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Binding implements SyncEntityBinding {
  @override
  String get entity => 'student';
  @override
  Future<void> markSynced(String id, Map<String, dynamic>? record) async {}
  @override
  Future<void> applyServer(String id, Map<String, dynamic> server) async {}
  @override
  Future<void> purge(String id) async {}
}

const _licensed = LicenseGate(enabledModules: {cloudSyncModule});

class _Env {
  _Env({LicenseGate gate = _licensed}) {
    db = AppDatabase(NativeDatabase.memory());
    handlers = SyncMockHandlers();
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: MockApiRegistry()..addModule(handlers),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
    container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(client),
        appDatabaseProvider.overrideWithValue(db),
        licenseGateProvider.overrideWithValue(gate),
        sessionPermissionsProvider.overrideWithValue(const ['*']),
        syncBindingsProvider.overrideWithValue([_Binding()]),
      ],
    );
  }

  late final AppDatabase db;
  late final SyncMockHandlers handlers;
  late final ApiClient client;
  late final ProviderContainer container;

  SyncController get controller =>
      container.read(syncControllerProvider.notifier);

  Future<void> close() async {
    container.dispose();
    await db.close();
  }

  Future<void> enqueueCreate(String id) => db
      .into(db.syncOutbox)
      .insert(
        SyncOutboxCompanion.insert(
          entity: 'student',
          entityId: id,
          operation: 'create',
          payload: Value(jsonEncode({'id': id, 'fullName': 'Ana'})),
          createdAt: DateTime.utc(2030, 1, 1, 9),
        ),
      );
}

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  group('modo efectivo', () {
    test('sem licença cloud_sync fica só local', () {
      expect(
        effectiveSyncMode(SyncMode.cloudSync, licensed: false),
        SyncMode.localOnly,
      );
      expect(
        effectiveSyncMode(SyncMode.cloudBackup, licensed: true),
        SyncMode.cloudBackup,
      );
    });

    test('SyncSettings faz round-trip JSON', () {
      final s = SyncSettings(
        mode: SyncMode.cloudBackup,
        auto: false,
        intervalMinutes: 30,
        lastSyncAt: DateTime.utc(2030, 1, 1),
      );
      final back = SyncSettings.fromJson(s.toJson());
      expect(back.mode, SyncMode.cloudBackup);
      expect(back.auto, isFalse);
      expect(back.intervalMinutes, 30);
      expect(back.lastSyncAt, DateTime.utc(2030, 1, 1));
    });
  });

  group('controller', () {
    test('sem licença nunca envia', () async {
      final env = _Env(gate: LicenseGate.none);
      addTearDown(env.close);
      await env.enqueueCreate('A');
      final report = await env.container.read(syncActionsProvider).syncNow();
      expect(report.synced, 0);
      expect(env.handlers.record('student', 'A'), isNull);
      expect(
        env.container.read(syncControllerProvider).mode,
        SyncMode.localOnly,
      );
    });

    test('só local não envia; cloud envia e guarda lastSyncAt', () async {
      final env = _Env();
      addTearDown(env.close);
      env.container.read(syncControllerProvider);
      await _settle();
      await env.enqueueCreate('A');

      expect((await env.controller.syncNow()).synced, 0);
      expect(env.handlers.record('student', 'A'), isNull);

      expect(
        await env.controller.update(
          const SyncSettings(mode: SyncMode.cloudSync, auto: false),
        ),
        isTrue,
      );
      final report = await env.controller.syncNow();
      expect(report.synced, 1);
      expect(env.handlers.record('student', 'A'), isNotNull);
      final state = env.container.read(syncControllerProvider);
      expect(state.settings.lastSyncAt, isNotNull);
      expect(state.running, isFalse);
    });

    test('a configuração persiste pela API e é relida', () async {
      final env = _Env();
      addTearDown(env.close);
      env.container.read(syncControllerProvider);
      await _settle();
      await env.controller.update(
        const SyncSettings(mode: SyncMode.cloudBackup, intervalMinutes: 30),
      );
      final loaded = await env.container
          .read(syncSettingsRepositoryProvider)
          .load();
      expect(loaded.valueOrNull?.mode, SyncMode.cloudBackup);
      expect(loaded.valueOrNull?.intervalMinutes, 30);
    });

    test('o servidor rejeita modo inválido', () async {
      final env = _Env();
      addTearDown(env.close);
      await expectLater(
        env.client.dio.put<dynamic>('/v1/sync/settings', data: {'mode': 'x'}),
        throwsA(anything),
      );
    });
  });

  group('indicador', () {
    Future<_Env> pump(WidgetTester tester, {LicenseGate? gate}) async {
      final env = _Env(gate: gate ?? _licensed);
      // O pedido de configuração tem de correr fora do relógio falso.
      await tester.runAsync(() async {
        env.container.read(syncControllerProvider);
        await _settle();
      });
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(env.close);
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: Center(child: SyncIndicator())),
          ),
        ),
      );
      await tester.pump();
      return env;
    }

    testWidgets('mostra "Local" por omissão', (tester) async {
      await pump(tester);
      expect(find.text('Local'), findsOneWidget);
    });

    testWidgets('sem licença os modos cloud ficam desactivados', (
      tester,
    ) async {
      await pump(tester, gate: LicenseGate.none);
      await tester.tap(find.byKey(const Key('sync_indicator')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Configurar…'));
      await tester.pumpAndSettle();
      final tile = tester.widget<RadioListTile<SyncMode>>(
        find.byKey(const Key('sync_mode_cloudSync')),
      );
      expect(tile.enabled, isFalse);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('sync_settings_save')))
            .onPressed,
        isNull,
      );
    });

    testWidgets('com licença escolhe cloud e o indicador muda', (tester) async {
      final env = await pump(tester);
      await tester.tap(find.byKey(const Key('sync_indicator')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Configurar…'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sync_mode_cloudSync')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sync_settings_save')));
      await tester.runAsync(_settle);
      await tester.pumpAndSettle();
      expect(find.text('Sincronizado'), findsOneWidget);
      // Cancela o temporizador automático antes de o teste terminar.
      await tester.pumpWidget(const SizedBox());
      env.container.dispose();
      await tester.pump(const Duration(milliseconds: 10));
    });
  });
}
