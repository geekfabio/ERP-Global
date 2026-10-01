import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/accounting/data/mock_api/accounting_mock_handlers.dart';
import 'package:erp_global/features/accounting/data/models/accounting_models.dart';
import 'package:erp_global/features/accounting/data/repositories/api_accounting_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

({
  ApiAccountRepository accounts,
  ApiFiscalYearRepository years,
  ApiCostCenterRepository centers,
})
_env() {
  final registry = MockApiRegistry()..addModule(AccountingMockHandlers());
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return (
    accounts: ApiAccountRepository(client),
    years: ApiFiscalYearRepository(client),
    centers: ApiCostCenterRepository(client),
  );
}

AccountModel _draft(String code, {String? parentId, AccountType? type}) =>
    AccountModel(
      id: '',
      code: code,
      name: 'Conta $code',
      type: type ?? AccountType.asset,
      parentId: parentId,
    );

void main() {
  group('plano de contas', () {
    test('lista o seed ordenado por código, com hierarquia', () async {
      final r = _env().accounts;
      final all = (await r.list()).getOrThrow().items;
      expect(all, isNotEmpty);
      expect(all.first.code, '1');
      final byId = {for (final a in all) a.id: a};
      for (final a in all.where((a) => a.parentId != null)) {
        expect(a.code.startsWith(byId[a.parentId]!.code), isTrue);
      }
    });

    test(
      'cria subconta herdando natureza e torna a mãe não movimentável',
      () async {
        final r = _env().accounts;
        final all = (await r.list()).getOrThrow().items;
        final parent = all.firstWhere((a) => a.code == '45');
        expect(parent.postable, isTrue);
        final child = (await r.create(
          _draft('451', parentId: parent.id, type: AccountType.income),
        )).getOrThrow();
        expect(child.type, parent.type);
        final after = (await r.list()).getOrThrow().items;
        expect(after.firstWhere((a) => a.id == parent.id).postable, isFalse);
      },
    );

    test('valida campos, prefixo do código e duplicados', () async {
      final r = _env().accounts;
      final all = (await r.list()).getOrThrow().items;
      final cash = all.firstWhere((a) => a.code == '45');
      expect((await r.create(_draft(''))).failureOrNull?.message, isNotNull);
      expect((await r.create(_draft('99', parentId: cash.id))).isErr, isTrue);
      final dup = await r.create(_draft('45'));
      expect(dup.isErr, isTrue);
    });

    test('actualiza, não elimina com subcontas e elimina folhas', () async {
      final r = _env().accounts;
      final all = (await r.list()).getOrThrow().items;
      final group = all.firstWhere((a) => a.code == '72');
      expect((await r.delete(group.id)).isErr, isTrue);
      expect(
        (await r.update(group.id, postable: true)).isErr,
        isTrue,
        reason: 'conta com subcontas não é movimentável',
      );
      final renamed = (await r.update(
        group.id,
        name: 'Serviços',
        isActive: false,
      )).getOrThrow();
      expect(renamed.name, 'Serviços');
      expect(renamed.isActive, isFalse);
      final leaf = all.firstWhere((a) => a.code == '721');
      expect((await r.delete(leaf.id)).isOk, isTrue);
      expect(
        (await r.list()).getOrThrow().items.any((a) => a.id == leaf.id),
        isFalse,
      );
    });
  });

  group('exercícios', () {
    FiscalYearModel draft(DateTime s, DateTime e) =>
        FiscalYearModel(id: '', name: 'Ex', startDate: s, endDate: e);

    test('cria, rejeita sobreposição e período inválido, e fecha', () async {
      final r = _env().years;
      final list = (await r.list()).getOrThrow().items;
      expect(list.first.status, FiscalYearStatus.open, reason: 'mais recente');
      final created = (await r.create(
        draft(DateTime.utc(2027), DateTime.utc(2027, 12, 31)),
      )).getOrThrow();
      expect(created.status, FiscalYearStatus.open);
      expect(
        (await r.create(
          draft(DateTime.utc(2027, 6), DateTime.utc(2028, 6)),
        )).isErr,
        isTrue,
      );
      expect(
        (await r.create(
          draft(DateTime.utc(2030, 5), DateTime.utc(2030, 1)),
        )).isErr,
        isTrue,
      );
      final closed = (await r.close(created.id)).getOrThrow();
      expect(closed.status, FiscalYearStatus.closed);
      expect(closed.closedAt, isNotNull);
      expect((await r.close(created.id)).isErr, isTrue);
    });
  });

  group('centros de custo', () {
    test('CRUD com código único', () async {
      final r = _env().centers;
      final c = (await r.create(
        const CostCenterModel(id: '', code: 'lab', name: 'Laboratório'),
      )).getOrThrow();
      expect(c.code, 'LAB');
      expect(
        (await r.create(
          const CostCenterModel(id: '', code: 'LAB', name: 'Outro'),
        )).isErr,
        isTrue,
      );
      final off = (await r.update(c.id, isActive: false)).getOrThrow();
      expect(off.isActive, isFalse);
      expect((await r.delete(c.id)).isOk, isTrue);
      expect((await r.delete(c.id)).isErr, isTrue);
    });
  });
}
