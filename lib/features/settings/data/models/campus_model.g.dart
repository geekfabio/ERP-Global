// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CampusModel _$CampusModelFromJson(Map<String, dynamic> json) => _CampusModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$CampusModelToJson(_CampusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
    };
