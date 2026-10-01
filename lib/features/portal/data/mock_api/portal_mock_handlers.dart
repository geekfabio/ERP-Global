import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../auth/data/data_mocks/auth_mock_data.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../../students/data/data_mocks/student_summaries_seed.dart';
import '../../../students/data/models/guardian_model.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../domain/portal_repository.dart';
import '../models/portal_academic_models.dart';

typedef PortalPupilRecord = ({StudentModel student, GuardianLinkModel? link});

/// Handlers de `/v1/portal/*`. O âmbito (educandos vinculados) é decidido aqui,
/// como o servidor faria: a UI nunca filtra por conta própria.
class PortalMockHandlers implements MockApiModule {
  PortalMockHandlers({
    required this.authenticate,
    required this.pupilsFor,
    this.scheduleFor,
    StudentSummariesSeed? summaries,
    DateTime Function()? now,
  }) : _summaries = summaries ?? StudentSummariesSeed(),
       _now = now ?? DateTime.now;

  /// Conta do pedido (401 se a sessão for inválida).
  final MockAccount Function(MockRequest request) authenticate;

  /// Educandos da conta (ver `StudentsMockHandlers.pupilsForPortalUser`).
  final List<PortalPupilRecord> Function(
    String userId, {
    required bool isStudent,
  })
  pupilsFor;

  /// Aulas (JSON de `PortalScheduleSlot`) da turma actual do educando; ligado
  /// em `main.dart` ao horário do módulo académico. `null` = sem horário.
  final List<Map<String, dynamic>> Function(String studentId)? scheduleFor;

  final StudentSummariesSeed _summaries;
  final DateTime Function() _now;

  final List<AbsenceJustificationRequest> _justifications = [];
  final List<PortalDocumentRequest> _documents = [];
  final SeedGenerator _ids = SeedGenerator(750);

  static const _maxReason = 500;
  static const _maxNotes = 300;

  void reset() {
    _justifications.clear();
    _documents.clear();
  }

  @override
  void register(MockApiRegistry r) {
    const pupil = '/v1/portal/pupils/{id}';
    r
      ..onReset(reset)
      ..get('/v1/portal/pupils', _pupils)
      ..get('$pupil/summary', _summary)
      ..get(
        '$pupil/grades',
        (q) => MockResponse.ok(_summaries.grades(_pupilId(q)).toJson()),
      )
      ..get(
        '$pupil/attendance',
        (q) => MockResponse.ok(_summaries.attendance(_pupilId(q)).toJson()),
      )
      ..get(
        '$pupil/schedule',
        (q) => MockResponse.ok(scheduleFor?.call(_pupilId(q)) ?? const []),
      )
      ..get('$pupil/absence-justifications', (q) {
        final id = _pupilId(q);
        return MockResponse.ok([
          for (final j in _justifications)
            if (j.studentId == id) j.toJson(),
        ]);
      })
      ..post('$pupil/absence-justifications', _requestJustification)
      ..get('$pupil/document-requests', (q) {
        final id = _pupilId(q);
        return MockResponse.ok([
          for (final d in _documents)
            if (d.studentId == id) d.toJson(),
        ]);
      })
      ..post('$pupil/document-requests', _requestDocument);
  }

  /// Id do educando do caminho, só se vinculado à conta (senão 403).
  String _pupilId(MockRequest req) {
    final id = req.params['id'];
    if (!_scoped(req).any((p) => p.student.id == id)) {
      throw const MockApiException.forbidden(
        'Educando não vinculado a esta conta',
      );
    }
    return id!;
  }

  MockResponse _requestJustification(MockRequest req) {
    final id = _pupilId(req);
    final body = req.jsonBody;
    final reason = '${body['reason'] ?? ''}'.trim();
    final date = DateTime.tryParse('${body['date'] ?? ''}');
    final errors = <String, String>{
      if (reason.isEmpty)
        'reason': 'Campo obrigatório'
      else if (reason.length > _maxReason)
        'reason': 'No máximo $_maxReason caracteres',
      if (date == null) 'date': 'Data inválida',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final day = DateTime.utc(date!.year, date.month, date.day);
    final absent = _summaries
        .attendance(id)
        .records
        .any((r) => r.kind == AttendanceKind.unjustified && r.date == day);
    if (!absent) {
      throw const MockApiException.validation({
        'date': 'Não há falta injustificada neste dia',
      });
    }
    final duplicate = _justifications.any(
      (j) =>
          j.studentId == id &&
          j.date == day &&
          j.status != PortalRequestStatus.rejected,
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'Já existe um pedido de justificação para este dia',
      );
    }
    final now = _now().toUtc();
    final created = AbsenceJustificationRequest(
      id: _ids.ulid(now),
      studentId: id,
      date: day,
      reason: reason,
      status: PortalRequestStatus.pending,
      createdAt: now,
    );
    _justifications.add(created);
    return MockResponse.created(created.toJson());
  }

  MockResponse _requestDocument(MockRequest req) {
    final id = _pupilId(req);
    final body = req.jsonBody;
    final kind = PortalDocumentKind.parse(body['kind'] as String?);
    final notes = '${body['notes'] ?? ''}'.trim();
    final errors = <String, String>{
      if (kind == null) 'kind': 'Tipo de documento inválido',
      if (notes.length > _maxNotes) 'notes': 'No máximo $_maxNotes caracteres',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final pending = _documents.any(
      (d) =>
          d.studentId == id &&
          d.kind == kind &&
          d.status == PortalRequestStatus.pending,
    );
    if (pending) {
      throw const MockApiException.conflict(
        'Já existe um pedido pendente deste documento',
      );
    }
    final now = _now().toUtc();
    final created = PortalDocumentRequest(
      id: _ids.ulid(now),
      studentId: id,
      kind: kind!,
      status: PortalRequestStatus.pending,
      createdAt: now,
      notes: notes.isEmpty ? null : notes,
    );
    _documents.add(created);
    return MockResponse.created(created.toJson());
  }

  List<PortalPupilRecord> _scoped(MockRequest req) {
    final account = authenticate(req);
    final perms = account.permissions;
    final isStudent = perms.contains('portal.self.read');
    if (!isStudent && !perms.contains('portal.child.read')) {
      throw const MockApiException.forbidden();
    }
    return pupilsFor(account.user.id, isStudent: isStudent);
  }

  MockResponse _pupils(MockRequest req) => MockResponse.ok([
    for (final p in _scoped(req))
      {'student': p.student.toJson(), 'link': p.link?.toJson()},
  ]);

  MockResponse _summary(MockRequest req) {
    final id = req.params['id'];
    if (!_scoped(req).any((p) => p.student.id == id)) {
      throw const MockApiException.forbidden(
        'Educando não vinculado a esta conta',
      );
    }
    final wanted = (req.query['modules'] ?? '')
        .split(',')
        .where(portalSummaryModules.contains)
        .toSet();
    return MockResponse.ok({
      if (wanted.contains('grades')) 'grades': _summaries.grades(id!).toJson(),
      if (wanted.contains('attendance'))
        'attendance': _summaries.attendance(id!).toJson(),
      if (wanted.contains('billing'))
        'finance': _summaries.finance(id!).toJson(),
      if (wanted.contains('cards')) 'card': _summaries.card(id!).toJson(),
    });
  }
}
