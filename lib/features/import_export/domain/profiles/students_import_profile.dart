import '../import_profile.dart';

DateTime _date(String raw) {
  final br = RegExp(r'^(\d{1,2})[/.-](\d{1,2})[/.-](\d{4})$').firstMatch(raw);
  final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);
  final (y, m, d) = br != null
      ? (int.parse(br[3]!), int.parse(br[2]!), int.parse(br[1]!))
      : iso != null
      ? (int.parse(iso[1]!), int.parse(iso[2]!), int.parse(iso[3]!))
      : throw const FormatException('Data inválida (use dd/MM/aaaa)');
  final date = DateTime.utc(y, m, d);
  if (date.month != m || date.day != d) {
    throw const FormatException('Data inexistente');
  }
  return date;
}

String _gender(String raw) => switch (raw.toLowerCase()) {
  'm' || 'masculino' => 'male',
  'f' || 'feminino' => 'female',
  _ => throw const FormatException('Use M ou F'),
};

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
      label: 'Nome completo',
      required: true,
      aliases: ['nome', 'aluno'],
    ),
    ImportColumn(
      key: 'birthDate',
      label: 'Data de nascimento',
      required: true,
      aliases: const ['nascimento', 'data nasc'],
      parse: (raw) => _date(raw).toIso8601String(),
    ),
    const ImportColumn(
      key: 'gender',
      label: 'Sexo',
      required: true,
      aliases: ['genero'],
      parse: _gender,
    ),
    ImportColumn(
      key: 'biNumber',
      label: 'BI',
      aliases: const ['bilhete', 'documento'],
      parse: (raw) {
        final bi = raw.replaceAll(RegExp(r'\s'), '').toUpperCase();
        if (!RegExp(r'^\d{9}[A-Z]{2}\d{3}$').hasMatch(bi)) {
          throw const FormatException(
            'BI inválido (9 dígitos, 2 letras, 3 dígitos)',
          );
        }
        return bi;
      },
    ),
    ImportColumn(
      key: 'guardianPhone',
      label: 'Telefone do encarregado',
      aliases: const ['telefone', 'contacto'],
      parse: (raw) {
        final phone = raw.replaceAll(RegExp(r'[\s-]'), '');
        if (!RegExp(r'^(\+244)?9\d{8}$').hasMatch(phone)) {
          throw const FormatException('Telefone inválido');
        }
        return phone;
      },
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
