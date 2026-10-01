import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../data/mock_api/grades_mock_handlers.dart';
import '../../data/repositories/api_assessment_scheme_repository.dart';
import '../../domain/assessment_scheme_repository.dart';

final assessmentSchemeRepositoryProvider = Provider<AssessmentSchemeRepository>(
  (ref) => ApiAssessmentSchemeRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final gradesMockHandlersProvider = Provider<GradesMockHandlers>(
  (ref) => GradesMockHandlers(
    permissions: () => ref.read(permissionServiceProvider),
  ),
);
