import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/events/domain_event.dart';
import '../../../../core/network/api_client.dart';
import '../../data/mock_api/students_mock_handlers.dart';
import '../../data/repositories/api_student_repositories.dart';
import '../../data/repositories/drift_student_repository.dart';
import '../../data/repositories/fallback_student_repository.dart';
import '../../domain/enrollment_flow.dart';
import '../../domain/student_repositories.dart';

/// Troca API/Mock ↔ Drift por configuração (`AppConfig.useLocalDb`); a UI só
/// conhece [StudentRepository].
final useLocalDbProvider = Provider<bool>((ref) => AppConfig.useLocalDb);

/// Com `AppConfig.localFallback`, a API cai para o Drift quando está offline.
final localFallbackProvider = Provider<bool>((ref) => AppConfig.localFallback);

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  if (ref.watch(useLocalDbProvider)) {
    return DriftStudentRepository(ref.watch(appDatabaseProvider));
  }
  final remote = ApiStudentRepository(ref.watch(apiClientProvider));
  if (!ref.watch(localFallbackProvider)) return remote;
  return FallbackStudentRepository(
    remote: remote,
    local: DriftStudentRepository(ref.watch(appDatabaseProvider)),
  );
});

final guardianRepositoryProvider = Provider<GuardianRepository>(
  (ref) => ApiGuardianRepository(ref.watch(apiClientProvider)),
);

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>(
  (ref) => ApiEnrollmentRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final studentsMockHandlersProvider = Provider<StudentsMockHandlers>(
  (ref) => StudentsMockHandlers(),
);

final studentDocumentRepositoryProvider = Provider<StudentDocumentRepository>(
  (ref) => ApiStudentDocumentRepository(ref.watch(apiClientProvider)),
);

final occurrenceRepositoryProvider = Provider<OccurrenceRepository>(
  (ref) => ApiOccurrenceRepository(ref.watch(apiClientProvider)),
);

final studentSummaryRepositoryProvider = Provider<StudentSummaryRepository>(
  (ref) => ApiStudentSummaryRepository(ref.watch(apiClientProvider)),
);

final enrollmentRulesRepositoryProvider = Provider<EnrollmentRulesRepository>(
  (ref) => ApiEnrollmentRulesRepository(ref.watch(apiClientProvider)),
);

/// Transições da matrícula; publica `EnrollmentConfirmed` no barramento.
final enrollmentWorkflowProvider = Provider<EnrollmentWorkflow>(
  (ref) => EnrollmentWorkflow(
    ref.watch(enrollmentRepositoryProvider),
    ref.watch(domainEventBusProvider),
  ),
);
