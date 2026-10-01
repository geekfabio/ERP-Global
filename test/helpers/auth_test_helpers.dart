import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/sync/sync_providers.dart';
import 'package:erp_global/core/sync/sync_settings.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

AuthSession fakeSession({
  List<String> roles = const ['super_admin'],
  List<String> permissions = const ['*'],
}) => AuthSession.fromJson({
  'user': {
    'id': '01JTESTUSER00000000000001',
    'institutionId': '01JINSTITUTION000000000001',
    'createdAt': '2026-01-01T00:00:00Z',
    'updatedAt': '2026-01-01T00:00:00Z',
    'name': 'Teste',
  },
  'roles': roles,
  'permissions': permissions,
  'license': <String, dynamic>{},
});

/// Estado de auth fixo (sem chamar repository nem armazenamento seguro).
class FixedAuthNotifier extends AuthNotifier {
  FixedAuthNotifier(this._session);

  final AuthSession? _session;

  @override
  Future<AuthSession?> build() async => _session;
}

/// Licença com todos os módulos do catálogo, sem avisos.
LicenseGate get fullLicenseGate =>
    LicenseGate(enabledModules: {for (final m in moduleCatalog) m.code});

/// Configuração de sync em memória e instantânea (sem pedidos nem timers),
/// para testes que montam o shell com a licença `cloud_sync`.
class _MemorySyncSettings implements SyncSettingsRepository {
  SyncSettings _value = const SyncSettings();

  @override
  Future<Result<SyncSettings>> load() async => Ok(_value);

  @override
  Future<Result<SyncSettings>> save(SyncSettings settings) async =>
      Ok(_value = settings);
}

Override syncSettingsOverride() =>
    syncSettingsRepositoryProvider.overrideWithValue(_MemorySyncSettings());

/// Fixa o estado da licença.
Override licenseOverride([LicenseGate? gate]) =>
    licenseGateProvider.overrideWithValue(gate ?? fullLicenseGate);

/// Sessão iniciada com [roles]/[permissions] (por omissão super_admin, tudo) e
/// licença completa (ou [gate]).
List<Override> signedInOverrides({
  List<String> roles = const ['super_admin'],
  List<String> permissions = const ['*'],
  LicenseGate? gate,
}) => [
  authStateProvider.overrideWith(
    () =>
        FixedAuthNotifier(fakeSession(roles: roles, permissions: permissions)),
  ),
  sessionPermissionsProvider.overrideWith(
    (ref) => ref.watch(currentSessionProvider)?.permissions,
  ),
  licenseOverride(gate),
  syncSettingsOverride(),
];

/// Sem sessão (mostra `/login`).
List<Override> signedOutOverrides() => [
  authStateProvider.overrideWith(() => FixedAuthNotifier(null)),
  sessionPermissionsProvider.overrideWith(
    (ref) => ref.watch(currentSessionProvider)?.permissions,
  ),
  licenseOverride(),
  syncSettingsOverride(),
];

/// Só as permissões (sem router/auth), para testar menu e widgets; licença completa.
List<Override> permissionsOnly(List<String> codes, {LicenseGate? gate}) => [
  sessionPermissionsProvider.overrideWithValue(codes),
  licenseOverride(gate),
  syncSettingsOverride(),
];
