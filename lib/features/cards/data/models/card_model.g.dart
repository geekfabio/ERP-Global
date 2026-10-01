// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardModel _$CardModelFromJson(Map<String, dynamic> json) => _CardModel(
  id: json['id'] as String,
  uid: json['uid'] as String,
  holderId: json['holderId'] as String,
  holderName: json['holderName'] as String,
  holderType: $enumDecode(_$CardHolderTypeEnumMap, json['holderType']),
  status:
      $enumDecodeNullable(_$CardStatusEnumMap, json['status']) ??
      CardStatus.active,
  issuedAt: const UtcDateTimeConverter().fromJson(json['issuedAt'] as String),
  replacesId: json['replacesId'] as String?,
);

Map<String, dynamic> _$CardModelToJson(_CardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'holderId': instance.holderId,
      'holderName': instance.holderName,
      'holderType': _$CardHolderTypeEnumMap[instance.holderType]!,
      'status': _$CardStatusEnumMap[instance.status]!,
      'issuedAt': const UtcDateTimeConverter().toJson(instance.issuedAt),
      'replacesId': instance.replacesId,
    };

const _$CardHolderTypeEnumMap = {
  CardHolderType.student: 'student',
  CardHolderType.staff: 'staff',
};

const _$CardStatusEnumMap = {
  CardStatus.active: 'active',
  CardStatus.blocked: 'blocked',
  CardStatus.replaced: 'replaced',
};
