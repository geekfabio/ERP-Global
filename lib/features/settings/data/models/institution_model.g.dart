// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstitutionModel _$InstitutionModelFromJson(Map<String, dynamic> json) =>
    _InstitutionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nif: json['nif'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      brandColor: json['brandColor'] as String,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$InstitutionModelToJson(_InstitutionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nif': instance.nif,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'brandColor': instance.brandColor,
      'logoUrl': instance.logoUrl,
    };
