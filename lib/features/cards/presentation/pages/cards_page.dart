import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/card_model.dart';
import '../providers/card_providers.dart';

String cardStatusLabel(CardStatus s) => switch (s) {
  CardStatus.active => 'Activo',
  CardStatus.blocked => 'Bloqueado',
  CardStatus.replaced => 'Substituído',
};

BadgeStatus cardStatusBadge(CardStatus s) => switch (s) {
  CardStatus.active => BadgeStatus.success,
  CardStatus.blocked => BadgeStatus.danger,
  CardStatus.replaced => BadgeStatus.neutral,
};

String holderTypeLabel(CardHolderType t) => switch (t) {
  CardHolderType.student => 'Aluno',
  CardHolderType.staff => 'Funcionário',
};

/// Gestão de cartões escolares: emitir, bloquear, 2.ª via e associar titular.
class CardsPage extends ConsumerStatefulWidget {
  const CardsPage({super.key});

  @override
  ConsumerState<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends ConsumerState<CardsPage> {
  Future<void> _run(
    Future<Result<CardModel>> Function() action, {
    required String done,
    required AuditAction audit,
    CardModel? before,
  }) async {
    final result = await action();
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (card) {
        // Acção sensível: fica em auditoria (falhar aqui não anula a acção).
        unawaited(
          ref
              .read(auditServiceProvider)
              .record(
                entity: 'card',
                action: audit,
                entityId: card.id,
                before: before?.toJson(),
                after: card.toJson(),
              ),
        );
        toast.success(done);
        ref.invalidate(cardListProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _issue() async {
    final v = await showCardForm(
      context,
      title: 'Emitir cartão',
      withUid: true,
    );
    if (v == null) return;
    await _run(
      () => ref
          .read(cardRepositoryProvider)
          .issue(
            uid: v.uid,
            holderId: v.holderId,
            holderName: v.holderName,
            holderType: v.holderType,
          ),
      done: 'Cartão emitido',
      audit: AuditAction.create,
    );
  }

  Future<void> _block(CardModel card) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Bloquear cartão',
      message: 'Bloquear o cartão ${card.uid} de ${card.holderName}?',
      confirmLabel: 'Bloquear',
      destructive: true,
    );
    if (!ok) return;
    await _run(
      () => ref.read(cardRepositoryProvider).block(card.id),
      done: 'Cartão bloqueado',
      audit: AuditAction.cancel,
      before: card,
    );
  }

  Future<void> _replace(CardModel card) async {
    final v = await showCardForm(
      context,
      title: 'Emitir 2.ª via',
      withUid: true,
      withHolder: false,
      subtitle: '${card.holderName} · cartão ${card.uid}',
    );
    if (v == null) return;
    await _run(
      () => ref.read(cardRepositoryProvider).replace(card.id, uid: v.uid),
      done: '2.ª via emitida',
      audit: AuditAction.create,
      before: card,
    );
  }

  Future<void> _associate(CardModel card) async {
    final v = await showCardForm(
      context,
      title: 'Associar titular',
      subtitle: 'Cartão ${card.uid}',
      initial: card,
    );
    if (v == null) return;
    await _run(
      () => ref
          .read(cardRepositoryProvider)
          .associate(
            card.id,
            holderId: v.holderId,
            holderName: v.holderName,
            holderType: v.holderType,
          ),
      done: 'Titular associado',
      audit: AuditAction.update,
      before: card,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardListProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cartões escolares',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Can(
                      permission: 'cards.card.issue',
                      child: AppButton(
                        label: 'Emitir cartão',
                        icon: Icons.add,
                        onPressed: _issue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncValueView<List<CardModel>>(
                  value: cards,
                  onRetry: () => ref.invalidate(cardListProvider),
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.contactless_outlined,
                    title: 'Sem cartões',
                    message: 'Ainda não foram emitidos cartões.',
                  ),
                  data: (items) => _CardsTable(
                    items: items,
                    onBlock: _block,
                    onReplace: _replace,
                    onAssociate: _associate,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardsTable extends ConsumerStatefulWidget {
  const _CardsTable({
    required this.items,
    required this.onBlock,
    required this.onReplace,
    required this.onAssociate,
  });

  final List<CardModel> items;
  final void Function(CardModel) onBlock;
  final void Function(CardModel) onReplace;
  final void Function(CardModel) onAssociate;

  @override
  ConsumerState<_CardsTable> createState() => _CardsTableState();
}

class _CardsTableState extends ConsumerState<_CardsTable> {
  late final TableController<CardModel> _table = TableController(
    rows: widget.items,
    rowId: (c) => c.id,
    columns: [
      AppColumn(label: 'UID', text: (c) => c.uid, sortValue: (c) => c.uid),
      AppColumn(
        label: 'Titular',
        text: (c) => c.holderName,
        sortValue: (c) => c.holderName,
      ),
      AppColumn(label: 'Tipo', text: (c) => holderTypeLabel(c.holderType)),
      AppColumn(
        label: 'Estado',
        text: (c) => cardStatusLabel(c.status),
        sortValue: (c) => c.status.index,
        cell: (c) => StatusBadge(
          label: cardStatusLabel(c.status),
          status: cardStatusBadge(c.status),
        ),
      ),
      AppColumn(
        label: 'Emitido em',
        text: (c) => PtAoFormatters.date(c.issuedAt),
        sortValue: (c) => c.issuedAt,
      ),
    ],
  );

  @override
  void didUpdateWidget(_CardsTable old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<CardModel>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem cartões',
      rowActions: [
        if (p('cards.card.block'))
          RowAction(
            label: 'Bloquear',
            icon: Icons.block,
            onTap: (c) {
              if (c.status == CardStatus.active) widget.onBlock(c);
            },
          ),
        if (p('cards.card.replace'))
          RowAction(
            label: 'Emitir 2.ª via',
            icon: Icons.credit_card,
            onTap: (c) {
              if (c.status != CardStatus.replaced) widget.onReplace(c);
            },
          ),
        if (p('cards.card.associate'))
          RowAction(
            label: 'Associar titular',
            icon: Icons.person_outline,
            onTap: (c) {
              if (c.status != CardStatus.replaced) widget.onAssociate(c);
            },
          ),
      ],
    );
  }
}

/// Valores recolhidos pelo formulário de cartão.
class CardFormValues {
  const CardFormValues({
    this.uid = '',
    this.holderId = '',
    this.holderName = '',
    this.holderType = CardHolderType.student,
  });

  final String uid;
  final String holderId;
  final String holderName;
  final CardHolderType holderType;
}

final _ulid = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');

/// Diálogo para emitir / 2.ª via / associar. `null` se cancelado.
Future<CardFormValues?> showCardForm(
  BuildContext context, {
  required String title,
  bool withUid = false,
  bool withHolder = true,
  String? subtitle,
  CardModel? initial,
}) => showDialog<CardFormValues>(
  context: context,
  builder: (_) => _CardForm(
    title: title,
    withUid: withUid,
    withHolder: withHolder,
    subtitle: subtitle,
    initial: initial,
  ),
);

class _CardForm extends StatefulWidget {
  const _CardForm({
    required this.title,
    required this.withUid,
    required this.withHolder,
    this.subtitle,
    this.initial,
  });

  final String title;
  final bool withUid;
  final bool withHolder;
  final String? subtitle;
  final CardModel? initial;

  @override
  State<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<_CardForm> {
  final _key = GlobalKey<FormState>();
  late final _uid = TextEditingController();
  late final _holderId = TextEditingController(text: widget.initial?.holderId);
  late final _holderName = TextEditingController(
    text: widget.initial?.holderName,
  );
  late CardHolderType _type =
      widget.initial?.holderType ?? CardHolderType.student;

  @override
  void dispose() {
    _uid.dispose();
    _holderId.dispose();
    _holderName.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop(
      CardFormValues(
        uid: _uid.text.trim(),
        holderId: _holderId.text.trim(),
        holderName: _holderName.text.trim(),
        holderType: _type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(widget.subtitle!),
                ),
              if (widget.withUid) ...[
                AppTextField(
                  key: const Key('card_uid'),
                  label: 'UID do cartão',
                  controller: _uid,
                  validator: _required,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (widget.withHolder) ...[
                DropdownButtonFormField<CardHolderType>(
                  key: const Key('card_holder_type'),
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de titular',
                  ),
                  items: [
                    for (final t in CardHolderType.values)
                      DropdownMenuItem(
                        value: t,
                        child: Text(holderTypeLabel(t)),
                      ),
                  ],
                  onChanged: (t) => setState(() => _type = t ?? _type),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  key: const Key('card_holder_name'),
                  label: 'Nome do titular',
                  controller: _holderName,
                  validator: _required,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  key: const Key('card_holder_id'),
                  label: 'ID do titular (ULID)',
                  controller: _holderId,
                  validator: (v) =>
                      _required(v) ??
                      (_ulid.hasMatch(v!.trim()) ? null : 'ULID inválido'),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Guardar')),
    ],
  );
}
