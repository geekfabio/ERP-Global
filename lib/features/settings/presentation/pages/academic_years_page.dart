import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/academic_year_model.dart';
import '../../data/models/term_model.dart';
import '../../domain/academic_rules.dart';
import '../academic_strings.dart';
import '../providers/academic_providers.dart';
import '../widgets/academic_dialogs.dart';

BadgeStatus yearBadge(AcademicYearStatus s) => switch (s) {
  AcademicYearStatus.planned => BadgeStatus.neutral,
  AcademicYearStatus.active => BadgeStatus.success,
  AcademicYearStatus.closing => BadgeStatus.warning,
  AcademicYearStatus.closed => BadgeStatus.info,
};

/// Anos lectivos e respectivos períodos (`/settings/academic-year`).
class AcademicYearsPage extends ConsumerWidget {
  const AcademicYearsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = ref
        .watch(permissionServiceProvider)
        .can(academicUpdatePermission);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (editable)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: AcademicStrings.newYear,
                icon: Icons.add,
                onPressed: () => showYearDialog(context),
              ),
            ),
          ),
        Expanded(
          child: AsyncValueView<List<AcademicYearModel>>(
            value: ref.watch(academicYearsProvider),
            onRetry: () => ref.invalidate(academicYearsProvider),
            isEmpty: (rows) => rows.isEmpty,
            empty: const EmptyState(
              icon: Icons.event_note_outlined,
              title: AcademicStrings.empty,
            ),
            data: (years) => ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final year in years)
                  YearCard(
                    key: ValueKey(year.id),
                    year: year,
                    editable: editable,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class YearCard extends ConsumerWidget {
  const YearCard({super.key, required this.year, required this.editable});

  final AcademicYearModel year;
  final bool editable;

  Future<void> _advance(BuildContext context, WidgetRef ref) async {
    final next = nextStatus(year.status)!;
    if (next == AcademicYearStatus.closed &&
        !await showConfirmDialog(
          context: context,
          title: '${AcademicStrings.advance(next)} ${year.code}',
          message: AcademicStrings.confirmClose,
          confirmLabel: AcademicStrings.advance(next),
          cancelLabel: AcademicStrings.cancel,
          destructive: true,
        )) {
      return;
    }
    final result = await ref
        .read(academicActionsProvider)
        .transition(year, next);
    final toasts = ref.read(toastProvider.notifier);
    result.when(
      ok: (y) =>
          toasts.success('${y.code}: ${AcademicStrings.status(y.status)}'),
      err: (f) => toasts.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = nextStatus(year.status);
    return Card(
      child: ExpansionTile(
        initiallyExpanded: year.status == AcademicYearStatus.active,
        title: Row(
          children: [
            Text(year.code, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: AppSpacing.md),
            StatusBadge(
              label: AcademicStrings.status(year.status),
              status: yearBadge(year.status),
            ),
          ],
        ),
        subtitle: Text(
          '${PtAoFormatters.date(year.startDate)} – '
          '${PtAoFormatters.date(year.endDate)}'
          '${isFrozen(year.status) ? ' · ${AcademicStrings.frozen}' : ''}',
        ),
        children: [
          if (editable && next != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppButton(
                  key: Key('advance_${year.id}'),
                  label: AcademicStrings.advance(next),
                  variant: next == AcademicYearStatus.closed
                      ? AppButtonVariant.danger
                      : AppButtonVariant.primary,
                  onPressed: () => _advance(context, ref),
                ),
              ),
            ),
          TermsList(year: year, editable: editable),
        ],
      ),
    );
  }
}

class TermsList extends ConsumerWidget {
  const TermsList({super.key, required this.year, required this.editable});

  final AcademicYearModel year;
  final bool editable;

  Future<void> _toggle(WidgetRef ref, TermModel term) async {
    final actions = ref.read(academicActionsProvider);
    final opening = term.status == TermStatus.closed;
    final reopen = opening && isReopen(term);
    final result = opening
        ? await actions.openTerm(term)
        : await actions.closeTerm(term);
    final toasts = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toasts.success(
        !opening
            ? AcademicStrings.termClosed
            : reopen
            ? AcademicStrings.termReopened
            : AcademicStrings.termOpened,
      ),
      err: (f) => toasts.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canApprove = ref
        .watch(permissionServiceProvider)
        .can(academicApprovePermission);
    final frozen = isFrozen(year.status);
    return AsyncValueView<List<TermModel>>(
      value: ref.watch(termsProvider(year.id)),
      onRetry: () => ref.invalidate(termsProvider(year.id)),
      loading: const LinearProgressIndicator(),
      data: (terms) => Column(
        children: [
          for (final term in terms)
            ListTile(
              key: ValueKey(term.id),
              title: Text(term.name),
              subtitle: Text(
                '${PtAoFormatters.date(term.startDate)} – '
                '${PtAoFormatters.date(term.endDate)} · '
                '${AcademicStrings.gradesDeadline}: '
                '${PtAoFormatters.date(term.gradesDeadline)}',
              ),
              trailing: Wrap(
                spacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(
                    label: term.status == TermStatus.open
                        ? 'Aberto'
                        : 'Fechado',
                    status: term.status == TermStatus.open
                        ? BadgeStatus.success
                        : BadgeStatus.neutral,
                  ),
                  if (editable && !frozen) ...[
                    IconButton(
                      tooltip: AcademicStrings.edit,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showTermDialog(context, term, year),
                    ),
                    if (term.status == TermStatus.open ||
                        (canOpenTerms(year.status) &&
                            (!isReopen(term) || canApprove)))
                      TextButton(
                        key: Key('toggle_${term.id}'),
                        onPressed: () => _toggle(ref, term),
                        child: Text(
                          term.status == TermStatus.open
                              ? AcademicStrings.close
                              : isReopen(term)
                              ? AcademicStrings.reopen
                              : AcademicStrings.open,
                        ),
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
