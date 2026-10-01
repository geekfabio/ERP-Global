import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/inventory_models.dart';

/// Contrato dos bens patrimoniais; a UI só conhece esta interface.
abstract interface class AssetRepository {
  Future<Result<PagedList<AssetModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    AssetStatus? status,
  });

  /// Regista um bem; 409 se o número de património já existe.
  Future<Result<AssetModel>> create(AssetModel asset);

  /// Altera responsável e/ou localização; 409 num bem abatido.
  Future<Result<AssetModel>> reassign(
    String id, {
    String? custodian,
    String? location,
  });

  /// Abate o bem (terminal); 409 se já abatido ou com manutenção em curso.
  Future<Result<AssetModel>> writeOff(String id, {required String reason});

  Future<Result<List<MaintenanceModel>>> maintenance(String id);

  /// Abre uma manutenção e coloca o bem `in_maintenance`.
  Future<Result<MaintenanceModel>> scheduleMaintenance(
    String id, {
    required String description,
    required DateTime scheduledOn,
    int costCents = 0,
  });

  /// Conclui a manutenção; o bem volta a `active` se não houver outras abertas.
  Future<Result<MaintenanceModel>> completeMaintenance(
    String assetId,
    String maintenanceId,
  );
}

/// Contrato do stock de consumíveis.
abstract interface class StockRepository {
  /// [lowOnly] devolve só os itens em alerta (abaixo/igual ao mínimo).
  Future<Result<PagedList<StockItemModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    bool lowOnly = false,
  });

  Future<Result<StockItemModel>> create(StockItemModel item);

  /// Entrada (`delta > 0`) ou saída (`delta < 0`); 409 se ficar negativo.
  Future<Result<StockItemModel>> move(
    String id, {
    required int delta,
    required String reason,
  });
}
