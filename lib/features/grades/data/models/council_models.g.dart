// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'council_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouncilDecisionModel _$CouncilDecisionModelFromJson(
  Map<String, dynamic> json,
) => _CouncilDecisionModel(
  studentId: json['studentId'] as String,
  result: $enumDecode(_$FinalResultEnumMap, json['result']),
  justification: json['justification'] as String,
  decidedAt: const UtcDateTimeConverter().fromJson(json['decidedAt'] as String),
);

Map<String, dynamic> _$CouncilDecisionModelToJson(
  _CouncilDecisionModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'result': _$FinalResultEnumMap[instance.result]!,
  'justification': instance.justification,
  'decidedAt': const UtcDateTimeConverter().toJson(instance.decidedAt),
};

const _$FinalResultEnumMap = {
  FinalResult.pending: 'pending',
  FinalResult.approved: 'approved',
  FinalResult.failed: 'failed',
  FinalResult.recourse: 'recourse',
  FinalResult.transitsWithDeficiency: 'transitsWithDeficiency',
};

_CouncilModel _$CouncilModelFromJson(Map<String, dynamic> json) =>
    _CouncilModel(
      classroomId: json['classroomId'] as String,
      yearId: json['yearId'] as String,
      decisions:
          (json['decisions'] as List<dynamic>?)
              ?.map(
                (e) => CouncilDecisionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CouncilDecisionModel>[],
      approvedAt: _$JsonConverterFromJson<String, DateTime>(
        json['approvedAt'],
        const UtcDateTimeConverter().fromJson,
      ),
      results:
          (json['results'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$FinalResultEnumMap, e)),
          ) ??
          const <String, FinalResult>{},
    );

Map<String, dynamic> _$CouncilModelToJson(_CouncilModel instance) =>
    <String, dynamic>{
      'classroomId': instance.classroomId,
      'yearId': instance.yearId,
      'decisions': instance.decisions.map((e) => e.toJson()).toList(),
      'approvedAt': _$JsonConverterToJson<String, DateTime>(
        instance.approvedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'results': instance.results.map(
        (k, e) => MapEntry(k, _$FinalResultEnumMap[e]!),
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
