import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de alunos (cadastro em lote).
class StudentsImportProfile implements ImportProfile {
  const StudentsImportProfile();

  @override
  String get id => 'students';

  @override
  String get label => 'Alunos';

  @override
  String get entity => 'students';

  @override
  List<ImportColumn> get columns => [
    const ImportColumn(
      key: 'fullName',
      example: 'Ana Paulo',
      label: 'Nome completo',
      required: true,
      aliases: ['nome', 'aluno'],
    ),
    ImportColumn(
      key: 'birthDate',
      example: '12/03/2012',
      label: 'Data de nascimento',
      required: true,
      aliases: ['nascimento', 'data nasc'],
      parse: (raw) => parseImportDate(raw).toIso8601String(),
    ),
    const ImportColumn(
      key: 'gender',
      example: 'F',
      label: 'Sexo',
      required: true,
      aliases: ['genero'],
      parse: parseImportGender,
    ),
    const ImportColumn(
      key: 'biNumber',
      example: '004567890LA041',
      label: 'BI',
      aliases: ['bilhete', 'documento'],
      parse: parseAngolanBi,
    ),
    const ImportColumn(
      key: 'guardianPhone',
      example: '923456789',
      label: 'Telefone do encarregado',
      aliases: ['telefone', 'contacto'],
      parse: parseAngolanPhone,
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) {
    final raw = record['birthDate'] as String?;
    if (raw != null && DateTime.parse(raw).isAfter(DateTime.now().toUtc())) {
      return {'birthDate': 'A data de nascimento está no futuro'};
    }
    return const {};
  }
}
