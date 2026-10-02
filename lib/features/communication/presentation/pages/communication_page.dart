import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/models/agenda_event_model.dart';
import '../../data/models/announcement_model.dart';
import '../../data/models/communication_enums.dart';
import '../providers/communication_providers.dart';
import '../widgets/announcement_form.dart';

String audienceLabel(AnnouncementAudience a) => switch (a) {
  AnnouncementAudience.school => 'Toda a escola',
  AnnouncementAudience.classroom => 'Turma',
  AnnouncementAudience.guardians => 'Encarregados',
};

String channelLabel(String wire) => switch (wire) {
  'in_app' => 'Na app',
  'push' => 'Push',
  'sms' => 'SMS',
  'email' => 'E-mail',
  _ => wire,
};

String eventTypeLabel(AgendaEventType t) => switch (t) {
  AgendaEventType.holiday => 'Feriado',
  AgendaEventType.exam => 'Avaliação',
  AgendaEventType.meeting => 'Reunião',
  AgendaEventType.deadline => 'Prazo',
  AgendaEventType.event => 'Evento',
};

/// Comunicados (por público, com confirmação de leitura) e agenda escolar.
class CommunicationPage extends ConsumerWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
    length: 2,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Comunicação',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Comunicados'),
                  Tab(text: 'Agenda'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [_AnnouncementsTab(), _AgendaTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _AnnouncementsTab extends ConsumerWidget {
  const _AnnouncementsTab();

  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    final draft = await showAnnouncementForm(context);
    if (draft == null || !context.mounted) return;
    final result = await ref.read(announcementRepositoryProvider).create(draft);
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        toast.success('Comunicado enviado');
        ref.invalidate(announcementListProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _confirm(WidgetRef ref, AnnouncementModel a) async {
    final userId = ref.read(currentSessionProvider)?.user.id;
    if (userId == null) return;
    final result = await ref
        .read(announcementRepositoryProvider)
        .confirmRead(a.id, userId: userId);
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        toast.success('Leitura confirmada');
        ref.invalidate(announcementListProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(announcementListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Can(
              permission: 'communication.announcement.create',
              child: AppButton(
                label: 'Novo comunicado',
                icon: Icons.add,
                onPressed: () => _compose(context, ref),
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView(
            value: list,
            onRetry: () => ref.invalidate(announcementListProvider),
            isEmpty: (d) => d.items.isEmpty,
            empty: const EmptyState(
              icon: Icons.campaign_outlined,
              title: 'Sem comunicados',
              message: 'Ainda não foram publicados comunicados.',
            ),
            data: (page) => ListView.builder(
              itemCount: page.items.length,
              itemBuilder: (context, i) {
                final a = page.items[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(a.body),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${audienceLabel(a.audience)} · '
                          '${a.channels.map(channelLabel).join(', ')}'
                          '${a.publishedAt == null ? '' : ' · ${PtAoFormatters.date(a.publishedAt!)}'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (a.requiresReadReceipt)
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpacing.md,
                            children: [
                              StatusBadge(
                                label:
                                    'Lido ${a.readCount}/${a.recipientCount}',
                                status: BadgeStatus.info,
                              ),
                              TextButton(
                                onPressed: () => _confirm(ref, a),
                                child: const Text('Confirmar leitura'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AgendaTab extends ConsumerWidget {
  const _AgendaTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(agendaEventsProvider);
    return AsyncValueView(
      value: events,
      onRetry: () => ref.invalidate(agendaEventsProvider),
      isEmpty: (d) => d.items.isEmpty,
      empty: const EmptyState(
        icon: Icons.event_outlined,
        title: 'Agenda vazia',
        message: 'Não há eventos agendados.',
      ),
      data: (page) => ListView(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        children: [for (final e in page.items) _EventTile(event: e)],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final AgendaEventModel event;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.event_outlined),
      title: Text(event.title),
      subtitle: Text(
        event.allDay
            ? PtAoFormatters.date(event.startsAt)
            : PtAoFormatters.dateTime(event.startsAt.toLocal()),
      ),
      trailing: StatusBadge(
        label: eventTypeLabel(event.type),
        status: event.type == AgendaEventType.deadline
            ? BadgeStatus.warning
            : BadgeStatus.neutral,
      ),
    ),
  );
}
