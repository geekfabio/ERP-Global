import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../domain/academic_repositories.dart';
import 'academic_form_dialog.dart';
import 'academic_table.dart';

/// Separador CRUD genérico (lista em `AppDataTable` + criar/editar/eliminar),
/// protegido por `academic.<recurso>.{create,update,delete}`.
class CrudTab<T> extends ConsumerWidget {
  const CrudTab({
    super.key,
    required this.value,
    required this.onChanged,
    required this.repository,
    required this.permission,
    required this.noun,
    required this.feminine,
    required this.icon,
    required this.rowId,
    required this.columns,
    required this.fieldsFor,
    required this.fromValues,
    required this.describe,
    this.extraActions = const [],
  });

  final AsyncValue<List<T>> value;

  /// Pede a recarga das listas depois de uma alteração.
  final VoidCallback onChanged;
  final AcademicCrudRepository<T> repository;

  /// Prefixo da permissão, ex.: `academic.level`.
  final String permission;

  /// "ciclo", "classe"… (minúsculas).
  final String noun;
  final bool feminine;
  final IconData icon;
  final String Function(T) rowId;
  final List<AppColumn<T>> columns;
  final List<AcademicField> Function(T? current) fieldsFor;
  final T Function(T? current, Map<String, Object?> values) fromValues;

  /// Texto do registo na confirmação de eliminação.
  final String Function(T) describe;

  /// Acções adicionais por linha (ex.: abrir a ficha), sem permissão própria.
  final List<RowAction<T>> extraActions;

  String get _new => feminine ? 'Nova' : 'Novo';
  String get _done => feminine ? 'registada' : 'registado';

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final v = await showAcademicForm(
      context,
      title: '$_new $noun',
      fields: fieldsFor(null),
    );
    if (v == null) return;
    final result = await repository.create(fromValues(null, v));
    if (reportResult(ref, result, done: '${_cap(noun)} $_done')) onChanged();
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, T row) async {
    final v = await showAcademicForm(
      context,
      title: 'Editar $noun',
      fields: fieldsFor(row),
    );
    if (v == null) return;
    final result = await repository.update(rowId(row), fromValues(row, v));
    if (reportResult(
      ref,
      result,
      done: '${_cap(noun)} ${feminine ? 'actualizada' : 'actualizado'}',
    )) {
      onChanged();
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, T row) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Eliminar $noun',
      message: 'Eliminar ${describe(row)}?',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (!ok) return;
    final result = await repository.delete(rowId(row));
    if (reportResult(
      ref,
      result,
      done: '${_cap(noun)} ${feminine ? 'eliminada' : 'eliminado'}',
    )) {
      onChanged();
    }
  }

  static String _cap(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: '$permission.create',
              child: AppButton(
                label: '$_new $noun',
                icon: Icons.add,
                onPressed: () => _create(context, ref),
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<T>>(
            value: value,
            onRetry: onChanged,
            isEmpty: (d) => d.isEmpty,
            empty: EmptyState(
              icon: icon,
              title: feminine ? 'Sem ${noun}s registadas' : 'Sem ${noun}s',
            ),
            data: (items) => AcademicTable<T>(
              items: items,
              rowId: rowId,
              emptyText: 'Sem resultados',
              columns: columns,
              rowActions: [
                ...extraActions,
                if (can('$permission.update'))
                  RowAction(
                    label: 'Editar',
                    icon: Icons.edit_outlined,
                    onTap: (r) => _edit(context, ref, r),
                  ),
                if (can('$permission.delete'))
                  RowAction(
                    label: 'Eliminar',
                    icon: Icons.delete_outline,
                    onTap: (r) => _delete(context, ref, r),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
