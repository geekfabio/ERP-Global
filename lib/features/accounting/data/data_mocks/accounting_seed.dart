import '../../../../core/utils/seed_generator.dart';
import '../models/accounting_models.dart';

/// Plano de contas (base PGC-AO), exercícios e centros de custo de
/// desenvolvimento (mesma seed → mesmos dados).
class AccountingSeed {
  const AccountingSeed({
    required this.accounts,
    required this.fiscalYears,
    required this.costCenters,
  });

  final List<AccountModel> accounts;
  final List<FiscalYearModel> fiscalYears;
  final List<CostCenterModel> costCenters;
}

/// (código, designação, natureza); a conta-mãe é o maior prefixo existente.
const _accountDefs = [
  ('1', 'Meios fixos e investimentos', AccountType.asset),
  ('11', 'Imobilizações corpóreas', AccountType.asset),
  ('111', 'Terrenos e recursos naturais', AccountType.asset),
  ('114', 'Equipamento básico', AccountType.asset),
  ('2', 'Existências', AccountType.asset),
  ('26', 'Mercadorias', AccountType.asset),
  ('3', 'Terceiros', AccountType.asset),
  ('31', 'Clientes', AccountType.asset),
  ('311', 'Clientes c/c — encarregados', AccountType.asset),
  ('32', 'Fornecedores', AccountType.liability),
  ('321', 'Fornecedores c/c', AccountType.liability),
  ('4', 'Meios monetários', AccountType.asset),
  ('43', 'Depósitos à ordem', AccountType.asset),
  ('45', 'Caixa', AccountType.asset),
  ('5', 'Capital', AccountType.equity),
  ('51', 'Capital social', AccountType.equity),
  ('6', 'Custos e perdas', AccountType.expense),
  ('62', 'Fornecimentos e serviços de terceiros', AccountType.expense),
  ('63', 'Custos com o pessoal', AccountType.expense),
  ('7', 'Proveitos e ganhos', AccountType.income),
  ('72', 'Prestações de serviços', AccountType.income),
  ('721', 'Propinas', AccountType.income),
  ('722', 'Matrículas e confirmações', AccountType.income),
  ('8', 'Resultados', AccountType.equity),
  ('81', 'Resultado do exercício', AccountType.equity),
];

const _costCenterDefs = [
  ('ADM', 'Administração'),
  ('PED', 'Pedagógico'),
  ('REF', 'Refeitório'),
  ('MNT', 'Manutenção'),
];

AccountingSeed buildAccountingSeed({int seed = 60}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2024, 1, 1);
  final byCode = <String, AccountModel>{};
  for (var i = 0; i < _accountDefs.length; i++) {
    final (code, name, type) = _accountDefs[i];
    final parent = [
      for (var n = code.length - 1; n > 0; n--)
        if (byCode[code.substring(0, n)] != null) byCode[code.substring(0, n)]!,
    ].firstOrNull;
    final isLeaf = !_accountDefs.any(
      (d) => d.$1 != code && d.$1.startsWith(code),
    );
    byCode[code] = AccountModel(
      id: gen.ulid(at.add(Duration(minutes: i))),
      code: code,
      name: name,
      type: type,
      parentId: parent?.id,
      postable: isLeaf,
    );
  }
  return AccountingSeed(
    accounts: byCode.values.toList(),
    fiscalYears: [
      for (var y = 2024; y <= 2026; y++)
        FiscalYearModel(
          id: gen.ulid(at.add(Duration(days: y))),
          name: 'Exercício $y',
          startDate: DateTime.utc(y),
          endDate: DateTime.utc(y, 12, 31),
          status: y < 2026 ? FiscalYearStatus.closed : FiscalYearStatus.open,
          closedAt: y < 2026 ? DateTime.utc(y + 1, 3, 31) : null,
        ),
    ],
    costCenters: [
      for (var i = 0; i < _costCenterDefs.length; i++)
        CostCenterModel(
          id: gen.ulid(at.add(Duration(hours: i))),
          code: _costCenterDefs[i].$1,
          name: _costCenterDefs[i].$2,
        ),
    ],
  );
}
