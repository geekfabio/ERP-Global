import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/schedule_mock_handlers.dart';
import '../../data/models/schedule_models.dart';
import '../../data/repositories/api_academic_repositories.dart';
import '../../domain/academic_repositories.dart';

final scheduleRepositoryProvider = Provider<ScheduleSlotRepository>(
  (ref) => apiScheduleSlotRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos horários, registados em `main.dart` (só com mock activo).
final scheduleMockHandlersProvider = Provider<ScheduleMockHandlers>(
  (ref) => ScheduleMockHandlers(),
);

/// Todas as aulas do horário (percorre as páginas do servidor).
final scheduleListProvider =
    FutureProvider.autoDispose<List<ScheduleSlotModel>>((ref) async {
      final repo = ref.watch(scheduleRepositoryProvider);
      final items = <ScheduleSlotModel>[];
      var page = 1;
      while (true) {
        final PagedList<ScheduleSlotModel> result = (await repo.list(
          page: page,
        )).getOrThrow();
        items.addAll(result.items);
        if (!result.meta.hasNext) return items;
        page++;
      }
    }, retry: (_, _) => null);
