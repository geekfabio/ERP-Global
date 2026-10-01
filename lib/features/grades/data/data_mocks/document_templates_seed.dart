import '../models/academic_document_models.dart';

/// Modelos por omissão (um por tipo), editáveis na instituição.
List<DocumentTemplateModel> documentTemplatesSeed() => const [
  DocumentTemplateModel(
    id: 'tpl-enrollment-declaration',
    kind: DocumentKind.enrollmentDeclaration,
    name: 'Declaração de matrícula',
    body:
        'Para os devidos efeitos, declara-se que {{studentName}}, com o '
        'processo n.º {{processNumber}}, se encontra matriculado(a) em '
        '{{classroom}}, no ano lectivo {{academicYear}}, em '
        '{{institutionName}}.\n\n'
        'Por ser verdade, passa-se a presente declaração n.º {{number}}, '
        'emitida em {{issueDate}}.',
  ),
  DocumentTemplateModel(
    id: 'tpl-attendance-declaration',
    kind: DocumentKind.attendanceDeclaration,
    name: 'Declaração de frequência',
    body:
        'Declara-se que {{studentName}}, processo n.º {{processNumber}}, '
        'frequenta regularmente {{classroom}} no ano lectivo {{academicYear}}, '
        'em {{institutionName}}.\n\n'
        'Declaração n.º {{number}}, emitida em {{issueDate}}.',
  ),
  DocumentTemplateModel(
    id: 'tpl-certificate',
    kind: DocumentKind.certificate,
    name: 'Certificado de habilitações',
    body:
        '{{institutionName}} certifica que {{studentName}}, processo n.º '
        '{{processNumber}}, concluiu {{classroom}} no ano lectivo '
        '{{academicYear}}, conforme os registos académicos da instituição.\n\n'
        'Certificado n.º {{number}}, emitido em {{issueDate}}.',
  ),
];
