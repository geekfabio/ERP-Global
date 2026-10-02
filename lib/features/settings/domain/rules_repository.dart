import '../../../core/errors/result.dart';
import '../data/models/setting_model.dart';

/// Leitura com `core.settings.read`; escrita com `core.settings.update`.
abstract interface class RulesRepository {
  Future<Result<List<SettingModel>>> settings(SettingModule module);

  /// Grava vários valores do módulo de uma vez (`key` → valor); o servidor
  /// valida tipos, limites e regras entre campos (422 por campo).
  Future<Result<List<SettingModel>>> save(
    SettingModule module,
    Map<String, Object> values,
  );
}
