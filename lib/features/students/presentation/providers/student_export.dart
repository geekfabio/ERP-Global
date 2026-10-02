import '../../../../core/export/export_contract.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/student_enums.dart';
import '../../data/models/student_model.dart';
import '../widgets/student_display.dart';

/// Permissão que dá acesso ao botão e ao serviço de exportação de alunos.
const studentsExportPermission = 'students.record.export';

/// Colunas exportáveis; os dados de saúde exigem `students.health.read`.
final studentExportColumns = <ExportColumn<StudentModel>>[
  ExportColumn(
    key: 'processNumber',
    label: 'N.º processo',
    text: (s) => s.processNumber,
  ),
  ExportColumn(key: 'fullName', label: 'Nome', text: (s) => s.fullName),
  ExportColumn(
    key: 'birthDate',
    label: 'Data de nascimento',
    text: (s) => PtAoFormatters.date(s.birthDate),
  ),
  ExportColumn(
    key: 'gender',
    label: 'Género',
    text: (s) => s.gender == Gender.male ? 'Masculino' : 'Feminino',
  ),
  ExportColumn(key: 'idNumber', label: 'BI', text: (s) => s.idNumber ?? ''),
  ExportColumn(key: 'phone', label: 'Telefone', text: (s) => s.phone ?? ''),
  ExportColumn(key: 'email', label: 'Email', text: (s) => s.email ?? ''),
  ExportColumn(
    key: 'status',
    label: 'Estado',
    text: (s) => studentStatusLabel(s.status),
  ),
  ExportColumn(
    key: 'allergies',
    label: 'Alergias',
    permission: 'students.health.read',
    text: (s) => s.health.allergies.join(', '),
  ),
  ExportColumn(
    key: 'conditions',
    label: 'Condições de saúde',
    permission: 'students.health.read',
    text: (s) => s.health.conditions ?? '',
  ),
];
