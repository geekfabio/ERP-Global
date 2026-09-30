import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/modules/module_registry.dart';
import '../data/models/license_model.dart';
import 'license_status.dart';
import 'license_verifier.dart';

/// Persistência local da licença e do último instante visto.
abstract interface class LicenseStore {
  Future<String?> readLicense();
  Future<void> writeLicense(String json);
  Future<DateTime?> readLastSeen();
  Future<void> writeLastSeen(DateTime value);
}

class InMemoryLicenseStore implements LicenseStore {
  String? _license;
  DateTime? _lastSeen;

  @override
  Future<String?> readLicense() async => _license;
  @override
  Future<void> writeLicense(String json) async => _license = json;
  @override
  Future<DateTime?> readLastSeen() async => _lastSeen;
  @override
  Future<void> writeLastSeen(DateTime value) async => _lastSeen = value;
}

class SecureLicenseStore implements LicenseStore {
  SecureLicenseStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readLicense() => _storage.read(key: 'erp_license');
  @override
  Future<void> writeLicense(String json) =>
      _storage.write(key: 'erp_license', value: json);
  @override
  Future<DateTime?> readLastSeen() async {
    final v = await _storage.read(key: 'erp_license_last_seen');
    return v == null ? null : DateTime.tryParse(v);
  }

  @override
  Future<void> writeLastSeen(DateTime value) => _storage.write(
    key: 'erp_license_last_seen',
    value: value.toUtc().toIso8601String(),
  );
}

/// Resultado de tentar instalar uma licença.
sealed class ActivationResult {
  const ActivationResult();
}

class Activated extends ActivationResult {
  const Activated(this.license, this.status);
  final LicenseModel license;
  final LicenseStatus status;
}

class ActivationRejected extends ActivationResult {
  const ActivationRejected(this.reason);
  final String reason;
}

/// Serviço de licenciamento 100 % offline: valida assinatura, datas, limites e
/// dependências de módulos (docs/02-modulos-e-licenciamento.md).
class LicenseService {
  LicenseService({
    required this.store,
    required this.registry,
    LicenseVerifier? verifier,
    DateTime Function()? now,
  }) : _verifier = verifier ?? LicenseVerifier(),
       _now = now ?? DateTime.now;

  final LicenseStore store;
  final ModuleRegistry registry;
  final LicenseVerifier _verifier;
  final DateTime Function() _now;

  LicenseModel? _license;
  LicenseStatus _status = const LicenseStatus(LicenseState.missing);

  LicenseModel? get license => _license;
  LicenseStatus get status => _status;

  /// Lê a licença guardada, revalida-a e actualiza o estado.
  Future<LicenseStatus> load() async {
    final raw = await store.readLicense();
    if (raw == null) {
      return _set(null, const LicenseStatus(LicenseState.missing));
    }
    final parsed = _tryParse(raw);
    if (parsed == null || !await _verifier.verify(parsed)) {
      return _set(null, const LicenseStatus(LicenseState.invalid));
    }
    return _set(parsed, await _evaluate(parsed));
  }

  /// Instala [rawJson] se a assinatura for válida; caso contrário mantém a actual.
  Future<ActivationResult> activate(String rawJson) async {
    final parsed = _tryParse(rawJson);
    if (parsed == null) return const ActivationRejected('Licença ilegível');
    if (!await _verifier.verify(parsed)) {
      return const ActivationRejected('Assinatura inválida');
    }
    final current = _license;
    if (current != null && parsed.institutionId != current.institutionId) {
      return const ActivationRejected('Licença de outra instituição');
    }
    await store.writeLicense(rawJson);
    final status = _set(parsed, await _evaluate(parsed));
    return Activated(parsed, status);
  }

  /// Regista o instante actual como "visto" (chamar ao arrancar e periodicamente).
  Future<void> touch() async {
    final last = await store.readLastSeen();
    final now = _now().toUtc();
    if (last == null || now.isAfter(last)) await store.writeLastSeen(now);
  }

  Future<LicenseStatus> _evaluate(LicenseModel license) async {
    final status = evaluateLicense(
      license,
      now: _now(),
      lastSeen: await store.readLastSeen(),
    );
    // Só avança o relógio de referência quando não há suspeita de recuo.
    if (status.state != LicenseState.clockTampered) await touch();
    return status;
  }

  LicenseStatus _set(LicenseModel? license, LicenseStatus status) {
    _license = license;
    return _status = status;
  }

  LicenseModel? _tryParse(String raw) {
    try {
      return LicenseModel.parse(raw);
    } on FormatException {
      return null;
    }
  }

  /// Módulos activos: os da licença mais dependências e obrigatórios; vazio se
  /// não houver licença válida.
  Set<String> get enabledModules {
    final l = _license;
    if (l == null || !_status.canRead) return const {};
    return registry.closure(l.modules);
  }

  bool isModuleEnabled(String code) => enabledModules.contains(code);

  /// Dependências em falta na lista explícita da licença (deve estar vazio).
  Map<String, List<String>> get licenseDependencyProblems {
    final l = _license;
    return l == null ? const {} : registry.missingDependencies(l.modules);
  }

  /// Limite contratado para [key] (`students`, `users`, `campuses`, `devices`);
  /// `null` = ilimitado.
  int? limitOf(String key) => _license?.limits[key];

  /// Pode-se criar mais um registo em [key] dado o [current] já existente?
  /// Nunca apaga dados: apenas impede novos registos além do contratado.
  bool canAdd(String key, int current) {
    if (!_status.canWrite) return false;
    final limit = limitOf(key);
    return limit == null || current < limit;
  }
}
