import '../../../../core/utils/seed_generator.dart';
import '../models/inventory_models.dart';

/// Bens, manutenções e consumíveis de desenvolvimento (mesma seed → mesmos dados).
class InventorySeed {
  const InventorySeed({
    required this.assets,
    required this.maintenance,
    required this.stock,
  });

  final List<AssetModel> assets;
  final List<MaintenanceModel> maintenance;
  final List<StockItemModel> stock;
}

const _assetTypes = [
  ('Secretária', 'Mobiliário', 4500000),
  ('Cadeira de professor', 'Mobiliário', 1500000),
  ('Quadro branco', 'Mobiliário', 3500000),
  ('Computador portátil', 'Informática', 32000000),
  ('Projector', 'Informática', 18000000),
  ('Impressora', 'Informática', 9500000),
  ('Gerador', 'Equipamento', 85000000),
  ('Frigorífico', 'Equipamento', 24000000),
];

const _locations = [
  'Secretaria',
  'Sala 1',
  'Sala 2',
  'Laboratório',
  'Biblioteca',
  'Refeitório',
  'Direcção',
];

const _stockTypes = [
  ('Resma de papel A4', 'resma'),
  ('Marcador de quadro', 'un'),
  ('Giz', 'cx'),
  ('Toner', 'un'),
  ('Detergente', 'l'),
  ('Papel higiénico', 'pack'),
  ('Caneta esferográfica', 'cx'),
  ('Sabonete', 'un'),
];

InventorySeed buildInventorySeed({int seed = 72, int assetCount = 30}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 9, 1);
  final assets = <AssetModel>[];
  final maintenance = <MaintenanceModel>[];
  for (var i = 0; i < assetCount; i++) {
    final (name, category, value) = _assetTypes[i % _assetTypes.length];
    final id = gen.ulid(at.add(Duration(minutes: i)));
    final inMaintenance = i % 9 == 4;
    final writtenOff = i % 11 == 10;
    assets.add(
      AssetModel(
        id: id,
        tag: 'PAT-${(1000 + i).toString()}',
        name: name,
        category: category,
        location: gen.random.pick(_locations),
        custodian: gen.fullName(),
        status: writtenOff
            ? AssetStatus.writtenOff
            : inMaintenance
            ? AssetStatus.inMaintenance
            : AssetStatus.active,
        acquiredOn: DateTime.utc(2022 + i % 4, 1 + i % 12, 1 + i % 27),
        valueCents: value,
        writeOffReason: writtenOff ? 'Fim de vida útil' : null,
        writtenOffAt: writtenOff ? at.add(Duration(days: i)) : null,
      ),
    );
    if (inMaintenance) {
      maintenance.add(
        MaintenanceModel(
          id: gen.ulid(at.add(Duration(hours: i))),
          assetId: id,
          description: 'Revisão geral',
          scheduledOn: DateTime.utc(2025, 10, 1 + i % 27),
          costCents: 500000,
        ),
      );
    }
  }
  final stock = <StockItemModel>[
    for (var i = 0; i < _stockTypes.length; i++)
      () {
        final (name, unit) = _stockTypes[i];
        final min = 5 + gen.random.nextInt(10);
        // Cada terceiro item fica abaixo do mínimo (alerta).
        final quantity = i % 3 == 0
            ? min - 2
            : min + 5 + gen.random.nextInt(40);
        return StockItemModel(
          id: gen.ulid(at.add(Duration(days: i))),
          sku: 'CON-${(100 + i).toString()}',
          name: name,
          unit: unit,
          quantity: quantity,
          minQuantity: min,
          location: 'Armazém',
          lowStock: quantity <= min,
        );
      }(),
  ];
  return InventorySeed(assets: assets, maintenance: maintenance, stock: stock);
}
