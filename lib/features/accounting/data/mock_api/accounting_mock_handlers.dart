import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/accounting_seed.dart';
import '../models/accounting_models.dart';

/// Handlers de `/v1/accounts`, `/v1/fiscal-years` e `/v1/cost-centers`
/// (docs/07-mock-api.md). Estado mutável em memória; `POST /__mock/reset`
/// repõe o seed.
class AccountingMockHandlers implements MockApiModule {
  AccountingMockHandlers() {
    _reset();
  }

  late Map<String, AccountModel> _accounts;
  late Map<String, FiscalYearModel> _years;
  late Map<String, CostCenterModel> _centers;
  late SeedGenerator _ids;

  void _reset() {
    final s = buildAccountingSeed();
    _ids = SeedGenerator(610);
    _accounts = {for (final a in s.accounts) a.id: a};
    _years = {for (final y in s.fiscalYears) y.id: y};
    _centers = {for (final c in s.costCenters) c.id: c};
  }

  /// Leitura para outros handlers do módulo (lançamentos).
  Iterable<AccountModel> get accounts => _accounts.values;
  Iterable<FiscalYearModel> get fiscalYears => _years.values;

  String _newId() => _ids.ulid(DateTime.now().toUtc());

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/accounts', _listAccounts)
      ..post('/v1/accounts', _createAccount)
      ..patch('/v1/accounts/{id}', _updateAccount)
      ..delete('/v1/accounts/{id}', _deleteAccount)
      ..get('/v1/fiscal-years', _listYears)
      ..post('/v1/fiscal-years', _createYear)
      ..post('/v1/fiscal-years/{id}/close', _closeYear)
      ..get('/v1/cost-centers', _listCenters)
      ..post('/v1/cost-centers', _createCenter)
      ..patch('/v1/cost-centers/{id}', _updateCenter)
      ..delete('/v1/cost-centers/{id}', _deleteCenter);
  }

  // ---- Plano de contas --------------------------------------------------

  late final _accountSpec = MockListSpec<AccountModel>(
    searchText: (a) => '${a.code} ${a.name}',
    sortable: {'code': (a) => a.code, 'name': (a) => foldText(a.name)},
    filterable: {'type': (a) => a.type.name, 'parentId': (a) => a.parentId},
    defaultSort: const ['code'],
  );

  MockResponse _listAccounts(MockRequest req) => mockPaginate(
    _accounts.values,
    req,
    toJson: (a) => a.toJson(),
    spec: _accountSpec,
  );

  AccountModel _account(MockRequest req) =>
      _accounts[req.params['id']] ?? (throw const MockApiException.notFound());

  bool _hasChildren(String id) => _accounts.values.any((a) => a.parentId == id);

  MockResponse _createAccount(MockRequest req) {
    final body = req.jsonBody;
    final code = '${body['code'] ?? ''}'.trim();
    final parentId = body['parentId'] as String?;
    final parent = parentId == null ? null : _accounts[parentId];
    final type = AccountType.values
        .where((t) => t.name == body['type'])
        .firstOrNull;
    MockValidator(body)
      ..required('code')
      ..required('name')
      ..check(
        'code',
        code.isEmpty || RegExp(r'^\d+$').hasMatch(code),
        'Use apenas dígitos',
      )
      ..check(
        'parentId',
        parentId == null || parent != null,
        'Conta-mãe inválida',
      )
      ..check('type', parent != null || type != null, 'Natureza inválida')
      ..throwIfInvalid();
    if (parent != null &&
        (!code.startsWith(parent.code) || code.length <= parent.code.length)) {
      throw MockApiException.validation({
        'code': 'O código deve começar por ${parent.code}',
      });
    }
    if (_accounts.values.any((a) => a.code == code)) {
      throw const MockApiException.conflict(
        'Já existe uma conta com este código',
      );
    }
    final account = AccountModel(
      id: _newId(),
      code: code,
      name: '${body['name']}'.trim(),
      type: parent?.type ?? type!,
      parentId: parent?.id,
    );
    _accounts[account.id] = account;
    // Uma conta com subcontas deixa de ser movimentável.
    if (parent != null && parent.postable) {
      _accounts[parent.id] = parent.copyWith(postable: false);
    }
    return MockResponse.created(account.toJson());
  }

  MockResponse _updateAccount(MockRequest req) {
    final account = _account(req);
    final body = req.jsonBody;
    MockValidator(body)
      ..check(
        'name',
        !body.containsKey('name') || '${body['name']}'.trim().isNotEmpty,
        'Campo obrigatório',
      )
      ..check(
        'isActive',
        body['isActive'] == null || body['isActive'] is bool,
        'Valor inválido',
      )
      ..check(
        'postable',
        body['postable'] == null || body['postable'] is bool,
        'Valor inválido',
      )
      ..throwIfInvalid();
    if (body['postable'] == true && _hasChildren(account.id)) {
      throw const MockApiException.conflict(
        'Uma conta com subcontas não pode ser movimentável',
      );
    }
    final updated = account.copyWith(
      name: (body['name'] as String?)?.trim() ?? account.name,
      isActive: body['isActive'] as bool? ?? account.isActive,
      postable: body['postable'] as bool? ?? account.postable,
    );
    _accounts[account.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _deleteAccount(MockRequest req) {
    final account = _account(req);
    if (_hasChildren(account.id)) {
      throw const MockApiException.conflict(
        'Elimine ou mova primeiro as subcontas',
      );
    }
    _accounts.remove(account.id);
    return MockResponse.ok(null);
  }

  // ---- Exercícios -------------------------------------------------------

  late final _yearSpec = MockListSpec<FiscalYearModel>(
    sortable: {'startDate': (y) => y.startDate},
    filterable: {'status': (y) => y.status.name},
    defaultSort: const ['-startDate'],
  );

  MockResponse _listYears(MockRequest req) => mockPaginate(
    _years.values,
    req,
    toJson: (y) => y.toJson(),
    spec: _yearSpec,
  );

  MockResponse _createYear(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('name')
      ..required('startDate')
      ..required('endDate')
      ..throwIfInvalid();
    const dates = DateOnlyConverter();
    final DateTime start;
    final DateTime end;
    try {
      start = dates.fromJson('${body['startDate']}');
      end = dates.fromJson('${body['endDate']}');
    } on FormatException {
      throw const MockApiException.validation({'startDate': 'Data inválida'});
    }
    if (!end.isAfter(start)) {
      throw const MockApiException.validation({
        'endDate': 'O fim deve ser posterior ao início',
      });
    }
    final overlaps = _years.values.any(
      (y) => !start.isAfter(y.endDate) && !end.isBefore(y.startDate),
    );
    if (overlaps) {
      throw const MockApiException.conflict(
        'O período sobrepõe-se a outro exercício',
      );
    }
    final year = FiscalYearModel(
      id: _newId(),
      name: '${body['name']}'.trim(),
      startDate: start,
      endDate: end,
    );
    _years[year.id] = year;
    return MockResponse.created(year.toJson());
  }

  MockResponse _closeYear(MockRequest req) {
    final year =
        _years[req.params['id']] ?? (throw const MockApiException.notFound());
    if (year.status == FiscalYearStatus.closed) {
      throw const MockApiException.conflict('O exercício já está fechado');
    }
    final closed = year.copyWith(
      status: FiscalYearStatus.closed,
      closedAt: DateTime.now().toUtc(),
    );
    _years[year.id] = closed;
    return MockResponse.ok(closed.toJson());
  }

  // ---- Centros de custo -------------------------------------------------

  late final _centerSpec = MockListSpec<CostCenterModel>(
    searchText: (c) => '${c.code} ${c.name}',
    sortable: {'code': (c) => c.code, 'name': (c) => foldText(c.name)},
    filterable: {'isActive': (c) => c.isActive},
    defaultSort: const ['code'],
  );

  MockResponse _listCenters(MockRequest req) => mockPaginate(
    _centers.values,
    req,
    toJson: (c) => c.toJson(),
    spec: _centerSpec,
  );

  CostCenterModel _center(MockRequest req) =>
      _centers[req.params['id']] ?? (throw const MockApiException.notFound());

  MockResponse _createCenter(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('code')
      ..required('name')
      ..throwIfInvalid();
    final code = '${body['code']}'.trim().toUpperCase();
    if (_centers.values.any((c) => c.code == code)) {
      throw const MockApiException.conflict(
        'Já existe um centro com este código',
      );
    }
    final center = CostCenterModel(
      id: _newId(),
      code: code,
      name: '${body['name']}'.trim(),
    );
    _centers[center.id] = center;
    return MockResponse.created(center.toJson());
  }

  MockResponse _updateCenter(MockRequest req) {
    final center = _center(req);
    final body = req.jsonBody;
    MockValidator(body)
      ..check(
        'name',
        !body.containsKey('name') || '${body['name']}'.trim().isNotEmpty,
        'Campo obrigatório',
      )
      ..throwIfInvalid();
    final updated = center.copyWith(
      name: (body['name'] as String?)?.trim() ?? center.name,
      isActive: body['isActive'] as bool? ?? center.isActive,
    );
    _centers[center.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _deleteCenter(MockRequest req) {
    _centers.remove(_center(req).id);
    return MockResponse.ok(null);
  }
}
