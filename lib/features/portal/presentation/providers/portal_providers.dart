import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/license_gate.dart';
import '../../../../core/network/api_client.dart';
import '../../data/mock_api/portal_mock_handlers.dart';
import '../../data/models/portal_models.dart';
import '../../data/repositories/api_portal_repository.dart';
import '../../domain/portal_repository.dart';

final portalRepositoryProvider = Provider<PortalRepository>(
  (ref) => ApiPortalRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do portal. Dependem de auth e alunos, por isso a ligação é
/// feita em `main.dart` (só com mock activo).
final portalMockHandlersProvider = Provider<PortalMockHandlers>(
  (ref) => throw UnimplementedError(
    'portalMockHandlersProvider tem de ser sobreposto em main.dart',
  ),
);

/// Educandos vinculados à conta (o âmbito é decidido pela API).
final portalPupilsProvider = FutureProvider.autoDispose<List<PortalPupil>>((
  ref,
) async {
  final result = await ref.watch(portalRepositoryProvider).pupils();
  return result.getOrThrow();
}, retry: (_, _) => null);

/// Educando escolhido no selector; `null` = o primeiro da lista.
class SelectedPupilNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String studentId) => state = studentId;
}

final selectedPupilIdProvider =
    NotifierProvider<SelectedPupilNotifier, String?>(SelectedPupilNotifier.new);

/// Educando activo: o escolhido, se ainda vinculado, senão o primeiro.
PortalPupil? activePupil(List<PortalPupil> pupils, String? selectedId) {
  if (pupils.isEmpty) return null;
  return pupils.firstWhere(
    (p) => p.student.id == selectedId,
    orElse: () => pupils.first,
  );
}

/// Módulos da Home que estão licenciados — só estes são pedidos e mostrados.
final portalSummaryModulesProvider = Provider<Set<String>>((ref) {
  final enabled = ref.watch(enabledModulesProvider);
  return portalSummaryModules.where(enabled.contains).toSet();
});

final portalSummaryProvider = FutureProvider.autoDispose
    .family<PortalSummary, String>((ref, studentId) async {
      final modules = ref.watch(portalSummaryModulesProvider);
      if (modules.isEmpty) return const PortalSummary();
      final result = await ref
          .watch(portalRepositoryProvider)
          .summary(studentId, modules: modules);
      return result.getOrThrow();
    }, retry: (_, _) => null);
