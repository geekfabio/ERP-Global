import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/menu.dart';
import '../providers/menu_providers.dart';
import 'meal_dialogs.dart';

StatusBadge _activeBadge(bool active) => StatusBadge(
  label: active ? 'Activo' : 'Inactivo',
  status: active ? BadgeStatus.success : BadgeStatus.neutral,
);

/// Mostra o toast do resultado e devolve `true` se correu bem.
bool _report<T>(WidgetRef ref, Result<T> result, String done) => result.when(
  ok: (_) {
    ref.read(toastProvider.notifier).success(done);
    return true;
  },
  err: (f) {
    ref.read(toastProvider.notifier).error(f.message);
    return false;
  },
);

/// Tipos de refeição: designação, horário e preço.
class MealTypesTab extends ConsumerWidget {
  const MealTypesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(menuRepositoryProvider).types;
    void reload() => ref.invalidate(mealTypeListProvider);

    Future<void> save(MealType? current) async {
      final v = await showMealTypeDialog(context, current);
      if (v == null) return;
      final result = current == null
          ? await repo.create(v)
          : await repo.update(current.id, v);
      if (_report(ref, result, 'Tipo de refeição guardado')) reload();
    }

    Future<void> remove(MealType t) async {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Eliminar tipo de refeição',
        message: 'Eliminar ${t.name}?',
        confirmLabel: 'Eliminar',
        destructive: true,
      );
      if (!ok) return;
      if (_report(ref, await repo.delete(t.id), 'Tipo de refeição eliminado')) {
        reload();
      }
    }

    final can = ref.watch(permissionServiceProvider).canAny;
    return _CatalogTab<MealType>(
      value: ref.watch(mealTypeListProvider),
      onRetry: reload,
      createLabel: 'Novo tipo',
      permission: 'cafeteria.menu',
      onCreate: () => save(null),
      emptyTitle: 'Sem tipos de refeição',
      rowId: (t) => t.id,
      columns: [
        AppColumn(
          label: 'Refeição',
          text: (t) => t.name,
          sortValue: (t) => t.name,
        ),
        AppColumn(
          label: 'Horário',
          text: (t) => '${t.startTime} – ${t.endTime}',
          sortValue: (t) => t.startTime,
        ),
        AppColumn(
          label: 'Preço',
          text: (t) => PtAoFormatters.currency(t.priceMinor),
          sortValue: (t) => t.priceMinor,
        ),
        AppColumn(
          label: 'Estado',
          text: (t) => t.isActive ? 'Activo' : 'Inactivo',
          sortValue: (t) => t.isActive ? 1 : 0,
          cell: (t) => _activeBadge(t.isActive),
        ),
      ],
      actions: [
        if (can('cafeteria.menu.update'))
          RowAction(label: 'Editar', icon: Icons.edit_outlined, onTap: save),
        if (can('cafeteria.menu.delete'))
          RowAction(
            label: 'Eliminar',
            icon: Icons.delete_outline,
            onTap: remove,
          ),
      ],
    );
  }
}

/// Pratos: tipo de refeição, preço e alergénios.
class MealItemsTab extends ConsumerWidget {
  const MealItemsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(menuRepositoryProvider).items;
    final typesValue = ref.watch(mealTypeListProvider);
    final types = typesValue.value ?? const <MealType>[];
    final names = {for (final t in types) t.id: t.name};
    void reload() {
      ref
        ..invalidate(mealItemListProvider)
        ..invalidate(weekMenusProvider);
    }

    Future<void> save(MealItem? current) async {
      final v = await showMealItemDialog(context, types, current);
      if (v == null) return;
      final result = current == null
          ? await repo.create(v)
          : await repo.update(current.id, v);
      if (_report(ref, result, 'Prato guardado')) reload();
    }

    Future<void> remove(MealItem i) async {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Eliminar prato',
        message: 'Eliminar ${i.name}?',
        confirmLabel: 'Eliminar',
        destructive: true,
      );
      if (!ok) return;
      if (_report(ref, await repo.delete(i.id), 'Prato eliminado')) reload();
    }

    final can = ref.watch(permissionServiceProvider).canAny;
    return _CatalogTab<MealItem>(
      // Espera pelos tipos para que a coluna "Refeição" fique completa.
      value: typesValue.hasValue
          ? ref.watch(mealItemListProvider)
          : typesValue.whenData((_) => const <MealItem>[]),
      onRetry: reload,
      createLabel: 'Novo prato',
      permission: 'cafeteria.menu',
      onCreate: () => save(null),
      emptyTitle: 'Sem pratos',
      rowId: (i) => i.id,
      columns: [
        AppColumn(
          label: 'Prato',
          text: (i) => i.name,
          sortValue: (i) => i.name,
        ),
        AppColumn(
          label: 'Refeição',
          text: (i) => names[i.mealTypeId] ?? '—',
          sortValue: (i) => names[i.mealTypeId] ?? '',
        ),
        AppColumn(
          label: 'Preço',
          text: (i) => PtAoFormatters.currency(i.priceMinor),
          sortValue: (i) => i.priceMinor,
        ),
        AppColumn(
          label: 'Alergénios',
          text: (i) => allergensText(i.allergens),
          sortValue: (i) => i.allergens.length,
        ),
        AppColumn(
          label: 'Estado',
          text: (i) => i.isActive ? 'Activo' : 'Inactivo',
          sortValue: (i) => i.isActive ? 1 : 0,
          cell: (i) => _activeBadge(i.isActive),
        ),
      ],
      actions: [
        if (can('cafeteria.menu.update'))
          RowAction(label: 'Editar', icon: Icons.edit_outlined, onTap: save),
        if (can('cafeteria.menu.delete'))
          RowAction(
            label: 'Eliminar',
            icon: Icons.delete_outline,
            onTap: remove,
          ),
      ],
    );
  }
}

class _CatalogTab<T> extends StatelessWidget {
  const _CatalogTab({
    required this.value,
    required this.onRetry,
    required this.createLabel,
    required this.permission,
    required this.onCreate,
    required this.emptyTitle,
    required this.rowId,
    required this.columns,
    required this.actions,
  });

  final AsyncValue<List<T>> value;
  final VoidCallback onRetry;
  final String createLabel;
  final String permission;
  final VoidCallback onCreate;
  final String emptyTitle;
  final String Function(T) rowId;
  final List<AppColumn<T>> columns;
  final List<RowAction<T>> actions;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Align(
          alignment: Alignment.centerRight,
          child: Can(
            permission: '$permission.create',
            child: AppButton(
              label: createLabel,
              icon: Icons.add,
              onPressed: onCreate,
            ),
          ),
        ),
      ),
      Expanded(
        child: AsyncValueView<List<T>>(
          value: value,
          onRetry: onRetry,
          isEmpty: (d) => d.isEmpty,
          empty: EmptyState(
            icon: Icons.restaurant_menu_outlined,
            title: emptyTitle,
          ),
          data: (items) => _CatalogTable<T>(
            items: items,
            rowId: rowId,
            columns: columns,
            actions: actions,
          ),
        ),
      ),
    ],
  );
}

class _CatalogTable<T> extends StatefulWidget {
  const _CatalogTable({
    required this.items,
    required this.rowId,
    required this.columns,
    required this.actions,
  });

  final List<T> items;
  final String Function(T) rowId;
  final List<AppColumn<T>> columns;
  final List<RowAction<T>> actions;

  @override
  State<_CatalogTable<T>> createState() => _CatalogTableState<T>();
}

class _CatalogTableState<T> extends State<_CatalogTable<T>> {
  late final TableController<T> _table = TableController(
    rows: widget.items,
    rowId: widget.rowId,
    columns: widget.columns,
  );

  @override
  void didUpdateWidget(_CatalogTable<T> old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<T>(
    controller: _table,
    selectable: false,
    rowActions: widget.actions,
  );
}
