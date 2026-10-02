import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_scheme_model.freezed.dart';
part 'assessment_scheme_model.g.dart';

/// Arredondamento das médias (`nearest` = meio para cima).
enum RoundingMode { nearest, up, down }

/// Componente do trimestre (`MAC`, `NPP`, `NPT`…) com o seu peso em %.
@freezed
abstract class AssessmentComponentModel with _$AssessmentComponentModel {
  const factory AssessmentComponentModel({
    required String code,
    required String name,

    /// Peso inteiro em percentagem (1–100); a soma do esquema é 100.
    required int weight,
  }) = _AssessmentComponentModel;

  factory AssessmentComponentModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentComponentModelFromJson(json);
}

/// Esquema de avaliação: componentes → `MT` (trimestre) → `MF` (final).
/// Aplica-se a uma classe/curso; sem ambos é o esquema da instituição.
@freezed
abstract class AssessmentSchemeModel with _$AssessmentSchemeModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AssessmentSchemeModel({
    required String id,
    required String name,
    String? gradeId,
    String? courseId,
    @Default(20) int scaleMax,
    @Default(10) int minPassing,
    @Default(RoundingMode.nearest) RoundingMode rounding,

    /// Casas decimais do arredondamento (0–2).
    @Default(0) int decimals,

    /// Arredonda a `MT` antes de calcular a `MF`.
    @Default(true) bool roundTerm,
    @Default(<AssessmentComponentModel>[])
    List<AssessmentComponentModel> components,

    /// Pesos (%) de cada trimestre na `MF`; vazio = média simples.
    @Default(<int>[]) List<int> termWeights,
  }) = _AssessmentSchemeModel;

  factory AssessmentSchemeModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentSchemeModelFromJson(json);
}
