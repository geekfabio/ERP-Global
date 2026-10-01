import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../auth/data/data_mocks/auth_mock_data.dart';
import '../../../students/data/data_mocks/student_summaries_seed.dart';
import '../../../students/data/models/guardian_model.dart';
import '../../../students/data/models/student_model.dart';
import '../../domain/portal_repository.dart';

typedef PortalPupilRecord = ({StudentModel student, GuardianLinkModel? link});

/// Handlers de `/v1/portal/*`. O âmbito (educandos vinculados) é decidido aqui,
/// como o servidor faria: a UI nunca filtra por conta própria.
class PortalMockHandlers implements MockApiModule {
  PortalMockHandlers({
    required this.authenticate,
    required this.pupilsFor,
    StudentSummariesSeed? summaries,
  }) : _summaries = summaries ?? StudentSummariesSeed();

  /// Conta do pedido (401 se a sessão for inválida).
  final MockAccount Function(MockRequest request) authenticate;

  /// Educandos da conta (ver `StudentsMockHandlers.pupilsForPortalUser`).
  final List<PortalPupilRecord> Function(
    String userId, {
    required bool isStudent,
  })
  pupilsFor;

  final StudentSummariesSeed _summaries;

  @override
  void register(MockApiRegistry r) {
    r
      ..get('/v1/portal/pupils', _pupils)
      ..get('/v1/portal/pupils/{id}/summary', _summary);
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
