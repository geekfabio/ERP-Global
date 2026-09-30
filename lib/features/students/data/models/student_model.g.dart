// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthInfo _$HealthInfoFromJson(Map<String, dynamic> json) => _HealthInfo(
  bloodType: $enumDecodeNullable(_$BloodTypeEnumMap, json['bloodType']),
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  medication: json['medication'] as String?,
  conditions: json['conditions'] as String?,
  insurance: json['insurance'] as String?,
  hasSpecialNeeds: json['hasSpecialNeeds'] as bool? ?? false,
  specialNeedsNotes: json['specialNeedsNotes'] as String?,
  medicalContact: json['medicalContact'] as String?,
);

Map<String, dynamic> _$HealthInfoToJson(_HealthInfo instance) =>
    <String, dynamic>{
      'bloodType': _$BloodTypeEnumMap[instance.bloodType],
      'allergies': instance.allergies,
      'medication': instance.medication,
      'conditions': instance.conditions,
      'insurance': instance.insurance,
      'hasSpecialNeeds': instance.hasSpecialNeeds,
      'specialNeedsNotes': instance.specialNeedsNotes,
      'medicalContact': instance.medicalContact,
    };

const _$BloodTypeEnumMap = {
  BloodType.aPositive: 'A+',
  BloodType.aNegative: 'A-',
  BloodType.bPositive: 'B+',
  BloodType.bNegative: 'B-',
  BloodType.abPositive: 'AB+',
  BloodType.abNegative: 'AB-',
  BloodType.oPositive: 'O+',
  BloodType.oNegative: 'O-',
};

_StudentModel _$StudentModelFromJson(
  Map<String, dynamic> json,
) => _StudentModel(
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
  processNumber: json['processNumber'] as String,
  fullName: json['fullName'] as String,
  photoUrl: json['photoUrl'] as String?,
  birthDate: const DateOnlyConverter().fromJson(json['birthDate'] as String),
  birthPlace: json['birthPlace'] as String?,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  nationality: json['nationality'] as String? ?? 'Angolana',
  idNumber: json['idNumber'] as String?,
  nif: json['nif'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  originSchool: json['originSchool'] as String?,
  status:
      $enumDecodeNullable(_$StudentStatusEnumMap, json['status']) ??
      StudentStatus.active,
  health: json['health'] == null
      ? const HealthInfo()
      : HealthInfo.fromJson(json['health'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StudentModelToJson(_StudentModel instance) =>
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
      'processNumber': instance.processNumber,
      'fullName': instance.fullName,
      'photoUrl': instance.photoUrl,
      'birthDate': const DateOnlyConverter().toJson(instance.birthDate),
      'birthPlace': instance.birthPlace,
      'gender': _$GenderEnumMap[instance.gender]!,
      'nationality': instance.nationality,
      'idNumber': instance.idNumber,
      'nif': instance.nif,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'originSchool': instance.originSchool,
      'status': _$StudentStatusEnumMap[instance.status]!,
      'health': instance.health.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$StudentStatusEnumMap = {
  StudentStatus.active: 'active',
  StudentStatus.inactive: 'inactive',
  StudentStatus.suspended: 'suspended',
  StudentStatus.transferred: 'transferred',
  StudentStatus.graduated: 'graduated',
  StudentStatus.dropout: 'dropout',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
