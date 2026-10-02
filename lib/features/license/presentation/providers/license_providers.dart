import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/modules/module_catalog.dart';
import '../../data/data_mocks/dev_license.dart';
import '../../domain/license_service.dart';
import '../../domain/license_status.dart';

final licenseStoreProvider = Provider<LicenseStore>(
  (ref) => SecureLicenseStore(),
);

/// Serviço de licenciamento (offline).
final licenseServiceProvider = Provider<LicenseService>(
  (ref) => LicenseService(
    store: ref.watch(licenseStoreProvider),
    registry: ref.watch(moduleRegistryProvider),
  ),
);

/// Estado da licença num instante.
class LicenseSnapshot {
  const LicenseSnapshot(this.status, this.enabledModules);

  final LicenseStatus status;
  final Set<String> enabledModules;
}

/// Carrega (e valida) a licença no arranque; em modo mock sem licença instalada
/// activa a licença de desenvolvimento.
class LicenseController extends AsyncNotifier<LicenseSnapshot> {
  @override
  Future<LicenseSnapshot> build() async {
    final service = ref.read(licenseServiceProvider);
    try {
      var status = await service.load().timeout(const Duration(seconds: 8));
      if (status.state == LicenseState.missing &&
          AppConfig.useMockApi &&
          !kReleaseMode) {
        await service.activate(devLicenseJson);
        status = service.status;
      }
    } catch (_) {
      // Armazenamento indisponível: sem licença válida (só módulos obrigatórios).
    }
    return _snapshot(service);
  }

  /// Instala uma nova licença (ecrã de licença, #25).
  Future<ActivationResult> activate(String rawJson) async {
    final service = ref.read(licenseServiceProvider);
    final result = await service.activate(rawJson);
    state = AsyncData(_snapshot(service));
    return result;
  }

  LicenseSnapshot _snapshot(LicenseService s) =>
      LicenseSnapshot(s.status, s.enabledModules);
}

final licenseControllerProvider =
    AsyncNotifierProvider<LicenseController, LicenseSnapshot>(
      LicenseController.new,
    );

/// Dias em que o aviso "a expirar" aparece antes do fim da validade.
const licenseExpiryWarningDays = 30;

/// Converte o estado da licença no [LicenseGate] que o `core` consome.
LicenseGate gateFor(LicenseSnapshot snapshot) {
  final status = snapshot.status;
  String days(int n) => n == 1 ? '1 dia' : '$n dias';
  final banner = switch (status.state) {
    LicenseState.active
        when (status.daysLeft ?? 999) <= licenseExpiryWarningDays =>
      LicenseBanner(
        LicenseBannerLevel.info,
        'A licença expira em ${days(status.daysLeft!)}. Contacte a equipa comercial para renovar.',
      ),
    LicenseState.grace => LicenseBanner(
      LicenseBannerLevel.warning,
      'Licença expirada: restam ${days(status.daysLeft ?? 0)} de período de graça. Depois a app fica em modo só leitura.',
    ),
    LicenseState.readOnly => const LicenseBanner(
      LicenseBannerLevel.danger,
      'Licença expirada: modo só leitura. Os dados estão seguros; renove a licença para editar.',
    ),
    LicenseState.clockTampered => const LicenseBanner(
      LicenseBannerLevel.danger,
      'O relógio do sistema foi recuado: modo só leitura até ser corrigido.',
    ),
    LicenseState.missing => const LicenseBanner(
      LicenseBannerLevel.danger,
      'Sem licença. Active uma licença em Definições.',
    ),
    LicenseState.invalid => const LicenseBanner(
      LicenseBannerLevel.danger,
      'Licença inválida ou adulterada. Active uma licença válida em Definições.',
    ),
    _ => null,
  };
  return LicenseGate(
    enabledModules: snapshot.enabledModules,
    readOnly: !status.canWrite,
    banner: banner,
  );
}

/// Liga o [licenseGateProvider] do core ao serviço (override em `main.dart`).
final licenseGateFromServiceProvider = Provider<LicenseGate>((ref) {
  final snapshot = ref.watch(licenseControllerProvider);
  return snapshot.when(
    data: gateFor,
    loading: () => LicenseGate.loadingGate,
    error: (_, _) => LicenseGate.none,
  );
});
