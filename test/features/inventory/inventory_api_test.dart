import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/inventory/data/mock_api/inventory_mock_handlers.dart';
import 'package:erp_global/features/inventory/data/models/inventory_models.dart';
import 'package:erp_global/features/inventory/data/repositories/api_inventory_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

({ApiAssetRepository assets, ApiStockRepository stock}) _env() {
  final registry = MockApiRegistry()..addModule(InventoryMockHandlers());
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return (
    assets: ApiAssetRepository(client),
    stock: ApiStockRepository(client),
  );
}

AssetModel _draft([String tag = 'pat-9001']) => AssetModel(
  id: '',
  tag: tag,
  name: 'Mesa',
  category: 'Mobiliário',
  location: 'Sala 1',
  custodian: 'Ana Silva',
  acquiredOn: DateTime.utc(2025, 3, 10),
  valueCents: 1250000,
);

StockItemModel _item({int quantity = 10, int min = 5, String sku = 'x-1'}) =>
    StockItemModel(
      id: '',
      sku: sku,
      name: 'Giz',
      unit: 'cx',
      quantity: quantity,
      minQuantity: min,
      location: 'Armazém',
    );

void main() {
  group('bens', () {
    test('lista paginada e filtro por estado', () async {
      final r = _env().assets;
      final page = (await r.list(pageSize: 10)).getOrThrow();
      expect(page.items, hasLength(10));
      expect(page.meta.total, 30);
      final off = (await r.list(status: AssetStatus.writtenOff)).getOrThrow();
      expect(off.items, isNotEmpty);
      expect(
        off.items.every((a) => a.status == AssetStatus.writtenOff),
        isTrue,
      );
    });

    test('criar: normaliza o n.º, 409 em duplicado e 422 em vazio', () async {
      final r = _env().assets;
      final a = (await r.create(_draft())).getOrThrow();
      expect(a.tag, 'PAT-9001');
      expect(a.valueCents, 1250000);
      expect((await r.create(_draft())).failureOrNull?.code, 'CONFLICT');
      final bad = await r.create(_draft('').copyWith(name: ''));
      expect(bad.failureOrNull?.code, 'VALIDATION_ERROR');
    });

    test('reatribuir responsável e localização', () async {
      final r = _env().assets;
      final a = (await r.create(_draft())).getOrThrow();
      final b = (await r.reassign(
        a.id,
        custodian: 'Rui',
        location: 'Lab',
      )).getOrThrow();
      expect((b.custodian, b.location), ('Rui', 'Lab'));
      final missing = await r.reassign('01JNAOEXISTE0000000000000A');
      expect(missing.failureOrNull?.code, 'NOT_FOUND');
    });

    test('manutenção: in_maintenance e volta a activo ao concluir', () async {
      final r = _env().assets;
      final a = (await r.create(_draft())).getOrThrow();
      final m = (await r.scheduleMaintenance(
        a.id,
        description: 'Revisão',
        scheduledOn: DateTime.utc(2026, 1, 5),
        costCents: 5000,
      )).getOrThrow();
      Future<AssetStatus> status() async =>
          (await r.list(q: 'PAT-9001')).getOrThrow().items.single.status;
      expect(await status(), AssetStatus.inMaintenance);
      expect(
        (await r.writeOff(a.id, reason: 'Avaria')).failureOrNull?.code,
        'CONFLICT',
      );
      await r.completeMaintenance(a.id, m.id);
      expect(await status(), AssetStatus.active);
      expect(
        (await r.completeMaintenance(a.id, m.id)).failureOrNull?.code,
        'CONFLICT',
      );
      expect((await r.maintenance(a.id)).getOrThrow().single.costCents, 5000);
    });

    test('abate é terminal e exige motivo', () async {
      final r = _env().assets;
      final a = (await r.create(_draft())).getOrThrow();
      expect(
        (await r.writeOff(a.id, reason: ' ')).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
      final off = (await r.writeOff(a.id, reason: 'Obsoleto')).getOrThrow();
      expect(off.status, AssetStatus.writtenOff);
      expect(off.writtenOffAt, isNotNull);
      expect(
        (await r.writeOff(a.id, reason: 'Outra')).failureOrNull?.code,
        'CONFLICT',
      );
      expect(
        (await r.reassign(a.id, location: 'x')).failureOrNull?.code,
        'CONFLICT',
      );
      final late = await r.scheduleMaintenance(
        a.id,
        description: 'x',
        scheduledOn: DateTime.utc(2026, 1, 1),
      );
      expect(late.failureOrNull?.code, 'CONFLICT');
    });
  });

  group('stock', () {
    test('seed tem itens em alerta; lowOnly só devolve esses', () async {
      final s = _env().stock;
      final all = (await s.list(pageSize: 100)).getOrThrow().items;
      final low = (await s.list(lowOnly: true)).getOrThrow().items;
      expect(low, isNotEmpty);
      expect(low.length, all.where((i) => i.quantity <= i.minQuantity).length);
      expect(low.every((i) => i.lowStock), isTrue);
    });

    test('movimentos actualizam o alerta de stock mínimo', () async {
      final s = _env().stock;
      final item = (await s.create(_item())).getOrThrow();
      expect(item.sku, 'X-1');
      expect(item.lowStock, isFalse);
      final out = (await s.move(
        item.id,
        delta: -6,
        reason: 'Consumo',
      )).getOrThrow();
      expect((out.quantity, out.lowStock), (4, true));
      final back = (await s.move(
        item.id,
        delta: 10,
        reason: 'Compra',
      )).getOrThrow();
      expect((back.quantity, back.lowStock), (14, false));
    });

    test('validações: saída acima do stock, zero e SKU duplicado', () async {
      final s = _env().stock;
      final item = (await s.create(_item(quantity: 3))).getOrThrow();
      expect(
        (await s.move(item.id, delta: -4, reason: 'x')).failureOrNull?.code,
        'CONFLICT',
      );
      expect(
        (await s.move(item.id, delta: 0, reason: 'x')).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
      expect(
        (await s.create(_item(quantity: 3))).failureOrNull?.code,
        'CONFLICT',
      );
      expect(
        (await s.create(_item(quantity: -1, sku: 'y'))).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
    });
  });
}
