import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/models/portal_teacher_models.dart';
import '../../data/repositories/api_portal_teacher_repository.dart';
import '../../domain/portal_teacher_repository.dart';

final portalTeacherRepositoryProvider = Provider<PortalTeacherRepository>(
  (ref) => ApiPortalTeacherRepository(ref.watch(apiClientProvider)),
);

/// "As minhas turmas" do professor autenticado.
final portalTeacherClassesProvider =
    FutureProvider.autoDispose<List<TeacherClass>>((ref) async {
      final email = ref.watch(currentSessionProvider)?.user.email ?? '';
      final result = await ref
          .watch(portalTeacherRepositoryProvider)
          .myClasses(email: email);
      return result.getOrThrow();
    }, retry: (_, _) => null);
