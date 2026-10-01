import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/hr_rules.dart';
import '../data_mocks/hr_seed.dart';
import '../models/hr_models.dart';

/// Handlers de `/v1/positions`, `/v1/employees` e `/v1/contracts`
/// (docs/07-mock-api.md). Estado em memória; `POST /__mock/reset` repõe o seed.
class HrMockHandlers implements MockApiModule {
  HrMockHandlers({this._clock}) {
    _reset();
  }

  final DateTime Function()? _clock;
  late SeedGenerator _ids;
  final Map<String, PositionModel> _positions = {};
  final Map<String, EmployeeModel> _employees = {};
  final Map<String, ContractModel> _contracts = {};
  int _nextNumber = 1;

  DateTime get _today => (_clock?.call() ?? DateTime.now()).toUtc();

  static final _employeeSpec = MockListSpec<EmployeeModel>(
    searchText: (e) => '${e.employeeNumber} ${e.fullName} ${e.email}',
    sortable: {
      'fullName': (e) => foldText(e.fullName),
      'employeeNumber': (e) => e.employeeNumber,
    },
    filterable: {
      'isActive': (e) => e.isActive,
      'positionId': (e) => e.positionId,
      'hasActiveContract': (e) => e.hasActiveContract,
      'teacherId': (e) => e.teacherId ?? '',
    },
    defaultSort: const ['fullName'],
  );

  static final _contractSpec = MockListSpec<ContractModel>(
    searchText: (c) => c.employeeId,
    sortable: {'startDate': (c) => c.startDate},
    filterable: {'employeeId': (c) => c.employeeId, 'type': (c) => c.type.code},
    defaultSort: const ['-startDate'],
  );

  static final _positionSpec = MockListSpec<PositionModel>(
    searchText: (p) => p.name,
    sortable: {'name': (p) => foldText(p.name)},
    filterable: {'category': (p) => p.category.name},
    defaultSort: const ['name'],
  );

  void _reset() {
    final seed = buildHrSeed();
    _ids = SeedGenerator(310);
    _positions
      ..clear()
      ..addEntries(seed.positions.map((p) => MapEntry(p.id, p)));
    _employees
      ..clear()
      ..addEntries(seed.employees.map((e) => MapEntry(e.id, e)));
    _contracts
      ..clear()
      ..addEntries(seed.contracts.map((c) => MapEntry(c.id, c)));
    _nextNumber = seed.employees.length + 1;
  }

  bool _hasActive(String employeeId) => _contracts.values.any(
    (c) => c.employeeId == employeeId && isContractActiveOn(c, _today),
  );

  EmployeeModel _view(EmployeeModel e) =>
      e.copyWith(hasActiveContract: _hasActive(e.id));

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      // Cargos
      ..get(
        '/v1/positions',
        (req) => mockPaginate(
          _positions.values,
          req,
          toJson: (p) => p.toJson(),
          spec: _positionSpec,
        ),
      )
      ..post('/v1/positions', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildPosition({...req.jsonBody, 'id': id});
        _positions[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/positions/{id}', (req) {
        final current = _find(_positions, req);
        final row = _buildPosition({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _positions[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/positions/{id}', (req) {
        final row = _find(_positions, req);
        if (_employees.values.any((e) => e.positionId == row.id)) {
          throw const MockApiException.conflict(
            'O cargo está atribuído a funcionários',
          );
        }
        _positions.remove(row.id);
        return MockResponse.ok(null);
      })
      // Funcionários
      ..get(
        '/v1/employees',
        (req) => mockPaginate(
          _employees.values.map(_view),
          req,
          toJson: (e) => e.toJson(),
          spec: _employeeSpec,
        ),
      )
      ..get(
        '/v1/employees/{id}',
        (req) => MockResponse.ok(_view(_find(_employees, req)).toJson()),
      )
      ..post('/v1/employees', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final built = _buildEmployee({
          ...req.jsonBody,
          'id': id,
          'employeeNumber': '',
        });
        final number = 'F${(_nextNumber++).toString().padLeft(4, '0')}';
        final row = built.copyWith(employeeNumber: number);
        _employees[id] = row;
        return MockResponse.created(_view(row).toJson());
      })
      ..patch('/v1/employees/{id}', (req) {
        final current = _find(_employees, req);
        final row = _buildEmployee({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
          'employeeNumber': current.employeeNumber,
        });
        _employees[current.id] = row;
        return MockResponse.ok(_view(row).toJson());
      })
      ..delete('/v1/employees/{id}', (req) {
        final row = _find(_employees, req);
        if (_contracts.values.any((c) => c.employeeId == row.id)) {
          throw const MockApiException.conflict(
            'O funcionário tem contratos registados; desactive-o em vez de eliminar',
          );
        }
        _employees.remove(row.id);
        return MockResponse.ok(null);
      })
      // Contratos
      ..get(
        '/v1/contracts',
        (req) => mockPaginate(
          _contracts.values,
          req,
          toJson: (c) => c.toJson(),
          spec: _contractSpec,
        ),
      )
      ..post('/v1/contracts', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildContract({...req.jsonBody, 'id': id});
        _contracts[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/contracts/{id}', (req) {
        final current = _find(_contracts, req);
        final row = _buildContract({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
          'employeeId': current.employeeId,
        });
        _contracts[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/contracts/{id}', (req) {
        _contracts.remove(_find(_contracts, req).id);
        return MockResponse.ok(null);
      });
  }

  T _find<T>(Map<String, T> rows, MockRequest req) =>
      rows[req.params['id']] ?? (throw const MockApiException.notFound());

  Map<String, dynamic> _trim(Map<String, dynamic> raw) => {
    for (final e in raw.entries)
      e.key: e.value is String ? (e.value as String).trim() : e.value,
  };

  PositionModel _buildPosition(Map<String, dynamic> raw) {
    final body = _trim(raw);
    MockValidator(body)
      ..required('name')
      ..check(
        'category',
        PositionCategory.values.any((c) => c.name == body['category']),
        'Categoria inválida',
      )
      ..throwIfInvalid();
    final name = foldText('${body['name']}');
    if (_positions.values.any(
      (p) => p.id != body['id'] && foldText(p.name) == name,
    )) {
      throw const MockApiException.conflict('Já existe um cargo com este nome');
    }
    return PositionModel.fromJson(body);
  }

  EmployeeModel _buildEmployee(Map<String, dynamic> raw) {
    final body = _trim(raw)
      ..remove('hasActiveContract')
      ..['teacherId'] = (raw['teacherId'] as String?)?.trim().isEmpty ?? true
          ? null
          : (raw['teacherId'] as String).trim();
    MockValidator(body)
      ..required('fullName')
      ..required('email')
      ..email('email')
      ..required('positionId')
      ..check(
        'positionId',
        _positions.containsKey(body['positionId']),
        'Cargo inválido',
      )
      ..check(
        'hireDate',
        parseIsoDate(body['hireDate'] as String?) != null,
        'Data inválida (AAAA-MM-DD)',
      )
      ..throwIfInvalid();
    final email = foldText('${body['email']}');
    if (_employees.values.any(
      (e) => e.id != body['id'] && foldText(e.email) == email,
    )) {
      throw const MockApiException.conflict(
        'Já existe um funcionário com este email',
      );
    }
    final teacherId = body['teacherId'];
    if (teacherId != null &&
        _employees.values.any(
          (e) => e.id != body['id'] && e.teacherId == teacherId,
        )) {
      throw const MockApiException.conflict(
        'Este professor já está ligado a outro funcionário',
      );
    }
    return EmployeeModel.fromJson(body);
  }

  ContractModel _buildContract(Map<String, dynamic> raw) {
    final body = _trim(raw);
    if (body['endDate'] == '') body['endDate'] = null;
    final start = parseIsoDate(body['startDate'] as String?);
    final end = parseIsoDate(body['endDate'] as String?);
    final salary = body['baseSalary'];
    final type = ContractType.values
        .where((t) => t.code == body['type'])
        .firstOrNull;
    MockValidator(body)
      ..required('employeeId')
      ..check(
        'employeeId',
        _employees.containsKey(body['employeeId']),
        'Funcionário inválido',
      )
      ..check('type', type != null, 'Tipo de contrato inválido')
      ..check('startDate', start != null, 'Data inválida (AAAA-MM-DD)')
      ..check(
        'endDate',
        body['endDate'] == null || end != null,
        'Data inválida (AAAA-MM-DD)',
      )
      ..check(
        'endDate',
        type == ContractType.permanent || body['endDate'] != null,
        'Indique a data de fim',
      )
      ..check(
        'endDate',
        start == null || end == null || !end.isBefore(start),
        'O fim não pode ser anterior ao início',
      )
      ..check(
        'baseSalary',
        salary is int && salary > 0,
        'Indique um salário base válido',
      )
      ..throwIfInvalid();
    final row = ContractModel.fromJson(body);
    if (_contracts.values.any(
      (c) =>
          c.id != row.id &&
          c.employeeId == row.employeeId &&
          contractsOverlap(c, row),
    )) {
      throw const MockApiException.conflict(
        'O funcionário já tem um contrato neste período',
      );
    }
    return row;
  }
}
