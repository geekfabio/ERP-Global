import '../../../../core/utils/seed_generator.dart';
import '../models/assessment_scheme_model.dart';

const _components = [
  AssessmentComponentModel(
    code: 'MAC',
    name: 'Média das avaliações contínuas',
    weight: 30,
  ),
  AssessmentComponentModel(code: 'NPP', name: 'Prova do professor', weight: 30),
  AssessmentComponentModel(code: 'NPT', name: 'Prova trimestral', weight: 40),
];

/// Esquema por omissão da instituição (escala 0–20, mínimo 10).
List<AssessmentSchemeModel> assessmentSchemeSeed() {
  final ids = SeedGenerator(460);
  return [
    AssessmentSchemeModel(
      id: ids.ulid(DateTime.utc(2026)),
      name: 'Esquema geral',
      components: _components,
    ),
  ];
}
