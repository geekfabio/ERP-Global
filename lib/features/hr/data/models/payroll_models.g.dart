// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    _AttendanceRecord(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      date: json['date'] as String,
      status:
          $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']) ??
          AttendanceStatus.present,
    );

Map<String, dynamic> _$AttendanceRecordToJson(_AttendanceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'date': instance.date,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.late: 'late',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.justified: 'justified',
};

_LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => _LeaveModel(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  kind:
      $enumDecodeNullable(_$LeaveKindEnumMap, json['kind']) ??
      LeaveKind.vacation,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  days: (json['days'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LeaveModelToJson(_LeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'kind': _$LeaveKindEnumMap[instance.kind]!,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'days': instance.days,
    };

const _$LeaveKindEnumMap = {
  LeaveKind.vacation: 'vacation',
  LeaveKind.sick: 'sick',
  LeaveKind.other: 'other',
};

_IrtBracket _$IrtBracketFromJson(Map<String, dynamic> json) => _IrtBracket(
  from: (json['from'] as num).toInt(),
  rateBp: (json['rateBp'] as num).toInt(),
  fixedAmount: (json['fixedAmount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IrtBracketToJson(_IrtBracket instance) =>
    <String, dynamic>{
      'from': instance.from,
      'rateBp': instance.rateBp,
      'fixedAmount': instance.fixedAmount,
    };

_PayrollSettings _$PayrollSettingsFromJson(Map<String, dynamic> json) =>
    _PayrollSettings(
      inssEmployeeBp: (json['inssEmployeeBp'] as num?)?.toInt() ?? 300,
      inssEmployerBp: (json['inssEmployerBp'] as num?)?.toInt() ?? 800,
      vacationDaysPerYear: (json['vacationDaysPerYear'] as num?)?.toInt() ?? 22,
      workingDaysPerMonth: (json['workingDaysPerMonth'] as num?)?.toInt() ?? 22,
      irtBrackets:
          (json['irtBrackets'] as List<dynamic>?)
              ?.map((e) => IrtBracket.fromJson(e as Map<String, dynamic>))
              .toList() ??
          defaultIrtBrackets,
    );

Map<String, dynamic> _$PayrollSettingsToJson(_PayrollSettings instance) =>
    <String, dynamic>{
      'inssEmployeeBp': instance.inssEmployeeBp,
      'inssEmployerBp': instance.inssEmployerBp,
      'vacationDaysPerYear': instance.vacationDaysPerYear,
      'workingDaysPerMonth': instance.workingDaysPerMonth,
      'irtBrackets': instance.irtBrackets,
    };

_Payslip _$PayslipFromJson(Map<String, dynamic> json) => _Payslip(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  month: json['month'] as String,
  baseSalary: (json['baseSalary'] as num).toInt(),
  absenceDays: (json['absenceDays'] as num?)?.toInt() ?? 0,
  absenceDeduction: (json['absenceDeduction'] as num?)?.toInt() ?? 0,
  grossPay: (json['grossPay'] as num).toInt(),
  inssEmployee: (json['inssEmployee'] as num).toInt(),
  inssEmployer: (json['inssEmployer'] as num).toInt(),
  irt: (json['irt'] as num).toInt(),
  netPay: (json['netPay'] as num).toInt(),
);

Map<String, dynamic> _$PayslipToJson(_Payslip instance) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'month': instance.month,
  'baseSalary': instance.baseSalary,
  'absenceDays': instance.absenceDays,
  'absenceDeduction': instance.absenceDeduction,
  'grossPay': instance.grossPay,
  'inssEmployee': instance.inssEmployee,
  'inssEmployer': instance.inssEmployer,
  'irt': instance.irt,
  'netPay': instance.netPay,
};

_PayrollRunSummary _$PayrollRunSummaryFromJson(Map<String, dynamic> json) =>
    _PayrollRunSummary(
      month: json['month'] as String,
      count: (json['count'] as num).toInt(),
      totalGross: (json['totalGross'] as num).toInt(),
      totalNet: (json['totalNet'] as num).toInt(),
    );

Map<String, dynamic> _$PayrollRunSummaryToJson(_PayrollRunSummary instance) =>
    <String, dynamic>{
      'month': instance.month,
      'count': instance.count,
      'totalGross': instance.totalGross,
      'totalNet': instance.totalNet,
    };
