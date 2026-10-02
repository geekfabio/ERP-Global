import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/student_enums.dart';
import '../../data/models/student_model.dart';
import '../../domain/student_repositories.dart';
import '../widgets/student_file/student_labels.dart';
import '../widgets/student_file/tabs/guardians_tab.dart';

/// Dados que alimentam os documentos de matrícula de um aluno.
class StudentPdfData {
  const StudentPdfData({
    required this.student,
    required this.enrollment,
    this.guardians = const [],
    this.institutionName = 'Instituição',
  });

  final StudentModel student;
  final EnrollmentModel enrollment;
  final List<StudentGuardian> guardians;
  final String institutionName;

  /// Encarregado financeiro, ou o primeiro encarregado.
  StudentGuardian? get financialGuardian {
    for (final g in guardians) {
      if (g.link.isFinancialResponsible) return g;
    }
    return guardians.isEmpty ? null : guardians.first;
  }
}

/// Tipos de documento de matrícula disponíveis na ficha do aluno.
enum StudentPdfKind { enrollmentSheet, receipt, contract }

extension StudentPdfKindX on StudentPdfKind {
  String get label => switch (this) {
    StudentPdfKind.enrollmentSheet => 'Ficha de matrícula',
    StudentPdfKind.receipt => 'Comprovativo de matrícula',
    StudentPdfKind.contract => 'Contrato de prestação de serviços',
  };

  /// O comprovativo só existe com a taxa de matrícula paga.
  bool isAvailableFor(EnrollmentModel e) =>
      this != StudentPdfKind.receipt || e.feePaid;

  PdfDocumentTemplate template(StudentPdfData data) => switch (this) {
    StudentPdfKind.enrollmentSheet => EnrollmentSheetTemplate(data),
    StudentPdfKind.receipt => EnrollmentReceiptTemplate(data),
    StudentPdfKind.contract => EnrollmentContractTemplate(data),
  };
}

String _short(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

String _gender(Gender g) => g == Gender.male ? 'Masculino' : 'Feminino';

List<(String, String?)> _studentFields(StudentModel s) => [
  ('Nome completo', s.fullName),
  ('N.º de processo', s.processNumber),
  ('Data de nascimento', PtAoFormatters.date(s.birthDate)),
  ('Naturalidade', s.birthPlace),
  ('Género', _gender(s.gender)),
  ('Nacionalidade', s.nationality),
  ('BI / Cédula / Passaporte', s.idNumber),
  ('NIF', s.nif),
  ('Morada', s.address),
  ('Escola de origem', s.originSchool),
];

List<(String, String?)> _enrollmentFields(EnrollmentModel e) => [
  ('Ano lectivo', academicYearLabelFor(e.academicYearId)),
  ('Classe', gradeLabelFor(e.gradeId)),
  ('Turma', classroomLabelFor(e.gradeId, e.classroomId)),
  ('Turno', shiftLabels[e.shiftId]),
  ('Tipo de matrícula', enrollmentTypeLabel(e.type)),
  ('Estado', enrollmentStatusLabel(e.status)),
  ('Data da matrícula', PtAoFormatters.date(e.enrolledOn)),
  ('N.º de chamada', e.rollNumber?.toString()),
];

/// Ficha de matrícula: identificação, encarregados, saúde e matrícula.
class EnrollmentSheetTemplate implements PdfDocumentTemplate {
  const EnrollmentSheetTemplate(this.data);

  final StudentPdfData data;

  @override
  String get title => 'Ficha de matrícula';

  @override
  String get fileName => 'ficha-matricula-${data.student.processNumber}';

  @override
  String get verificationCode =>
      'ERP-FICHA-${_short(data.enrollment.id)}-${data.student.processNumber}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final h = data.student.health;
    return [
      s.section('Identificação do aluno'),
      s.fields(_studentFields(data.student)),
      s.section('Matrícula'),
      s.fields(_enrollmentFields(data.enrollment)),
      s.section('Encarregados de educação'),
      if (data.guardians.isEmpty)
        pw.Text('Sem encarregados registados.', style: s.body)
      else
        s.table(
          const ['Nome', 'Parentesco', 'Telefone', 'Resp. financeiro'],
          [
            for (final g in data.guardians)
              [
                g.guardian.fullName,
                relationshipLabel(g.link.relationship),
                g.guardian.phone,
                g.link.isFinancialResponsible ? 'Sim' : 'Não',
              ],
          ],
        ),
      s.section('Saúde'),
      s.fields([
        ('Alergias', h.allergies.join(', ')),
        ('Condições de saúde', h.conditions),
        ('Medicação', h.medication),
        ('Contacto médico', h.medicalContact),
      ]),
      s.signatures(const ['O Encarregado de Educação', 'A Secretaria']),
    ];
  }
}

/// Comprovativo de matrícula com o valor da taxa paga.
class EnrollmentReceiptTemplate implements PdfDocumentTemplate {
  const EnrollmentReceiptTemplate(this.data);

  final StudentPdfData data;

  String get number => 'CM-${_short(data.enrollment.id)}';

  @override
  String get title => 'Comprovativo de matrícula';

  @override
  String get fileName => 'comprovativo-matricula-${data.student.processNumber}';

  @override
  String get verificationCode => 'ERP-COMPROVATIVO-$number';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final e = data.enrollment;
    final g = data.financialGuardian?.guardian;
    return [
      s.section('Comprovativo n.º $number'),
      pw.Text(
        'Declara-se que o aluno ${data.student.fullName}, com o processo '
        'n.º ${data.student.processNumber}, se encontra matriculado na '
        '${gradeLabelFor(e.gradeId)} no ano lectivo '
        '${academicYearLabelFor(e.academicYearId)}, em ${data.institutionName}.',
        style: s.body,
      ),
      s.section('Dados da matrícula'),
      s.fields(_enrollmentFields(e)),
      s.section('Pagamento'),
      s.fields([
        ('Taxa de matrícula', PtAoFormatters.currency(e.feeMinor)),
        ('Situação', e.feePaid ? 'Paga' : 'Por pagar'),
        ('Pago por', g?.fullName),
        ('NIF do encarregado', g?.nif),
      ]),
      s.signatures(const ['A Secretaria']),
    ];
  }
}

/// Contrato de prestação de serviços educativos para o ano lectivo.
class EnrollmentContractTemplate implements PdfDocumentTemplate {
  const EnrollmentContractTemplate(this.data);

  final StudentPdfData data;

  @override
  String get title => 'Contrato de prestação de serviços educativos';

  @override
  String get fileName => 'contrato-${data.student.processNumber}';

  @override
  String get verificationCode =>
      'ERP-CONTRATO-${_short(data.enrollment.id)}-${data.student.processNumber}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final e = data.enrollment;
    final g = data.financialGuardian?.guardian;
    final year = academicYearLabelFor(e.academicYearId);
    final clauses = <String>[
      'A Instituição compromete-se a ministrar o ensino da '
          '${gradeLabelFor(e.gradeId)} durante o ano lectivo $year, de '
          'acordo com o currículo em vigor.',
      'O Encarregado de Educação compromete-se a cumprir o regulamento '
          'interno e a liquidar as propinas e taxas nos prazos definidos.',
      'A taxa de matrícula é de ${PtAoFormatters.currency(e.feeMinor)}.',
      'Os dados pessoais são tratados apenas para fins educativos e '
          'administrativos, nos termos da lei de protecção de dados.',
      'O presente contrato pode ser rescindido por qualquer das partes '
          'mediante aviso prévio por escrito.',
    ];
    return [
      s.section('Partes'),
      s.fields([
        ('Instituição', data.institutionName),
        ('Encarregado de Educação', g?.fullName),
        ('BI do encarregado', g?.idNumber),
        ('NIF do encarregado', g?.nif),
        ('Telefone', g?.phone),
        ('Morada', g?.address),
      ]),
      s.section('Aluno'),
      s.fields([
        ('Nome completo', data.student.fullName),
        ('N.º de processo', data.student.processNumber),
        ('Classe', gradeLabelFor(e.gradeId)),
        ('Ano lectivo', year),
      ]),
      s.section('Cláusulas'),
      for (var i = 0; i < clauses.length; i++)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Text('${i + 1}. ${clauses[i]}', style: s.body),
        ),
      s.signatures(const ['O Encarregado de Educação', 'A Instituição']),
    ];
  }
}
