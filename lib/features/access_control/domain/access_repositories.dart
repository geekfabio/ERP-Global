import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/access_models.dart';

/// Zonas de acesso; a UI só conhece esta interface.
abstract interface class ZoneRepository {
  Future<Result<PagedList<ZoneModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    String? campusId,
  });

  /// 409 se já existe uma zona com o mesmo nome no campus.
  Future<Result<ZoneModel>> create(ZoneModel zone);

  Future<Result<ZoneModel>> update(ZoneModel zone);

  /// 409 se a zona ainda tem regras ou dispositivos.
  Future<Result<void>> delete(String id);

  /// Campus disponíveis (`id → nome`), vindos de `/v1/campuses`.
  Future<Result<Map<String, String>>> campuses();
}

abstract interface class AccessRuleRepository {
  Future<Result<PagedList<AccessRuleModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
  });

  /// 422 se dias/horas forem inválidos; 404 se a zona não existe.
  Future<Result<AccessRuleModel>> create(AccessRuleModel rule);

  Future<Result<AccessRuleModel>> update(AccessRuleModel rule);

  Future<Result<void>> delete(String id);
}

abstract interface class AccessDeviceRepository {
  Future<Result<PagedList<AccessDeviceModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
  });

  Future<Result<AccessDeviceModel>> create(AccessDeviceModel device);

  Future<Result<AccessDeviceModel>> update(AccessDeviceModel device);

  Future<Result<void>> delete(String id);
}
