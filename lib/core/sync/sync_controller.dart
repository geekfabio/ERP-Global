import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/result.dart';
import '../modules/license_gate.dart';
import 'sync_engine.dart';
import 'sync_providers.dart';
import 'sync_settings.dart';

/// Estado do sync para a UI (indicador da topbar e ecrã de configuração).
class SyncUiState {
  const SyncUiState({
    this.settings = const SyncSettings(),
    this.licensed = false,
    this.running = false,
    this.lastReport,
    this.saveError,
  });

  final SyncSettings settings;
  final bool licensed;
  final bool running;
  final SyncReport? lastReport;
  final String? saveError;

  SyncMode get mode => effectiveSyncMode(settings.mode, licensed: licensed);

  SyncUiState copyWith({
    SyncSettings? settings,
    bool? running,
    SyncReport? lastReport,
    String? saveError,
  }) => SyncUiState(
    settings: settings ?? this.settings,
    licensed: licensed,
    running: running ?? this.running,
    lastReport: lastReport ?? this.lastReport,
    saveError: saveError,
  );
}

/// Orquestra modo, sync manual e automático sobre o [SyncEngine]. Sem licença
/// `cloud_sync` nunca lê configuração, nunca agenda nem envia nada.
class SyncController extends Notifier<SyncUiState> {
  Timer? _timer;

  @override
  SyncUiState build() {
    final licensed = ref
        .watch(enabledModulesProvider)
        .contains(cloudSyncModule);
    ref.onDispose(() => _timer?.cancel());
    final initial = SyncUiState(licensed: licensed);
    if (licensed) unawaited(_load());
    return initial;
  }

  Future<void> _load() async {
    final result = await ref.read(syncSettingsRepositoryProvider).load();
    if (!ref.mounted) return;
    if (result case Ok(:final value)) {
      state = state.copyWith(settings: value);
      _schedule();
    }
  }

  /// Reagenda o temporizador conforme o modo em vigor e a opção automática.
  void _schedule() {
    _timer?.cancel();
    _timer = null;
    final s = state.settings;
    if (!state.mode.usesCloud || !s.auto) return;
    _timer = Timer.periodic(
      Duration(minutes: s.intervalMinutes),
      (_) => unawaited(syncNow()),
    );
  }

  /// Sincroniza já. Em modo só local não faz nada (relatório vazio).
  Future<SyncReport> syncNow() async {
    if (!state.mode.usesCloud || state.running) return const SyncReport();
    state = state.copyWith(running: true);
    final SyncReport report;
    try {
      report = await ref.read(syncEngineProvider).run();
    } finally {
      if (ref.mounted) state = state.copyWith(running: false);
    }
    if (!ref.mounted) return report;
    state = state.copyWith(lastReport: report);
    if (!report.offline && !report.authRequired) {
      await _save(state.settings.copyWith(lastSyncAt: DateTime.now().toUtc()));
    }
    return report;
  }

  /// Altera modo/automático/intervalo; só fica em vigor se a API aceitar.
  Future<bool> update(SyncSettings settings) async {
    final ok = await _save(settings);
    if (ok) _schedule();
    return ok;
  }

  Future<bool> _save(SyncSettings settings) async {
    final result = await ref
        .read(syncSettingsRepositoryProvider)
        .save(settings);
    if (!ref.mounted) return false;
    switch (result) {
      case Ok(:final value):
        state = state.copyWith(settings: value);
        return true;
      case Err(:final failure):
        state = state.copyWith(saveError: failure.message);
        return false;
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncUiState>(
  SyncController.new,
);
