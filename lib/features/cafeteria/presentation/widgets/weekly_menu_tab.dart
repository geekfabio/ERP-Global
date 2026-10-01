import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/menu.dart';
import '../providers/menu_providers.dart';
import 'meal_dialogs.dart';

const _weekdays = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

/// Menu semanal: um cartão por dia com os pratos de cada tipo de refeição
/// (e respectivos alergénios); quem tem permissão edita cada refeição.
class WeeklyMenuTab extends ConsumerWidget {
  const WeeklyMenuTab({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, {
    required DateTime date,
    required MealType type,
    required List<MealItem> items,
    required MealMenu? menu,
  }) async {
    final ids = await showMenuDialog(
      context,
      date: date,
      type: type,
      options: [
        for (final i in items)
          if (i.mealTypeId == type.id &&
              (i.isActive || (menu?.itemIds.contains(i.id) ?? false)))
            i,
      ],
      selected: menu?.itemIds ?? const [],
    );
    if (ids == null) return;
    final repo = ref.read(menuRepositoryProvider);
    final result = ids.isEmpty && menu != null
        ? await repo.deleteMenu(menu.id)
        : await repo.saveMenu(
            date: dateKey(date),
            mealTypeId: type.id,
            itemIds: ids,
          );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        toast.success('Menu guardado');
        ref.invalidate(weekMenusProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monday = ref.watch(menuWeekProvider);
    final sunday = monday.add(const Duration(days: 6));
    final menus = ref.watch(weekMenusProvider);
    final types = ref.watch(mealTypeListProvider);
    final items = ref.watch(mealItemListProvider);
    final canEdit = ref
        .watch(permissionServiceProvider)
        .canAny('cafeteria.menu.update');
    final notifier = ref.read(menuWeekProvider.notifier);
    final combined = [
      menus,
      types,
      items,
    ].firstWhere((v) => v is! AsyncData, orElse: () => menus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Semana anterior',
                onPressed: () => notifier.shift(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Flexible(
                child: Text(
                  '${PtAoFormatters.date(monday)} – ${PtAoFormatters.date(sunday)}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Semana seguinte',
                onPressed: () => notifier.shift(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (combined) {
            AsyncData() => _Week(
              monday: monday,
              menus: menus.requireValue,
              types: [
                for (final t in types.requireValue)
                  if (t.isActive) t,
              ],
              items: items.requireValue,
              canEdit: canEdit,
              onEdit: (date, type, menu) => _edit(
                context,
                ref,
                date: date,
                type: type,
                items: items.requireValue,
                menu: menu,
              ),
            ),
            _ => AsyncValueView<Object?>(
              value: combined,
              data: (_) => const SizedBox.shrink(),
              onRetry: () {
                ref
                  ..invalidate(weekMenusProvider)
                  ..invalidate(mealTypeListProvider)
                  ..invalidate(mealItemListProvider);
              },
            ),
          },
        ),
      ],
    );
  }
}

class _Week extends StatelessWidget {
  const _Week({
    required this.monday,
    required this.menus,
    required this.types,
    required this.items,
    required this.canEdit,
    required this.onEdit,
  });

  final DateTime monday;
  final List<MealMenu> menus;
  final List<MealType> types;
  final List<MealItem> items;
  final bool canEdit;
  final void Function(DateTime date, MealType type, MealMenu? menu) onEdit;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) {
      return const EmptyState(
        icon: Icons.restaurant_menu_outlined,
        title: 'Sem tipos de refeição',
        message: 'Crie tipos de refeição para montar o menu semanal.',
      );
    }
    final byId = {for (final i in items) i.id: i};
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: 7,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, d) {
        final date = monday.add(Duration(days: d));
        final key = dateKey(date);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_weekdays[d]}, ${PtAoFormatters.date(date)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                for (final t in types)
                  _MealRow(
                    type: t,
                    items: [
                      for (final id
                          in menus
                                  .where(
                                    (m) =>
                                        m.date == key && m.mealTypeId == t.id,
                                  )
                                  .firstOrNull
                                  ?.itemIds ??
                              const <String>[])
                        if (byId[id] != null) byId[id]!,
                    ],
                    onEdit: canEdit
                        ? () => onEdit(
                            date,
                            t,
                            menus
                                .where(
                                  (m) => m.date == key && m.mealTypeId == t.id,
                                )
                                .firstOrNull,
                          )
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.type, required this.items, this.onEdit});

  final MealType type;
  final List<MealItem> items;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${type.name} (${type.startTime}–${type.endTime}) · '
        '${PtAoFormatters.currency(type.priceMinor)}',
      ),
      subtitle: items.isEmpty
          ? Text(
              'Sem menu',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final i in items)
                  Text('${i.name} — ${allergensText(i.allergens)}'),
              ],
            ),
      trailing: onEdit == null
          ? null
          : IconButton(
              tooltip: 'Editar menu de ${type.name}',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
    );
  }
}
