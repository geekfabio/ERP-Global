import 'package:freezed_annotation/freezed_annotation.dart';

part 'scope_model.freezed.dart';
part 'scope_model.g.dart';

@freezed
abstract class ScopeModel with _$ScopeModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ScopeModel({
    String? campusId,
    String? courseId,
    String? gradeId,
    String? classroomId,
    String? subjectId,
  }) = _ScopeModel;

  factory ScopeModel.fromJson(Map<String, dynamic> json) =>
      _$ScopeModelFromJson(json);
}
