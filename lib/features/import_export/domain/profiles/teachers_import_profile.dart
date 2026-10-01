import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de professores. `subjects` lista os códigos ou nomes
/// das disciplinas separados por `|` (o servidor resolve cada um).
class TeachersImportProfile implements ImportProfile {
  const TeachersImportProfile();

  @override
  String get id => 'teachers';

  @override
  String get label => 'Professores';

  @override
  String get entity => 'teachers';

  @override
  List<ImportColumn> get columns => const [
    ImportColumn(
      key: 'fullName',
      label: 'Nome completo',
      required: true,
      aliases: ['nome', 'professor'],
      example: 'Rui Manuel',
    ),
    ImportColumn(
      key: 'email',
      label: 'E-mail',
      required: true,
      aliases: ['email', 'correio'],
      example: 'rui@escola.ao',
      parse: parseEmail,
    ),
    ImportColumn(
      key: 'phone',
      label: 'Telefone',
      aliases: ['telemovel', 'contacto'],
      example: '923456789',
      parse: parseAngolanPhone,
    ),
    ImportColumn(
      key: 'specialty',
      label: 'Formação',
      aliases: ['especialidade', 'area de formacao'],
      example: 'Licenciatura em Matemática',
    ),
    ImportColumn(
      key: 'subjects',
      label: 'Disciplinas',
      aliases: ['disciplina', 'lecciona'],
      example: 'MAT|FIS',
      parse: parseImportList,
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) => const {};
}
