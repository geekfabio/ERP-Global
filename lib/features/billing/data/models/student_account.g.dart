// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentAccount _$StudentAccountFromJson(
  Map<String, dynamic> json,
) => _StudentAccount(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  campusId: json['campusId'] as String?,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  studentId: json['studentId'] as String,
  balanceMinor: const MinorUnitConverter().fromJson(json['balanceMinor']),
  prepaidMinor: json['prepaidMinor'] == null
      ? 0
      : const MinorUnitConverter().fromJson(json['prepaidMinor']),
  outstandingMinor: json['outstandingMinor'] == null
      ? 0
      : const MinorUnitConverter().fromJson(json['outstandingMinor']),
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LedgerEntry>[],
);

Map<String, dynamic> _$StudentAccountToJson(_StudentAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'campusId': instance.campusId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'studentId': instance.studentId,
      'balanceMinor': const MinorUnitConverter().toJson(instance.balanceMinor),
      'prepaidMinor': const MinorUnitConverter().toJson(instance.prepaidMinor),
      'outstandingMinor': const MinorUnitConverter().toJson(
        instance.outstandingMinor,
      ),
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_LedgerEntry _$LedgerEntryFromJson(Map<String, dynamic> json) => _LedgerEntry(
  id: json['id'] as String,
  referenceId: json['referenceId'] as String,
  kind: json['kind'] as String? ?? 'payment',
  occurredAt: const UtcDateTimeConverter().fromJson(
    json['occurredAt'] as String,
  ),
  debitMinor: const MinorUnitConverter().fromJson(json['debitMinor']),
  creditMinor: const MinorUnitConverter().fromJson(json['creditMinor']),
);

Map<String, dynamic> _$LedgerEntryToJson(_LedgerEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceId': instance.referenceId,
      'kind': instance.kind,
      'occurredAt': const UtcDateTimeConverter().toJson(instance.occurredAt),
      'debitMinor': const MinorUnitConverter().toJson(instance.debitMinor),
      'creditMinor': const MinorUnitConverter().toJson(instance.creditMinor),
    };
