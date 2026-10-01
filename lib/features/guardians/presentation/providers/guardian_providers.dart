import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_envelope.dart';
import '../../../students/data/models/guardian_model.dart';
import '../../../students/domain/student_repositories.dart';
import '../../../students/presentation/providers/student_providers.dart';

/// Pesquisa e página da lista de encarregados (feitas no servidor/handler).
class GuardianListQuery {
  const GuardianListQuery({this.page = 1, this.pageSize = 20, this.q});

  final int page;
  final int pageSize;
  final String? q;
}

class GuardianListQueryNotifier extends Notifier<GuardianListQuery> {
  @override
  GuardianListQuery build() => const GuardianListQuery();

  void setSearch(String text) {
    final q = text.trim();
    state = GuardianListQuery(
      pageSize: state.pageSize,
      q: q.isEmpty ? null : q,
    );
  }

  void setPage(int page) => state = GuardianListQuery(
    page: page,
    pageSize: state.pageSize,
    q: state.q,
  );

  void setPageSize(int size) =>
      state = GuardianListQuery(pageSize: size, q: state.q);
}

final guardianListQueryProvider =
    NotifierProvider<GuardianListQueryNotifier, GuardianListQuery>(
      GuardianListQueryNotifier.new,
    );

final guardianListProvider =
    FutureProvider.autoDispose<PagedList<GuardianModel>>((ref) async {
      final query = ref.watch(guardianListQueryProvider);
      final result = await ref
          .watch(guardianRepositoryProvider)
          .list(page: query.page, pageSize: query.pageSize, q: query.q);
      return result.getOrThrow();
    }, retry: (_, _) => null);

/// Ficha do encarregado.
final guardianProvider = FutureProvider.autoDispose
    .family<GuardianModel, String>(
      (ref, id) async =>
          (await ref.watch(guardianRepositoryProvider).get(id)).getOrThrow(),
      retry: (_, _) => null,
    );

/// Educandos do encarregado, cada um com o seu vínculo.
final guardianPupilsProvider = FutureProvider.autoDispose
    .family<List<GuardianPupil>, String>(
      (ref, id) async =>
          (await ref.watch(guardianRepositoryProvider).pupilsOf(id))
              .getOrThrow(),
      retry: (_, _) => null,
    );
