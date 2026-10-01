import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de encarregados de educação. `studentBi` liga o
/// encarregado a um aluno já registado (o servidor resolve o vínculo).
class GuardiansImportProfile implements ImportProfile {
  const GuardiansImportProfile();

  @override
  String get id => 'guardians';

  @override
  String get label => 'Encarregados';

  @override
  String get entity => 'guardians';

  @override
  List<ImportColumn> get columns => const [
    ImportColumn(
      key: 'fullName',
      label: 'Nome completo',
      required: true,
      aliases: ['nome', 'encarregado'],
      example: 'Maria Paulo',
    ),
    ImportColumn(
      key: 'phone',
      label: 'Telefone',
      required: true,
      aliases: ['telemovel', 'contacto'],
      example: '923456789',
      parse: parseAngolanPhone,
    ),
    ImportColumn(
      key: 'email',
      label: 'E-mail',
      aliases: ['email', 'correio'],
      example: 'maria@exemplo.ao',
      parse: parseEmail,
    ),
    ImportColumn(
      key: 'biNumber',
      label: 'BI',
      aliases: ['bilhete', 'documento'],
      example: '004567891LA042',
      parse: parseAngolanBi,
    ),
    ImportColumn(
      key: 'relationship',
      label: 'Parentesco',
      aliases: ['vinculo', 'relacao'],
      example: 'Mãe',
      parse: parseRelationship,
    ),
    ImportColumn(
      key: 'studentBi',
      label: 'BI do aluno',
      aliases: ['bi aluno', 'bi do educando'],
      example: '004567890LA041',
      parse: parseAngolanBi,
    ),
    ImportColumn(
      key: 'profession',
      label: 'Profissão',
      aliases: ['ocupacao'],
      example: 'Professora',
    ),
    ImportColumn(
      key: 'address',
      label: 'Morada',
      aliases: ['endereco'],
      example: 'Rua 1, Luanda',
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) {
    if (record['relationship'] != null && record['studentBi'] == null) {
      return {'studentBi': 'Indique o BI do aluno para criar o vínculo'};
    }
    return const {};
  }
}
