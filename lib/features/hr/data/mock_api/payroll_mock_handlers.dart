import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/hr_rules.dart';
import '../../domain/payroll_rules.dart';
import '../data_mocks/payroll_seed.dart';
import '../models/hr_models.dart';
import '../models/payroll_models.dart';

/// Handlers de `/v1/hr-attendance`, `/v1/leaves`, `/v1/payroll-settings`,
/// `/v1/payroll-runs` e `/v1/payslips` (docs/07-mock-api.md). Os funcionários
/// e contratos vêm do módulo RH através de [employeesOf] e [contractsOf].
class PayrollMockHandlers implements MockApiModule {
  PayrollMockHandlers({required this.employeesOf, required this.contractsOf}) {
    _reset();
  }

  final List<EmployeeModel> Function() employeesOf;
  final List<ContractModel> Function() contractsOf;

  late SeedGenerator _ids;
  final Map<String, AttendanceRecord> _attendance = {};
  final Map<String, LeaveModel> _leaves = {};
  final Map<String, Payslip> _payslips = {};
  PayrollSettings _settings = const PayrollSettings();

  static final _attendanceSpec = MockListSpec<AttendanceRecord>(
    searchText: (a) => a.employeeId,
    sortable: {'date': (a) => a.date},
    filterable: {
      'employeeId': (a) => a.employeeId,
      'status': (a) => a.status.code,
      'month': (a) => a.date.substring(0, 7),
    },
    defaultSort: const ['-date'],
  );

  static final _leaveSpec = MockListSpec<LeaveModel>(
    searchText: (l) => l.employeeId,
    sortable: {'startDate': (l) => l.startDate},
    filterable: {'employeeId': (l) => l.employeeId, 'kind': (l) => l.kind.code},
    defaultSort: const ['-startDate'],
  );

  static final _payslipSpec = MockListSpec<Payslip>(
    searchText: (p) => p.employeeId,
    sortable: {'netPay': (p) => p.netPay, 'month': (p) => p.month},
    filterable: {'employeeId': (p) => p.employeeId, 'month': (p) => p.month},
    defaultSort: const ['-month'],
  );

  void _reset() {
    _ids = SeedGenerator(320);
    final seed = buildPayrollSeed(employeesOf());
    _attendance
      ..clear()
      ..addEntries(seed.attendance.map((a) => MapEntry(a.id, a)));
    _leaves
      ..clear()
      ..addEntries(seed.leaves.map((l) => MapEntry(l.id, l)));
    _payslips.clear();
    _settings = const PayrollSettings();
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      // Assiduidade
      ..get(
        '/v1/hr-attendance',
        (req) => mockPaginate(
          _attendance.values,
          req,
          toJson: (a) => a.toJson(),
          spec: _attendanceSpec,
        ),
      )
      ..post('/v1/hr-attendance', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildAttendance({...req.jsonBody, 'id': id});
        _attendance[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/hr-attendance/{id}', (req) {
        final current = _find(_attendance, req);
        final row = _buildAttendance({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _attendance[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/hr-attendance/{id}', (req) {
        _attendance.remove(_find(_attendance, req).id);
        return MockResponse.ok(null);
      })
      // Férias e licenças
      ..get(
        '/v1/leaves',
        (req) => mockPaginate(
          _leaves.values,
          req,
          toJson: (l) => l.toJson(),
          spec: _leaveSpec,
        ),
      )
      ..post('/v1/leaves', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildLeave({...req.jsonBody, 'id': id});
        _leaves[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/leaves/{id}', (req) {
        final current = _find(_leaves, req);
        final row = _buildLeave({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _leaves[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/leaves/{id}', (req) {
        _leaves.remove(_find(_leaves, req).id);
        return MockResponse.ok(null);
      })
      // Regras da folha
      ..get(
        '/v1/payroll-settings',
        (req) => MockResponse.ok(_settings.toJson()),
      )
      ..patch('/v1/payroll-settings', (req) {
        _settings = _buildSettings({..._settings.toJson(), ...req.jsonBody});
        return MockResponse.ok(_settings.toJson());
      })
      // Processamento e recibos
      ..post('/v1/payroll-runs', (req) {
        final month = '${req.jsonBody['month'] ?? ''}'.trim();
        MockValidator({'month': month})
          ..check('month', monthStart(month) != null, 'Mês inválido (AAAA-MM)')
          ..throwIfInvalid();
        return MockResponse.created(_run(month).toJson());
      })
      ..get(
        '/v1/payslips',
        (req) => mockPaginate(
          _payslips.values,
          req,
          toJson: (p) => p.toJson(),
          spec: _payslipSpec,
        ),
      );
  }

  T _find<T>(Map<String, T> rows, MockRequest req) =>
      rows[req.params['id']] ?? (throw const MockApiException.notFound());

  /// Recalcula os recibos do mês: só funcionários activos com contrato no mês;
  /// as faltas injustificadas descontam ao salário.
  PayrollRunSummary _run(String month) {
    final contracts = contractsOf();
    _payslips.removeWhere((_, p) => p.month == month);
    for (final e in employeesOf().where((e) => e.isActive)) {
      final contract = contracts
          .where((c) => c.employeeId == e.id && contractCoversMonth(c, month))
          .firstOrNull;
      if (contract == null) continue;
      final absences = _attendance.values
          .where(
            (a) =>
                a.employeeId == e.id &&
                a.date.startsWith(month) &&
                a.status == AttendanceStatus.absent,
          )
          .length;
      final id = _ids.ulid(DateTime.now().toUtc());
      _payslips[id] = computePayslip(
        id: id,
        employeeId: e.id,
        month: month,
        baseSalary: contract.baseSalary,
        absenceDays: absences,
        settings: _settings,
      );
    }
    final rows = _payslips.values.where((p) => p.month == month);
    return PayrollRunSummary(
      month: month,
      count: rows.length,
      totalGross: rows.fold(0, (a, p) => a + p.grossPay),
      totalNet: rows.fold(0, (a, p) => a + p.netPay),
    );
  }

  bool _employeeExists(Object? id) => employeesOf().any((e) => e.id == id);

  AttendanceRecord _buildAttendance(Map<String, dynamic> body) {
    final status = AttendanceStatus.values
        .where((s) => s.code == body['status'])
        .firstOrNull;
    MockValidator(body)
      ..required('employeeId')
      ..check(
        'employeeId',
        _employeeExists(body['employeeId']),
        'Funcionário inválido',
      )
      ..check(
        'date',
        parseIsoDate(body['date'] as String?) != null,
        'Data inválida (AAAA-MM-DD)',
      )
      ..check('status', status != null, 'Estado inválido')
      ..throwIfInvalid();
    final row = AttendanceRecord.fromJson(body);
    if (_attendance.values.any(
      (a) =>
          a.id != row.id &&
          a.employeeId == row.employeeId &&
          a.date == row.date,
    )) {
      throw const MockApiException.conflict(
        'Já existe um registo de assiduidade para este dia',
      );
    }
    return row;
  }

  LeaveModel _buildLeave(Map<String, dynamic> raw) {
    final body = {...raw}..remove('days');
    final start = parseIsoDate(body['startDate'] as String?);
    final end = parseIsoDate(body['endDate'] as String?);
    final kind = LeaveKind.values
        .where((k) => k.code == body['kind'])
        .firstOrNull;
    MockValidator(body)
      ..required('employeeId')
      ..check(
        'employeeId',
        _employeeExists(body['employeeId']),
        'Funcionário inválido',
      )
      ..check('kind', kind != null, 'Tipo inválido')
      ..check('startDate', start != null, 'Data inválida (AAAA-MM-DD)')
      ..check('endDate', end != null, 'Data inválida (AAAA-MM-DD)')
      ..check(
        'endDate',
        start == null || end == null || !end.isBefore(start),
        'O fim não pode ser anterior ao início',
      )
      ..throwIfInvalid();
    final days = countWorkdays(start!, end!);
    if (days == 0) {
      throw const MockApiException.validation({
        'endDate': 'O período não tem dias úteis',
      });
    }
    final row = LeaveModel.fromJson({...body, 'days': days});
    final others = _leaves.values.where(
      (l) => l.id != row.id && l.employeeId == row.employeeId,
    );
    if (others.any(
      (l) =>
          l.startDate.compareTo(row.endDate) <= 0 &&
          l.endDate.compareTo(row.startDate) >= 0,
    )) {
      throw const MockApiException.conflict(
        'O funcionário já tem férias ou licença neste período',
      );
    }
    if (row.kind == LeaveKind.vacation) {
      final balance = vacationBalance(
        _settings,
        _leaves.values,
        row.employeeId,
        start.year,
        excludeLeaveId: row.id,
      );
      if (days > balance) {
        throw MockApiException.conflict(
          'Saldo de férias insuficiente: restam $balance dias úteis em ${start.year}',
        );
      }
    }
    return row;
  }

  PayrollSettings _buildSettings(Map<String, dynamic> body) {
    final s = PayrollSettings.fromJson(body);
    final brackets = s.irtBrackets;
    MockValidator(body)
      ..check(
        'inssEmployeeBp',
        s.inssEmployeeBp >= 0 && s.inssEmployeeBp <= 10000,
        'Taxa entre 0 e 10000 pontos base',
      )
      ..check(
        'inssEmployerBp',
        s.inssEmployerBp >= 0 && s.inssEmployerBp <= 10000,
        'Taxa entre 0 e 10000 pontos base',
      )
      ..check(
        'vacationDaysPerYear',
        s.vacationDaysPerYear > 0 && s.vacationDaysPerYear <= 365,
        'Valor inválido',
      )
      ..check(
        'workingDaysPerMonth',
        s.workingDaysPerMonth > 0 && s.workingDaysPerMonth <= 31,
        'Valor inválido',
      )
      ..check(
        'irtBrackets',
        brackets.isNotEmpty &&
            brackets.first.from == 0 &&
            [
              for (var i = 1; i < brackets.length; i++)
                brackets[i].from > brackets[i - 1].from,
            ].every((ok) => ok) &&
            brackets.every(
              (b) => b.rateBp >= 0 && b.rateBp <= 10000 && b.fixedAmount >= 0,
            ),
        'Escalões inválidos: o primeiro começa em 0 e os limites crescem',
      )
      ..throwIfInvalid();
    return s;
  }
}
