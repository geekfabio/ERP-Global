import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/campus_model.dart';
import '../providers/settings_providers.dart';
import '../settings_strings.dart';

/// Lista de campus/filiais, com criar/editar/eliminar para quem pode editar.
class CampusSection extends ConsumerWidget {
  const CampusSection({super.key, required this.editable});

  final bool editable;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    CampusModel campus,
  ) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: SettingsStrings.delete,
      message: '${SettingsStrings.confirmDelete}\n${campus.name}',
      confirmLabel: SettingsStrings.delete,
      cancelLabel: SettingsStrings.cancel,
      destructive: true,
    );
    if (!confirmed) return;
    final result = await ref
        .read(settingsRepositoryProvider)
        .deleteCampus(campus.id);
    final toasts = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        ref.invalidate(campusesProvider);
        toasts.success(SettingsStrings.campusDeleted);
      },
      err: (f) => toasts.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campuses = ref.watch(campusesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (editable)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: SettingsStrings.newCampus,
                icon: Icons.add,
                onPressed: () => showCampusDialog(context),
              ),
            ),
          ),
        Expanded(
          child: AsyncValueView<List<CampusModel>>(
            value: campuses,
            onRetry: () => ref.invalidate(campusesProvider),
            isEmpty: (rows) => rows.isEmpty,
            empty: const EmptyState(
              icon: Icons.apartment_outlined,
              title: SettingsStrings.campusEmpty,
            ),
            data: (rows) => _CampusTable(
              rows: rows,
              onEdit: editable
                  ? (campus) => showCampusDialog(context, campus: campus)
                  : null,
              onDelete: editable
                  ? (campus) => _delete(context, ref, campus)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _CampusTable extends StatefulWidget {
  const _CampusTable({required this.rows, this.onEdit, this.onDelete});

  final List<CampusModel> rows;
  final void Function(CampusModel)? onEdit;
  final void Function(CampusModel)? onDelete;

  @override
  State<_CampusTable> createState() => _CampusTableState();
}

class _CampusTableState extends State<_CampusTable> {
  late final _controller = TableController<CampusModel>(
    rows: widget.rows,
    rowId: (c) => c.id,
    columns: [
      AppColumn(
        label: SettingsStrings.name,
        text: (c) => c.name,
        sortValue: (c) => c.name,
      ),
      AppColumn(label: SettingsStrings.address, text: (c) => c.address),
      AppColumn(label: SettingsStrings.phone, text: (c) => c.phone),
    ],
  );

  @override
  void didUpdateWidget(covariant _CampusTable old) {
    super.didUpdateWidget(old);
    if (old.rows != widget.rows) _controller.setRows(widget.rows);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<CampusModel>(
    controller: _controller,
    selectable: false,
    emptyText: SettingsStrings.campusEmpty,
    rowActions: [
      if (widget.onEdit != null)
        RowAction(
          label: SettingsStrings.edit,
          icon: Icons.edit_outlined,
          onTap: widget.onEdit!,
        ),
      if (widget.onDelete != null)
        RowAction(
          label: SettingsStrings.delete,
          icon: Icons.delete_outline,
          onTap: widget.onDelete!,
        ),
    ],
  );
}

/// Diálogo de criação/edição de campus.
Future<void> showCampusDialog(BuildContext context, {CampusModel? campus}) =>
    showDialog<void>(
      context: context,
      builder: (_) => _CampusDialog(campus: campus),
    );

class _CampusDialog extends ConsumerStatefulWidget {
  const _CampusDialog({this.campus});

  final CampusModel? campus;

  @override
  ConsumerState<_CampusDialog> createState() => _CampusDialogState();
}

class _CampusDialogState extends ConsumerState<_CampusDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.campus?.name);
  late final _address = TextEditingController(text: widget.campus?.address);
  late final _phone = TextEditingController(text: widget.campus?.phone);
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? SettingsStrings.required : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(settingsRepositoryProvider).saveCampus({
      'name': _name.text.trim(),
      'address': _address.text.trim(),
      'phone': _phone.text.trim(),
    }, id: widget.campus?.id);
    if (!mounted) return;
    result.when(
      ok: (_) {
        ref.invalidate(campusesProvider);
        Navigator.pop(context);
        ref.read(toastProvider.notifier).success(SettingsStrings.saved);
      },
      err: (f) => setState(() {
        _busy = false;
        _error = f.message;
      }),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.campus == null
          ? SettingsStrings.newCampus
          : SettingsStrings.editCampus,
    ),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: SettingsStrings.name,
              controller: _name,
              validator: _required,
              enabled: !_busy,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: SettingsStrings.address,
              controller: _address,
              validator: _required,
              enabled: !_busy,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: SettingsStrings.phone,
              controller: _phone,
              validator: _required,
              enabled: !_busy,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      AppButton(
        label: SettingsStrings.cancel,
        variant: AppButtonVariant.text,
        onPressed: _busy ? null : () => Navigator.pop(context),
      ),
      AppButton(
        label: SettingsStrings.save,
        loading: _busy,
        onPressed: _busy ? null : _save,
      ),
    ],
  );
}
