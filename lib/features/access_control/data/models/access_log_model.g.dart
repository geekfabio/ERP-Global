// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessLogModel _$AccessLogModelFromJson(Map<String, dynamic> json) =>
    _AccessLogModel(
      id: json['id'] as String,
      zoneId: json['zoneId'] as String,
      deviceId: json['deviceId'] as String?,
      cardUid: json['cardUid'] as String,
      holderId: json['holderId'] as String?,
      holderName: json['holderName'] as String?,
      holderType: json['holderType'] as String?,
      direction:
          $enumDecodeNullable(_$GateDirectionEnumMap, json['direction']) ??
          GateDirection.entry,
      allowed: json['allowed'] as bool,
      reason: json['reason'] as String,
      guardianAlerted: json['guardianAlerted'] as bool? ?? false,
      occurredAt: const UtcDateTimeConverter().fromJson(
        json['occurredAt'] as String,
      ),
    );

Map<String, dynamic> _$AccessLogModelToJson(_AccessLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'zoneId': instance.zoneId,
      'deviceId': instance.deviceId,
      'cardUid': instance.cardUid,
      'holderId': instance.holderId,
      'holderName': instance.holderName,
      'holderType': instance.holderType,
      'direction': _$GateDirectionEnumMap[instance.direction]!,
      'allowed': instance.allowed,
      'reason': instance.reason,
      'guardianAlerted': instance.guardianAlerted,
      'occurredAt': const UtcDateTimeConverter().toJson(instance.occurredAt),
    };

const _$GateDirectionEnumMap = {
  GateDirection.entry: 'entry',
  GateDirection.exit: 'exit',
};
