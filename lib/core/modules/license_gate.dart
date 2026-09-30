import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'module_catalog.dart';

enum LicenseBannerLevel { info, warning, danger }

/// Aviso de licença mostrado no topo do shell.
class LicenseBanner {
  const LicenseBanner(this.level, this.message);

  final LicenseBannerLevel level;
  final String message;
}

/// Vista da licença para o resto da app. O `core` não conhece `features/license`:
/// a app liga este gate ao serviço de licenciamento em `main.dart`.
class LicenseGate {
  const LicenseGate({
    this.enabledModules = const {},
    this.readOnly = false,
    this.banner,
    this.loading = false,
  });

  /// Sem licença válida: só os módulos obrigatórios (para poder activar uma).
  static const none = LicenseGate();

  /// A ler/validar a licença no arranque (não decidir acessos ainda).
  static const loadingGate = LicenseGate(loading: true);

  final bool loading;

  /// Módulos licenciados (já com dependências).
  final Set<String> enabledModules;

  /// Licença fora da validade/graça (ou relógio recuado): só consultas.
  final bool readOnly;
  final LicenseBanner? banner;
}

final licenseGateProvider = Provider<LicenseGate>((ref) => LicenseGate.none);

/// Módulos disponíveis = licenciados ∪ obrigatórios (`core`). Fonte única para
/// menu, router e providers: módulo desligado não aparece nem tem rotas.
final enabledModulesProvider = Provider<Set<String>>((ref) {
  final gate = ref.watch(licenseGateProvider);
  final required = ref.watch(moduleRegistryProvider).requiredCodes;
  return {...gate.enabledModules, ...required};
});

/// Só leitura (licença expirada após a graça, ou relógio recuado).
final licenseReadOnlyProvider = Provider<bool>(
  (ref) => ref.watch(licenseGateProvider).readOnly,
);
