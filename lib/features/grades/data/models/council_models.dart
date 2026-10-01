import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'council_models.freezed.dart';
part 'council_models.g.dart';

/// Resultado final do aluno no ano lectivo.
enum FinalResult { pending, approved, failed, recourse, transitsWithDeficiency }

/// Decisão do conselho de turma sobre um aluno (sobrepõe-se ao resultado
/// calculado pelas regras); a justificação é obrigatória.
@freezed
abstract class CouncilDecisionModel with _$CouncilDecisionModel {
  const factory CouncilDecisionModel({
    required String studentId,
    required FinalResult result,
    required String justification,
    @UtcDateTimeConverter() required DateTime decidedAt,
  }) = _CouncilDecisionModel;

  factory CouncilDecisionModel.fromJson(Map<String, dynamic> json) =>
      _$CouncilDecisionModelFromJson(json);
}

/// Conselho de turma de uma turma num ano lectivo: decisões e aprovação da
/// pauta. Aprovada, a pauta fica congelada com os [results] finais.
@freezed
abstract class CouncilModel with _$CouncilModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CouncilModel({
    required String classroomId,
    required String yearId,
    @Default(<CouncilDecisionModel>[]) List<CouncilDecisionModel> decisions,
    @UtcDateTimeConverter() DateTime? approvedAt,

    /// `alunoId → resultado` no momento da aprovação.
    @Default(<String, FinalResult>{}) Map<String, FinalResult> results,
  }) = _CouncilModel;

  factory CouncilModel.fromJson(Map<String, dynamic> json) =>
      _$CouncilModelFromJson(json);
}

extension CouncilModelX on CouncilModel {
  bool get approved => approvedAt != null;

  CouncilDecisionModel? decisionFor(String studentId) =>
      decisions.where((d) => d.studentId == studentId).firstOrNull;
}
