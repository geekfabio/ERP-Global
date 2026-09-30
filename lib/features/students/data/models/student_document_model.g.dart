// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentDocumentModel _$StudentDocumentModelFromJson(
  Map<String, dynamic> json,
) => _StudentDocumentModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  studentId: json['studentId'] as String,
  type: $enumDecode(_$StudentDocumentTypeEnumMap, json['type']),
  fileName: json['fileName'] as String,
  fileUrl: json['fileUrl'] as String?,
  expiresOn: _$JsonConverterFromJson<String, DateTime>(
    json['expiresOn'],
    const DateOnlyConverter().fromJson,
  ),
  verified: json['verified'] as bool? ?? false,
  verifiedBy: json['verifiedBy'] as String?,
  verifiedAt: _$JsonConverterFromJson<String, DateTime>(
    json['verifiedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$StudentDocumentModelToJson(
  _StudentDocumentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'institutionId': instance.institutionId,
  'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<String, DateTime>(
    instance.deletedAt,
    const UtcDateTimeConverter().toJson,
  ),
  'syncState': instance.syncState,
  'studentId': instance.studentId,
  'type': _$StudentDocumentTypeEnumMap[instance.type]!,
  'fileName': instance.fileName,
  'fileUrl': instance.fileUrl,
  'expiresOn': _$JsonConverterToJson<String, DateTime>(
    instance.expiresOn,
    const DateOnlyConverter().toJson,
  ),
  'verified': instance.verified,
  'verifiedBy': instance.verifiedBy,
  'verifiedAt': _$JsonConverterToJson<String, DateTime>(
    instance.verifiedAt,
    const UtcDateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$StudentDocumentTypeEnumMap = {
  StudentDocumentType.idCard: 'id_card',
  StudentDocumentType.birthCertificate: 'birth_certificate',
  StudentDocumentType.passport: 'passport',
  StudentDocumentType.previousCertificate: 'previous_certificate',
  StudentDocumentType.vaccination: 'vaccination',
  StudentDocumentType.photo: 'photo',
  StudentDocumentType.contract: 'contract',
  StudentDocumentType.other: 'other',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
