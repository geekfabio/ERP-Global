import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/academic_document.dart';
import '../data_mocks/document_templates_seed.dart';
import '../models/academic_document_models.dart';

/// Handlers de `/v1/document-templates` e `/v1/academic-documents`: modelos
/// editáveis, pedido, emissão com numeração sequencial por tipo e ano,
/// anulação e verificação pública por número.
class AcademicDocumentMockHandlers implements MockApiModule {
  AcademicDocumentMockHandlers({this.permissions, DateTime Function()? now})
    : _now = now ?? DateTime.now {
    reset();
  }

  final PermissionService Function()? permissions;
  final DateTime Function() _now;

  late SeedGenerator _ids;
  final Map<String, DocumentTemplateModel> _templates = {};
  final Map<String, AcademicDocumentModel> _documents = {};

  /// `prefixo|ano → última sequência atribuída` (nunca reutilizada).
  final Map<String, int> _sequences = {};

  static final _spec = MockListSpec<AcademicDocumentModel>(
    searchText: (d) => '${d.studentName} ${d.number ?? ''}',
    sortable: {
      'requestedAt': (d) => d.requestedAt.microsecondsSinceEpoch,
      'number': (d) => d.number ?? '',
    },
    filterable: {
      'kind': (d) => d.kind.name,
      'status': (d) => d.status.name,
      'studentId': (d) => d.studentId,
    },
    defaultSort: const ['-requestedAt'],
  );

  void reset() {
    _ids = SeedGenerator(471);
    _templates
      ..clear()
      ..addEntries(documentTemplatesSeed().map((t) => MapEntry(t.id, t)));
    _documents.clear();
    _sequences.clear();
  }

  @override
  void register(MockApiRegistry r) {
    const docs = '/v1/academic-documents';
    r
      ..onReset(reset)
      ..get('/v1/document-templates', _listTemplates)
      ..put('/v1/document-templates/{id}', _updateTemplate)
      ..get(docs, _list)
      ..get('$docs/verify', _verify)
      ..post(docs, _request)
      ..post('$docs/{id}/issue', _issue)
      ..post('$docs/{id}/cancel', _cancel);
  }

  bool _can(String permission) =>
      permissions?.call().canAny(permission) ?? true;

  void _require(List<String> any) {
    if (!any.any(_can)) throw const MockApiException.forbidden();
  }

  AcademicDocumentModel _find(MockRequest q) =>
      _documents[q.params['id']] ?? (throw const MockApiException.notFound());

  MockResponse _listTemplates(MockRequest q) {
    _require([
      documentReadPermission,
      documentRequestPermission,
      documentIssuePermission,
      documentTemplatePermission,
    ]);
    return mockPaginate(
      _templates.values,
      q,
      toJson: (t) => t.toJson(),
      spec: MockListSpec<DocumentTemplateModel>(
        sortable: {'name': (t) => t.name},
        defaultSort: const ['name'],
      ),
    );
  }

  MockResponse _updateTemplate(MockRequest q) {
    _require([documentTemplatePermission]);
    final current =
        _templates[q.params['id']] ?? (throw const MockApiException.notFound());
    final body = '${q.jsonBody['body'] ?? ''}'.trim();
    final errors = validateTemplateBody(body);
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final next = current.copyWith(body: body);
    _templates[current.id] = next;
    return MockResponse.ok(next.toJson());
  }

  MockResponse _list(MockRequest q) {
    _require([
      documentReadPermission,
      documentRequestPermission,
      documentIssuePermission,
    ]);
    return mockPaginate(
      _documents.values,
      q,
      toJson: (d) => d.toJson(),
      spec: _spec,
    );
  }

  MockResponse _request(MockRequest q) {
    _require([documentRequestPermission, documentIssuePermission]);
    final body = q.jsonBody;
    final kind = DocumentKind.values
        .where((k) => k.name == body['kind'])
        .firstOrNull;
    final errors = {
      if (kind == null) 'kind': 'Tipo de documento inválido',
      for (final f in ['studentId', 'studentName', 'processNumber'])
        if ('${body[f] ?? ''}'.trim().isEmpty) f: 'Campo obrigatório',
    };
    final purpose = '${body['purpose'] ?? ''}'.trim();
    if (purpose.length > 200) errors['purpose'] = 'No máximo 200 caracteres';
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final raw = body['variables'];
    final variables = raw is Map<String, dynamic>
        ? {
            for (final e in raw.entries)
              if (documentPlaceholders.containsKey(e.key)) e.key: '${e.value}',
          }
        : <String, String>{};
    final now = _now().toUtc();
    final id = _ids.ulid(now);
    final row = AcademicDocumentModel(
      id: id,
      kind: kind!,
      status: DocumentStatus.requested,
      studentId: '${body['studentId']}'.trim(),
      studentName: '${body['studentName']}'.trim(),
      processNumber: '${body['processNumber']}'.trim(),
      purpose: purpose,
      variables: variables,
      requestedAt: now,
    );
    _documents[id] = row;
    return MockResponse.created(row.toJson());
  }

  MockResponse _issue(MockRequest q) {
    _require([documentIssuePermission]);
    final current = _find(q);
    if (current.status != DocumentStatus.requested) {
      throw const MockApiException.conflict(
        'Só é possível emitir um pedido pendente',
      );
    }
    final template = _templates.values
        .where((t) => t.kind == current.kind)
        .firstOrNull;
    if (template == null) {
      throw const MockApiException.conflict(
        'Não existe modelo para este tipo de documento',
      );
    }
    final now = _now().toUtc();
    final key = '${current.kind.prefix}|${now.year}';
    final sequence = (_sequences[key] ?? 0) + 1;
    _sequences[key] = sequence;
    final number = formatDocumentNumber(current.kind, now.year, sequence);
    final content = renderDocumentBody(template.body, {
      ...current.variables,
      'studentName': current.studentName,
      'processNumber': current.processNumber,
      'number': number,
      'issueDate': formatDocumentDate(now),
    });
    final next = current.copyWith(
      status: DocumentStatus.issued,
      number: number,
      content: content,
      issuedAt: now,
    );
    _documents[current.id] = next;
    return MockResponse.ok(next.toJson());
  }

  MockResponse _cancel(MockRequest q) {
    _require([documentIssuePermission]);
    final current = _find(q);
    if (current.status == DocumentStatus.cancelled) {
      throw const MockApiException.conflict('O documento já foi anulado');
    }
    final next = current.copyWith(
      status: DocumentStatus.cancelled,
      cancelledAt: _now().toUtc(),
    );
    _documents[current.id] = next;
    return MockResponse.ok(next.toJson());
  }

  /// Pública: devolve só o que um terceiro pode confirmar.
  MockResponse _verify(MockRequest q) {
    final number = documentNumberFromCode(q.query['number'] ?? '');
    if (number.isEmpty) {
      throw const MockApiException.validation({
        'number': 'Indique o número do documento',
      });
    }
    final doc = _documents.values.where((d) => d.number == number).firstOrNull;
    if (doc == null) throw const MockApiException.notFound();
    return MockResponse.ok(
      DocumentVerificationModel(
        number: number,
        kind: doc.kind,
        status: doc.status,
        studentName: doc.studentName,
        issuedAt: doc.issuedAt,
      ).toJson(),
    );
  }
}
