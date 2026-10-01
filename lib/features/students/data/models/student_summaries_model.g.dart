// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_summaries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubjectGrades _$SubjectGradesFromJson(Map<String, dynamic> json) =>
    _SubjectGrades(
      subject: json['subject'] as String,
      term1: (json['term1'] as num?)?.toDouble(),
      term2: (json['term2'] as num?)?.toDouble(),
      term3: (json['term3'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SubjectGradesToJson(_SubjectGrades instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'term1': instance.term1,
      'term2': instance.term2,
      'term3': instance.term3,
    };

_BulletinRef _$BulletinRefFromJson(Map<String, dynamic> json) => _BulletinRef(
  id: json['id'] as String,
  label: json['label'] as String,
  issuedOn: const DateOnlyConverter().fromJson(json['issuedOn'] as String),
);

Map<String, dynamic> _$BulletinRefToJson(_BulletinRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'issuedOn': const DateOnlyConverter().toJson(instance.issuedOn),
    };

_StudentGradesSummary _$StudentGradesSummaryFromJson(
  Map<String, dynamic> json,
) => _StudentGradesSummary(
  subjects:
      (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectGrades.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SubjectGrades>[],
  bulletins:
      (json['bulletins'] as List<dynamic>?)
          ?.map((e) => BulletinRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BulletinRef>[],
);

Map<String, dynamic> _$StudentGradesSummaryToJson(
  _StudentGradesSummary instance,
) => <String, dynamic>{
  'subjects': instance.subjects.map((e) => e.toJson()).toList(),
  'bulletins': instance.bulletins.map((e) => e.toJson()).toList(),
};

_AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    _AttendanceRecord(
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      kind: $enumDecode(_$AttendanceKindEnumMap, json['kind']),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AttendanceRecordToJson(_AttendanceRecord instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'kind': _$AttendanceKindEnumMap[instance.kind]!,
      'note': instance.note,
    };

const _$AttendanceKindEnumMap = {
  AttendanceKind.present: 'present',
  AttendanceKind.justified: 'justified',
  AttendanceKind.unjustified: 'unjustified',
  AttendanceKind.late: 'late',
};

_StudentAttendanceSummary _$StudentAttendanceSummaryFromJson(
  Map<String, dynamic> json,
) => _StudentAttendanceSummary(
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AttendanceRecord>[],
);

Map<String, dynamic> _$StudentAttendanceSummaryToJson(
  _StudentAttendanceSummary instance,
) => <String, dynamic>{
  'records': instance.records.map((e) => e.toJson()).toList(),
};

_StudentChargeLine _$StudentChargeLineFromJson(Map<String, dynamic> json) =>
    _StudentChargeLine(
      id: json['id'] as String,
      description: json['description'] as String,
      dueOn: const DateOnlyConverter().fromJson(json['dueOn'] as String),
      amountMinor: (json['amountMinor'] as num).toInt(),
      paidMinor: (json['paidMinor'] as num?)?.toInt() ?? 0,
      status: $enumDecode(_$StudentChargeStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$StudentChargeLineToJson(_StudentChargeLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'dueOn': const DateOnlyConverter().toJson(instance.dueOn),
      'amountMinor': instance.amountMinor,
      'paidMinor': instance.paidMinor,
      'status': _$StudentChargeStatusEnumMap[instance.status]!,
    };

const _$StudentChargeStatusEnumMap = {
  StudentChargeStatus.open: 'open',
  StudentChargeStatus.partial: 'partial',
  StudentChargeStatus.paid: 'paid',
  StudentChargeStatus.overdue: 'overdue',
};

_StudentFinanceSummary _$StudentFinanceSummaryFromJson(
  Map<String, dynamic> json,
) => _StudentFinanceSummary(
  charges:
      (json['charges'] as List<dynamic>?)
          ?.map((e) => StudentChargeLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StudentChargeLine>[],
  discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StudentFinanceSummaryToJson(
  _StudentFinanceSummary instance,
) => <String, dynamic>{
  'charges': instance.charges.map((e) => e.toJson()).toList(),
  'discountPercent': instance.discountPercent,
};

_AccessEvent _$AccessEventFromJson(Map<String, dynamic> json) => _AccessEvent(
  at: const UtcDateTimeConverter().fromJson(json['at'] as String),
  direction: $enumDecode(_$AccessDirectionEnumMap, json['direction']),
  gate: json['gate'] as String?,
);

Map<String, dynamic> _$AccessEventToJson(_AccessEvent instance) =>
    <String, dynamic>{
      'at': const UtcDateTimeConverter().toJson(instance.at),
      'direction': _$AccessDirectionEnumMap[instance.direction]!,
      'gate': instance.gate,
    };

const _$AccessDirectionEnumMap = {
  AccessDirection.entry: 'entry',
  AccessDirection.exit: 'exit',
};

_StudentCardSummary _$StudentCardSummaryFromJson(Map<String, dynamic> json) =>
    _StudentCardSummary(
      cardNumber: json['cardNumber'] as String?,
      status: $enumDecodeNullable(_$StudentCardStatusEnumMap, json['status']),
      mealBalanceMinor: (json['mealBalanceMinor'] as num?)?.toInt() ?? 0,
      recentAccess:
          (json['recentAccess'] as List<dynamic>?)
              ?.map((e) => AccessEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AccessEvent>[],
    );

Map<String, dynamic> _$StudentCardSummaryToJson(_StudentCardSummary instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'status': _$StudentCardStatusEnumMap[instance.status],
      'mealBalanceMinor': instance.mealBalanceMinor,
      'recentAccess': instance.recentAccess.map((e) => e.toJson()).toList(),
    };

const _$StudentCardStatusEnumMap = {
  StudentCardStatus.active: 'active',
  StudentCardStatus.blocked: 'blocked',
  StudentCardStatus.lost: 'lost',
};
