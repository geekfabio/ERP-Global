import 'package:freezed_annotation/freezed_annotation.dart';

part 'payroll_models.freezed.dart';
part 'payroll_models.g.dart';

/// Estado de assiduidade de um dia.
enum AttendanceStatus {
  @JsonValue('present')
  present('present', 'Presente'),
  @JsonValue('late')
  late('late', 'Atraso'),
  @JsonValue('absent')
  absent('absent', 'Falta injustificada'),
  @JsonValue('justified')
  justified('justified', 'Falta justificada');

  const AttendanceStatus(this.code, this.label);

  final String code;
  final String label;
}

/// Tipo de ausência prolongada.
enum LeaveKind {
  @JsonValue('vacation')
  vacation('vacation', 'Férias'),
  @JsonValue('sick')
  sick('sick', 'Baixa médica'),
  @JsonValue('other')
  other('other', 'Outra licença');

  const LeaveKind(this.code, this.label);

  final String code;
  final String label;
}

/// Registo diário de assiduidade (um por funcionário e dia).
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String id,
    required String employeeId,

    /// `AAAA-MM-DD`.
    required String date,
    @Default(AttendanceStatus.present) AttendanceStatus status,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}

/// Férias ou licença de um funcionário.
@freezed
abstract class LeaveModel with _$LeaveModel {
  const factory LeaveModel({
    required String id,
    required String employeeId,
    @Default(LeaveKind.vacation) LeaveKind kind,
    required String startDate,
    required String endDate,

    /// Dias úteis (calculado pelo servidor).
    @Default(0) int days,
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);
}

/// Escalão de IRT: acima de [from] paga [fixedAmount] + [rateBp] do excesso.
@freezed
abstract class IrtBracket with _$IrtBracket {
  const factory IrtBracket({
    /// Limite inferior (cêntimos).
    required int from,

    /// Taxa marginal em pontos base (1300 = 13%).
    required int rateBp,

    /// Parcela fixa (cêntimos).
    @Default(0) int fixedAmount,
  }) = _IrtBracket;

  factory IrtBracket.fromJson(Map<String, dynamic> json) =>
      _$IrtBracketFromJson(json);
}

/// Escalões de omissão (valores em cêntimos); configuráveis nas definições.
const defaultIrtBrackets = <IrtBracket>[
  IrtBracket(from: 0, rateBp: 0),
  IrtBracket(from: 10000000, rateBp: 1300),
  IrtBracket(from: 15000000, rateBp: 1600, fixedAmount: 650000),
  IrtBracket(from: 20000000, rateBp: 1800, fixedAmount: 1450000),
  IrtBracket(from: 30000000, rateBp: 1900, fixedAmount: 3250000),
];

/// Regras configuráveis da folha salarial.
@freezed
abstract class PayrollSettings with _$PayrollSettings {
  const factory PayrollSettings({
    /// INSS a cargo do trabalhador, em pontos base (300 = 3%).
    @Default(300) int inssEmployeeBp,

    /// INSS a cargo da entidade patronal, em pontos base.
    @Default(800) int inssEmployerBp,
    @Default(22) int vacationDaysPerYear,

    /// Divisor do salário para o desconto de faltas.
    @Default(22) int workingDaysPerMonth,
    @Default(defaultIrtBrackets) List<IrtBracket> irtBrackets,
  }) = _PayrollSettings;

  factory PayrollSettings.fromJson(Map<String, dynamic> json) =>
      _$PayrollSettingsFromJson(json);
}

/// Recibo de vencimento de um funcionário num mês. Tudo em cêntimos.
@freezed
abstract class Payslip with _$Payslip {
  const factory Payslip({
    required String id,
    required String employeeId,

    /// `AAAA-MM`.
    required String month,
    required int baseSalary,
    @Default(0) int absenceDays,
    @Default(0) int absenceDeduction,
    required int grossPay,
    required int inssEmployee,
    required int inssEmployer,
    required int irt,
    required int netPay,
  }) = _Payslip;

  factory Payslip.fromJson(Map<String, dynamic> json) =>
      _$PayslipFromJson(json);
}

/// Resultado do processamento da folha de um mês.
@freezed
abstract class PayrollRunSummary with _$PayrollRunSummary {
  const factory PayrollRunSummary({
    required String month,
    required int count,
    required int totalGross,
    required int totalNet,
  }) = _PayrollRunSummary;

  factory PayrollRunSummary.fromJson(Map<String, dynamic> json) =>
      _$PayrollRunSummaryFromJson(json);
}
