import '../data/models/academic_document_models.dart';

const documentReadPermission = 'grades.document.read';
const documentRequestPermission = 'grades.document.request';
const documentIssuePermission = 'grades.document.issue';
const documentTemplatePermission = 'grades.document.template';

/// Marcadores admitidos nos modelos, com o rótulo mostrado ao editar.
const documentPlaceholders = <String, String>{
  'studentName': 'Nome do aluno',
  'processNumber': 'N.º de processo',
  'classroom': 'Turma',
  'academicYear': 'Ano lectivo',
  'institutionName': 'Instituição',
  'number': 'N.º do documento',
  'issueDate': 'Data de emissão',
};

const maxDocumentTemplateLength = 2000;

extension DocumentKindX on DocumentKind {
  String get label => switch (this) {
    DocumentKind.enrollmentDeclaration => 'Declaração de matrícula',
    DocumentKind.attendanceDeclaration => 'Declaração de frequência',
    DocumentKind.certificate => 'Certificado de habilitações',
  };

  /// Prefixo da numeração sequencial.
  String get prefix => switch (this) {
    DocumentKind.enrollmentDeclaration => 'DM',
    DocumentKind.attendanceDeclaration => 'DF',
    DocumentKind.certificate => 'CERT',
  };
}

extension DocumentStatusX on DocumentStatus {
  String get label => switch (this) {
    DocumentStatus.requested => 'Pedido',
    DocumentStatus.issued => 'Emitido',
    DocumentStatus.cancelled => 'Anulado',
  };
}

/// `CERT-2026/0001`: sequência própria por tipo e ano, nunca reutilizada.
String formatDocumentNumber(DocumentKind kind, int year, int sequence) =>
    '${kind.prefix}-$year/${sequence.toString().padLeft(4, '0')}';

/// `dd/MM/yyyy` sem depender de dados de locale (corre também no servidor).
String formatDocumentDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/${d.year}';

const _verificationPrefix = 'ERP-GLOBAL/DOC/';

/// Texto codificado no QR de verificação.
String documentVerificationCode(String number) => '$_verificationPrefix$number';

/// Número contido num código de verificação (ou o próprio texto, se já for
/// um número).
String documentNumberFromCode(String input) {
  final text = input.trim();
  return text.startsWith(_verificationPrefix)
      ? text.substring(_verificationPrefix.length)
      : text;
}

final _placeholder = RegExp(r'\{\{\s*(\w+)\s*\}\}');

/// Marcadores usados em [body] que não existem em [documentPlaceholders].
Set<String> unknownPlaceholders(String body) => {
  for (final m in _placeholder.allMatches(body))
    if (!documentPlaceholders.containsKey(m.group(1))) m.group(1)!,
};

/// Substitui os marcadores por [values]; os que faltam ficam como `-`.
String renderDocumentBody(String body, Map<String, String> values) =>
    body.replaceAllMapped(_placeholder, (m) {
      final value = values[m.group(1)];
      return value == null || value.isEmpty ? '-' : value;
    });

/// Erros por campo do corpo de um modelo (vazio = válido).
Map<String, String> validateTemplateBody(String body) {
  final text = body.trim();
  if (text.isEmpty) return {'body': 'O texto do modelo é obrigatório'};
  if (text.length > maxDocumentTemplateLength) {
    return {'body': 'No máximo $maxDocumentTemplateLength caracteres'};
  }
  final unknown = unknownPlaceholders(text);
  if (unknown.isNotEmpty) {
    return {'body': 'Marcadores desconhecidos: ${unknown.join(', ')}'};
  }
  return const {};
}
