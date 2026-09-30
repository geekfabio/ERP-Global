// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnnouncementModel _$AnnouncementModelFromJson(
  Map<String, dynamic> json,
) => _AnnouncementModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  title: json['title'] as String,
  body: json['body'] as String,
  audience: $enumDecode(_$AnnouncementAudienceEnumMap, json['audience']),
  classroomId: json['classroomId'] as String?,
  status:
      $enumDecodeNullable(_$AnnouncementStatusEnumMap, json['status']) ??
      AnnouncementStatus.published,
  requiresReadReceipt: json['requiresReadReceipt'] as bool? ?? false,
  channels:
      (json['channels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>['in_app'],
  createdBy: json['createdBy'] as String?,
  publishedAt: _$JsonConverterFromJson<String, DateTime>(
    json['publishedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  readCount: (json['readCount'] as num?)?.toInt() ?? 0,
  recipientCount: (json['recipientCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AnnouncementModelToJson(_AnnouncementModel instance) =>
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
      'title': instance.title,
      'body': instance.body,
      'audience': _$AnnouncementAudienceEnumMap[instance.audience]!,
      'classroomId': instance.classroomId,
      'status': _$AnnouncementStatusEnumMap[instance.status]!,
      'requiresReadReceipt': instance.requiresReadReceipt,
      'channels': instance.channels,
      'createdBy': instance.createdBy,
      'publishedAt': _$JsonConverterToJson<String, DateTime>(
        instance.publishedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'readCount': instance.readCount,
      'recipientCount': instance.recipientCount,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$AnnouncementAudienceEnumMap = {
  AnnouncementAudience.school: 'school',
  AnnouncementAudience.classroom: 'classroom',
  AnnouncementAudience.guardians: 'guardians',
};

const _$AnnouncementStatusEnumMap = {
  AnnouncementStatus.draft: 'draft',
  AnnouncementStatus.published: 'published',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_AnnouncementReadModel _$AnnouncementReadModelFromJson(
  Map<String, dynamic> json,
) => _AnnouncementReadModel(
  announcementId: json['announcementId'] as String,
  userId: json['userId'] as String,
  readAt: const UtcDateTimeConverter().fromJson(json['readAt'] as String),
);

Map<String, dynamic> _$AnnouncementReadModelToJson(
  _AnnouncementReadModel instance,
) => <String, dynamic>{
  'announcementId': instance.announcementId,
  'userId': instance.userId,
  'readAt': const UtcDateTimeConverter().toJson(instance.readAt),
};
