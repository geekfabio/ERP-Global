import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../models/enrollment_model.dart';
import '../models/student_enums.dart';
import '../models/student_model.dart';

/// Renovação em massa: `GET /v1/enrollment-renewals/preview` e
/// `POST /v1/enrollment-renewals`. Partilha o estado em memória de
/// `StudentsMockHandlers`. O resultado final vem do módulo de notas e a
/// ordem das classes da estrutura académica: o cliente junta-os.
class RenewalMockHandlers {
  RenewalMockHandlers({
    required this.students,
    required this.enrollments,
    required this.newId,
  });

  final Map<String, StudentModel> Function() students;
  final Map<String, EnrollmentModel> Function() enrollments;
  final String Function() newId;

  void register(MockApiRegistry r) {
    r
      ..get('/v1/enrollment-renewals/preview', _preview)
      ..post('/v1/enrollment-renewals', _apply);
  }

  static bool _renewable(EnrollmentModel e) =>
      e.status == EnrollmentStatus.confirmed ||
      e.status == EnrollmentStatus.completed;

  Iterable<EnrollmentModel> get _live =>
      enrollments().values.where((e) => e.deletedAt == null);

  bool _hasEnrollmentIn(String studentId, String yearId) => _live.any(
    (e) =>
        e.studentId == studentId &&
        e.academicYearId == yearId &&
        e.status != EnrollmentStatus.cancelled &&
        e.status != EnrollmentStatus.rejected,
  );

  void _checkYears(String? source, String? target) {
    final fields = <String, String>{
      if (source == null || source.isEmpty) 'sourceYearId': 'Campo obrigatório',
      if (target == null || target.isEmpty) 'targetYearId': 'Campo obrigatório',
    };
    if (fields.isNotEmpty) throw MockApiException.validation(fields);
    if (source == target) {
      throw const MockApiException.validation({
        'targetYearId': 'O ano de destino tem de ser diferente do de origem',
      });
    }
  }

  MockResponse _preview(MockRequest req) {
    final source = req.query['sourceYearId'];
    final target = req.query['targetYearId'];
    final classroom = req.query['classroomId'];
    _checkYears(source, target);
    if (classroom == null || classroom.isEmpty) {
      throw const MockApiException.validation({
        'classroomId': 'Campo obrigatório',
      });
    }
    final rows =
        _live
            .where(
              (e) =>
                  e.academicYearId == source &&
                  e.classroomId == classroom &&
                  _renewable(e),
            )
            .toList()
          ..sort((a, b) => (a.rollNumber ?? 0).compareTo(b.rollNumber ?? 0));
    return MockResponse.ok([
      for (final e in rows)
        {
          'enrollment': e.toJson(),
          'studentName': students()[e.studentId]?.fullName ?? e.studentId,
          'processNumber': students()[e.studentId]?.processNumber ?? '',
          'alreadyRenewed': _hasEnrollmentIn(e.studentId, target!),
        },
    ]);
  }

  MockResponse _apply(MockRequest req) {
    final body = req.jsonBody;
    final source = body['sourceYearId'] as String?;
    final target = body['targetYearId'] as String?;
    _checkYears(source, target);
    final raw = body['items'];
    if (raw is! List || raw.isEmpty) {
      throw const MockApiException.validation({
        'items': 'Nenhum aluno para renovar',
      });
    }
    final created = <EnrollmentModel>[];
    final skipped = <Map<String, String>>[];
    final now = DateTime.now().toUtc();
    for (final item in raw.cast<Map<String, dynamic>>()) {
      final id = item['enrollmentId'] as String? ?? '';
      final action = item['action'] as String?;
      final gradeId = item['gradeId'] as String?;
      void skip(String reason) =>
          skipped.add({'enrollmentId': id, 'reason': reason});
      final current = enrollments()[id];
      if (current == null || current.deletedAt != null) {
        skip('Matrícula de origem inexistente');
        continue;
      }
      if (current.academicYearId != source || !_renewable(current)) {
        skip('A matrícula de origem não está confirmada no ano de origem');
        continue;
      }
      if (action != 'promote' && action != 'repeat') {
        skip('Acção inválida');
        continue;
      }
      if (gradeId == null || gradeId.isEmpty) {
        skip('Sem classe de destino');
        continue;
      }
      if ((action == 'repeat') != (gradeId == current.gradeId)) {
        skip('A classe de destino não corresponde à acção');
        continue;
      }
      if (_hasEnrollmentIn(current.studentId, target!)) {
        skip('O aluno já tem matrícula no ano de destino');
        continue;
      }
      final renewal = EnrollmentModel(
        id: newId(),
        institutionId: current.institutionId,
        campusId: current.campusId,
        createdAt: now,
        updatedAt: now,
        studentId: current.studentId,
        academicYearId: target,
        gradeId: gradeId,
        shiftId: current.shiftId,
        type: EnrollmentType.renewal,
        status: EnrollmentStatus.approved,
        enrolledOn: DateTime.utc(now.year, now.month, now.day),
        notes: action == 'promote'
            ? 'Renovação em massa: transição de classe'
            : 'Renovação em massa: repetente',
      );
      enrollments()[renewal.id] = renewal;
      if (current.status == EnrollmentStatus.confirmed) {
        enrollments()[current.id] = current.copyWith(
          status: EnrollmentStatus.completed,
          updatedAt: now,
        );
      }
      created.add(renewal);
    }
    return MockResponse.created({
      'created': [for (final e in created) e.toJson()],
      'skipped': skipped,
    });
  }
}
