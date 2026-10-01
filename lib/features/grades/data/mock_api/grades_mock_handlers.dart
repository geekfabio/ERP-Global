import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/assessment_engine.dart';
import '../../domain/assessment_scheme_repository.dart';
import '../data_mocks/assessment_scheme_seed.dart';
import '../models/assessment_scheme_model.dart';
import 'academic_document_mock_handlers.dart';
import 'council_mock_handlers.dart';
import 'grade_entry_mock_handlers.dart';
import 'report_card_mock_handlers.dart';

/// Handlers de `/v1/assessment-schemes`. Valida pesos, escala e unicidade
/// por classe/curso como o servidor faria.
class GradesMockHandlers implements MockApiModule {
  GradesMockHandlers({this.permissions, this.termLookup, this.now}) {
    _reset();
  }

  final PermissionService Function()? permissions;

  /// Estado dos trimestres (módulo académico), para o lançamento de notas.
  final GradeTermLookup? termLookup;
  final DateTime Function()? now;

  late final GradeEntryMockHandlers _entries = GradeEntryMockHandlers(
    schemes: () => _rows.values,
    permissions: permissions,
    termLookup: termLookup,
    now: now,
  );

  late final ReportCardMockHandlers _reportCards = ReportCardMockHandlers(
    permissions: permissions,
    now: now,
  );

  late final CouncilMockHandlers _councils = CouncilMockHandlers(
    permissions: permissions,
    now: now,
  );

  late final AcademicDocumentMockHandlers _documents =
      AcademicDocumentMockHandlers(permissions: permissions, now: now);

  late SeedGenerator _ids;
  final Map<String, AssessmentSchemeModel> _rows = {};

  static final _spec = MockListSpec<AssessmentSchemeModel>(
    searchText: (s) => s.name,
    sortable: {'name': (s) => foldText(s.name)},
    filterable: {'gradeId': (s) => s.gradeId, 'courseId': (s) => s.courseId},
    defaultSort: const ['name'],
  );

  void _reset() {
    _ids = SeedGenerator(461);
    _rows
      ..clear()
      ..addEntries(assessmentSchemeSeed().map((s) => MapEntry(s.id, s)));
  }

  MockHandler _guard(String permission, MockHandler handler) => (request) {
    final service = permissions?.call();
    if (service != null && !service.can(permission)) {
      throw const MockApiException.forbidden();
    }
    return handler(request);
  };

  AssessmentSchemeModel _find(MockRequest q) =>
      _rows[q.params['id']] ?? (throw const MockApiException.notFound());

  @override
  void register(MockApiRegistry r) {
    const path = '/v1/assessment-schemes';
    _entries.register(r);
    _reportCards.register(r);
    _councils.register(r);
    _documents.register(r);
    r
      ..onReset(_reset)
      ..get(
        path,
        _guard(
          schemeReadPermission,
          (q) => mockPaginate(
            _rows.values,
            q,
            toJson: (v) => v.toJson(),
            spec: _spec,
          ),
        ),
      )
      ..post(
        path,
        _guard(schemeUpdatePermission, (q) {
          final id = _ids.ulid(DateTime.now().toUtc());
          final row = _build({...q.jsonBody, 'id': id});
          _rows[id] = row;
          return MockResponse.created(row.toJson());
        }),
      )
      ..patch(
        '$path/{id}',
        _guard(schemeUpdatePermission, (q) {
          final current = _find(q);
          final row = _build({
            ...current.toJson(),
            ...q.jsonBody,
            'id': current.id,
          });
          _rows[current.id] = row;
          return MockResponse.ok(row.toJson());
        }),
      )
      ..delete(
        '$path/{id}',
        _guard(schemeUpdatePermission, (q) {
          final row = _find(q);
          if (row.gradeId == null && row.courseId == null) {
            throw const MockApiException.conflict(
              'O esquema geral da instituição não pode ser eliminado',
            );
          }
          _rows.remove(row.id);
          return MockResponse.ok(null);
        }),
      );
  }

  AssessmentSchemeModel _build(Map<String, dynamic> body) {
    final AssessmentSchemeModel scheme;
    try {
      scheme = AssessmentSchemeModel.fromJson(body);
    } on Object {
      throw const MockApiException.validation({'body': 'Dados inválidos'});
    }
    final errors = validateScheme(scheme);
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final duplicate = _rows.values.any(
      (s) =>
          s.id != scheme.id &&
          s.gradeId == scheme.gradeId &&
          s.courseId == scheme.courseId,
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'Já existe um esquema para esta classe e curso',
      );
    }
    return scheme;
  }
}
