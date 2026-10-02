// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardian_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuardianModel _$GuardianModelFromJson(
  Map<String, dynamic> json,
) => _GuardianModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  fullName: json['fullName'] as String,
  idNumber: json['idNumber'] as String?,
  nif: json['nif'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  address: json['address'] as String?,
  profession: json['profession'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$GuardianModelToJson(_GuardianModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'fullName': instance.fullName,
      'idNumber': instance.idNumber,
      'nif': instance.nif,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'profession': instance.profession,
      'userId': instance.userId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_GuardianLinkModel _$GuardianLinkModelFromJson(
  Map<String, dynamic> json,
) => _GuardianLinkModel(
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
  guardianId: json['guardianId'] as String,
  relationship: $enumDecode(
    _$GuardianRelationshipEnumMap,
    json['relationship'],
  ),
  isFinancialResponsible: json['isFinancialResponsible'] as bool? ?? false,
  isEmergency: json['isEmergency'] as bool? ?? false,
  canPickup: json['canPickup'] as bool? ?? false,
  validUntil: _$JsonConverterFromJson<String, DateTime>(
    json['validUntil'],
    const UtcDateTimeConverter().fromJson,
  ),
  verified: json['verified'] as bool? ?? false,
);

Map<String, dynamic> _$GuardianLinkModelToJson(_GuardianLinkModel instance) =>
    <String, dynamic>{
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
      'guardianId': instance.guardianId,
      'relationship': _$GuardianRelationshipEnumMap[instance.relationship]!,
      'isFinancialResponsible': instance.isFinancialResponsible,
      'isEmergency': instance.isEmergency,
      'canPickup': instance.canPickup,
      'validUntil': _$JsonConverterToJson<String, DateTime>(
        instance.validUntil,
        const UtcDateTimeConverter().toJson,
      ),
      'verified': instance.verified,
    };

const _$GuardianRelationshipEnumMap = {
  GuardianRelationship.father: 'father',
  GuardianRelationship.mother: 'mother',
  GuardianRelationship.tutor: 'tutor',
  GuardianRelationship.grandparent: 'grandparent',
  GuardianRelationship.sibling: 'sibling',
  GuardianRelationship.uncleAunt: 'uncle_aunt',
  GuardianRelationship.other: 'other',
};
