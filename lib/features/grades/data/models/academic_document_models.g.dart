// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_document_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentTemplateModel _$DocumentTemplateModelFromJson(
  Map<String, dynamic> json,
) => _DocumentTemplateModel(
  id: json['id'] as String,
  kind: $enumDecode(_$DocumentKindEnumMap, json['kind']),
  name: json['name'] as String,
  body: json['body'] as String,
);

Map<String, dynamic> _$DocumentTemplateModelToJson(
  _DocumentTemplateModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': _$DocumentKindEnumMap[instance.kind]!,
  'name': instance.name,
  'body': instance.body,
};

const _$DocumentKindEnumMap = {
  DocumentKind.enrollmentDeclaration: 'enrollmentDeclaration',
  DocumentKind.attendanceDeclaration: 'attendanceDeclaration',
  DocumentKind.certificate: 'certificate',
};

_AcademicDocumentModel _$AcademicDocumentModelFromJson(
  Map<String, dynamic> json,
) => _AcademicDocumentModel(
  id: json['id'] as String,
  kind: $enumDecode(_$DocumentKindEnumMap, json['kind']),
  status: $enumDecode(_$DocumentStatusEnumMap, json['status']),
  studentId: json['studentId'] as String,
  studentName: json['studentName'] as String,
  processNumber: json['processNumber'] as String,
  purpose: json['purpose'] as String? ?? '',
  variables:
      (json['variables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  requestedAt: const UtcDateTimeConverter().fromJson(
    json['requestedAt'] as String,
  ),
  number: json['number'] as String?,
  content: json['content'] as String?,
  issuedAt: _$JsonConverterFromJson<String, DateTime>(
    json['issuedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  cancelledAt: _$JsonConverterFromJson<String, DateTime>(
    json['cancelledAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$AcademicDocumentModelToJson(
  _AcademicDocumentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': _$DocumentKindEnumMap[instance.kind]!,
  'status': _$DocumentStatusEnumMap[instance.status]!,
  'studentId': instance.studentId,
  'studentName': instance.studentName,
  'processNumber': instance.processNumber,
  'purpose': instance.purpose,
  'variables': instance.variables,
  'requestedAt': const UtcDateTimeConverter().toJson(instance.requestedAt),
  'number': instance.number,
  'content': instance.content,
  'issuedAt': _$JsonConverterToJson<String, DateTime>(
    instance.issuedAt,
    const UtcDateTimeConverter().toJson,
  ),
  'cancelledAt': _$JsonConverterToJson<String, DateTime>(
    instance.cancelledAt,
    const UtcDateTimeConverter().toJson,
  ),
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.requested: 'requested',
  DocumentStatus.issued: 'issued',
  DocumentStatus.cancelled: 'cancelled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_DocumentVerificationModel _$DocumentVerificationModelFromJson(
  Map<String, dynamic> json,
) => _DocumentVerificationModel(
  number: json['number'] as String,
  kind: $enumDecode(_$DocumentKindEnumMap, json['kind']),
  status: $enumDecode(_$DocumentStatusEnumMap, json['status']),
  studentName: json['studentName'] as String,
  issuedAt: _$JsonConverterFromJson<String, DateTime>(
    json['issuedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$DocumentVerificationModelToJson(
  _DocumentVerificationModel instance,
) => <String, dynamic>{
  'number': instance.number,
  'kind': _$DocumentKindEnumMap[instance.kind]!,
  'status': _$DocumentStatusEnumMap[instance.status]!,
  'studentName': instance.studentName,
  'issuedAt': _$JsonConverterToJson<String, DateTime>(
    instance.issuedAt,
    const UtcDateTimeConverter().toJson,
  ),
};
