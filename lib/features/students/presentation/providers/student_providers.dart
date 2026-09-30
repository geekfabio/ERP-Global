import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/network/api_client.dart';
import '../../data/mock_api/students_mock_handlers.dart';
import '../../data/repositories/api_student_repositories.dart';
import '../../data/repositories/drift_student_repository.dart';
import '../../domain/student_repositories.dart';

/// Troca API/Mock ↔ Drift por configuração (`AppConfig.useLocalDb`); a UI só
/// conhece [StudentRepository].
final useLocalDbProvider = Provider<bool>((ref) => AppConfig.useLocalDb);

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => ref.watch(useLocalDbProvider)
      ? DriftStudentRepository(ref.watch(appDatabaseProvider))
      : ApiStudentRepository(ref.watch(apiClientProvider)),
);

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
