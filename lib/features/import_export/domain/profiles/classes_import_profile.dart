import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de turmas (nome, classe, turno, capacidade e sala).
class ClassesImportProfile implements ImportProfile {
  const ClassesImportProfile();

  @override
  String get id => 'classes';

  @override
  String get label => 'Turmas';

  @override
  String get entity => 'classrooms';

  @override
  List<ImportColumn> get columns => const [
    ImportColumn(
      key: 'name',
      label: 'Turma',
      required: true,
      aliases: ['nome', 'nome da turma'],
      example: '7.ª A',
    ),
    ImportColumn(
      key: 'grade',
      label: 'Classe',
      required: true,
      aliases: ['ano', 'nivel'],
      example: '7.ª classe',
    ),
    ImportColumn(
      key: 'shift',
      label: 'Turno',
      aliases: ['periodo'],
      example: 'Manhã',
      parse: parseImportShift,
    ),
    ImportColumn(
      key: 'capacity',
      label: 'Capacidade',
      required: true,
      aliases: ['lotacao', 'vagas'],
      example: '35',
      parse: parsePositiveInt,
    ),
    ImportColumn(
      key: 'room',
      label: 'Sala',
      aliases: ['sala de aula'],
      example: 'Sala 3',
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) => const {};
}
