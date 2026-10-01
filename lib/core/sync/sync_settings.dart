import '../errors/result.dart';
import '../network/api_client.dart';
import '../network/api_envelope.dart';

/// Código do módulo que licencia qualquer sincronização com a cloud.
const cloudSyncModule = 'cloud_sync';

/// Como os dados saem do dispositivo.
enum SyncMode {
  /// Nada sai do dispositivo (único modo sem licença `cloud_sync`).
  localOnly,

  /// Envia as alterações para a cloud como cópia de segurança.
  cloudBackup,

  /// Sincronização cloud entre dispositivos (licenciada).
  cloudSync;

  bool get usesCloud => this != SyncMode.localOnly;

  static SyncMode parse(Object? raw) => SyncMode.values.firstWhere(
    (m) => m.name == raw,
    orElse: () => SyncMode.localOnly,
  );
}

/// Modo em vigor: sem licença `cloud_sync` fica sempre só local, qualquer que
/// seja a configuração guardada.
SyncMode effectiveSyncMode(SyncMode configured, {required bool licensed}) =>
    licensed ? configured : SyncMode.localOnly;

/// Intervalos (minutos) oferecidos para a sincronização automática.
const syncIntervalOptions = [5, 15, 30, 60];

/// Configuração de sincronização da instituição (`/v1/sync/settings`).
class SyncSettings {
  const SyncSettings({
    this.mode = SyncMode.localOnly,
    this.auto = true,
    this.intervalMinutes = 15,
    this.lastSyncAt,
  });

  factory SyncSettings.fromJson(Map<String, dynamic> json) => SyncSettings(
    mode: SyncMode.parse(json['mode']),
    auto: json['auto'] as bool? ?? true,
    intervalMinutes: json['intervalMinutes'] as int? ?? 15,
    lastSyncAt: DateTime.tryParse(json['lastSyncAt'] as String? ?? '')?.toUtc(),
  );

  final SyncMode mode;

  /// Sincronização automática periódica (além da manual).
  final bool auto;
  final int intervalMinutes;
  final DateTime? lastSyncAt;

  SyncSettings copyWith({
    SyncMode? mode,
    bool? auto,
    int? intervalMinutes,
    DateTime? lastSyncAt,
  }) => SyncSettings(
    mode: mode ?? this.mode,
    auto: auto ?? this.auto,
    intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
  );

  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'auto': auto,
    'intervalMinutes': intervalMinutes,
    'lastSyncAt': lastSyncAt?.toUtc().toIso8601String(),
  };
}

/// Leitura e gravação da configuração de sincronização.
abstract interface class SyncSettingsRepository {
  Future<Result<SyncSettings>> load();
  Future<Result<SyncSettings>> save(SyncSettings settings);
}

/// [SyncSettingsRepository] sobre a API (`GET/PUT /v1/sync/settings`).
class ApiSyncSettingsRepository implements SyncSettingsRepository {
  ApiSyncSettingsRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<SyncSettings>> load() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/sync/settings');
    return ApiEnvelope.object(response, SyncSettings.fromJson);
  });

  @override
  Future<Result<SyncSettings>> save(SyncSettings settings) =>
      Result.guard(() async {
        final response = await _client.dio.put<dynamic>(
          '/v1/sync/settings',
          data: settings.toJson(),
        );
        return ApiEnvelope.object(response, SyncSettings.fromJson);
      });
}
