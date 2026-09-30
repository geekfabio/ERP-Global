import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../data/mock_api/communication_mock_handlers.dart';
import '../../data/models/agenda_event_model.dart';
import '../../data/models/announcement_model.dart';
import '../../data/repositories/api_communication_repositories.dart';
import '../../domain/communication_repositories.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => ApiAnnouncementRepository(ref.watch(apiClientProvider)),
);

final agendaRepositoryProvider = Provider<AgendaRepository>(
  (ref) => ApiAgendaRepository(ref.watch(apiClientProvider)),
);

/// Implementação do contrato `core`; `main.dart` liga-a a
/// `notificationServiceProvider` para que outros módulos enviem notificações.
final communicationNotificationServiceProvider = Provider<NotificationService>(
  (ref) => ApiNotificationService(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final communicationMockHandlersProvider = Provider<CommunicationMockHandlers>(
  (ref) => CommunicationMockHandlers(),
);

/// Comunicados (mais recentes primeiro). Falhas chegam à UI como `AsyncError`.
final announcementListProvider =
    FutureProvider.autoDispose<PagedList<AnnouncementModel>>(
      (ref) async =>
          (await ref.watch(announcementRepositoryProvider).list()).getOrThrow(),
      retry: (_, _) => null,
    );

/// Eventos da agenda, por ordem cronológica.
final agendaEventsProvider =
    FutureProvider.autoDispose<PagedList<AgendaEventModel>>(
      (ref) async =>
          (await ref.watch(agendaRepositoryProvider).list(pageSize: 100))
              .getOrThrow(),
      retry: (_, _) => null,
    );
