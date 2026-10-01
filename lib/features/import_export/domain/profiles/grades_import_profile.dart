import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de notas (uma nota por linha: aluno × turma ×
/// disciplina × trimestre × componente). O servidor só aceita notas de
/// trimestres abertos e valida a escala do esquema de avaliação.
class GradesImportProfile implements ImportProfile {
  const GradesImportProfile();

  @override
  String get id => 'grades';

  @override
  String get label => 'Notas';

  @override
  String get entity => 'grades';

  @override
  List<ImportColumn> get columns => const [
    ImportColumn(
      key: 'studentRef',
      label: 'Aluno (nº ou BI)',
      required: true,
      aliases: ['aluno', 'numero', 'nº de aluno', 'bi'],
      example: '20260001',
    ),
    ImportColumn(
      key: 'classroom',
      label: 'Turma',
      required: true,
      aliases: ['nome da turma'],
      example: '7.ª A',
    ),
    ImportColumn(
      key: 'subject',
      label: 'Disciplina',
      required: true,
      aliases: ['materia'],
      example: 'MAT',
    ),
    ImportColumn(
      key: 'term',
      label: 'Trimestre',
      required: true,
      aliases: ['periodo'],
      example: '1.º Trimestre',
    ),
    ImportColumn(
      key: 'component',
      label: 'Componente',
      required: true,
      aliases: ['avaliacao', 'prova'],
      example: 'MAC',
    ),
    ImportColumn(
      key: 'score',
      label: 'Nota',
      required: true,
      aliases: ['valor', 'classificacao'],
      example: '14,5',
      parse: parseImportScore,
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) => const {};
}
