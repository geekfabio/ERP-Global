import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/wallet.dart';
import '../providers/wallet_providers.dart';

const walletMethodLabels = <String, String>{
  'cash': 'Numerário',
  'bank_transfer': 'Transferência',
  'card': 'TPA / Multicaixa',
  'payment_reference': 'Referência de pagamento',
};

String walletTransactionLabel(WalletTransactionType t) => switch (t) {
  WalletTransactionType.topup => 'Carregamento',
  WalletTransactionType.purchase => 'Consumo',
  WalletTransactionType.refund => 'Estorno',
};

String? _required(String? v) =>
    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;

final _ulid = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');

class OpenWalletValues {
  const OpenWalletValues(this.holderId, this.holderName, this.dailyLimitMinor);
  final String holderId;
  final String holderName;
  final int dailyLimitMinor;
}

Future<OpenWalletValues?> showOpenWalletDialog(BuildContext context) =>
    showDialog<OpenWalletValues>(
      context: context,
      builder: (_) => const _OpenWalletDialog(),
    );

class _OpenWalletDialog extends StatefulWidget {
  const _OpenWalletDialog();

  @override
  State<_OpenWalletDialog> createState() => _OpenWalletDialogState();
}

class _OpenWalletDialogState extends State<_OpenWalletDialog> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _limit = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _limit.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop(
      OpenWalletValues(
        _id.text.trim(),
        _name.text.trim(),
        parseMinorUnits(_limit.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Abrir carteira'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                key: const Key('wallet_holder_name'),
                label: 'Nome do titular',
                controller: _name,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                key: const Key('wallet_holder_id'),
                label: 'ID do titular (ULID)',
                controller: _id,
                validator: (v) =>
                    _required(v) ??
                    (_ulid.hasMatch(v!.trim()) ? null : 'ULID inválido'),
              ),
              const SizedBox(height: AppSpacing.md),
              KeyedSubtree(
                key: const Key('wallet_limit'),
                child: AppMoneyField(
                  label: 'Limite diário (opcional)',
                  controller: _limit,
                ),
              ),
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

class TopUpValues {
  const TopUpValues(this.amountMinor, this.method, this.reference);
  final int amountMinor;
  final String method;
  final String? reference;
}

Future<TopUpValues?> showTopUpDialog(BuildContext context, Wallet wallet) =>
    showDialog<TopUpValues>(
      context: context,
      builder: (_) => _TopUpDialog(wallet),
    );

class _TopUpDialog extends StatefulWidget {
  const _TopUpDialog(this.wallet);
  final Wallet wallet;

  @override
  State<_TopUpDialog> createState() => _TopUpDialogState();
}

class _TopUpDialogState extends State<_TopUpDialog> {
  final _key = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  String _method = 'cash';

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    final amount = parseMinorUnits(_amount.text);
    if (amount == null || amount <= 0) return;
    Navigator.of(context).pop(
      TopUpValues(
        amount,
        _method,
        _reference.text.trim().isEmpty ? null : _reference.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Carregar carteira'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  '${widget.wallet.holderName} · saldo '
                  '${PtAoFormatters.currency(widget.wallet.balanceMinor)}',
                ),
              ),
              KeyedSubtree(
                key: const Key('topup_amount'),
                child: AppMoneyField(
                  label: 'Valor a carregar',
                  controller: _amount,
                  required: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                key: const Key('topup_method'),
                isExpanded: true,
                initialValue: _method,
                decoration: const InputDecoration(labelText: 'Método'),
                items: [
                  for (final e in walletMethodLabels.entries)
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
                ],
                onChanged: (m) => setState(() => _method = m ?? _method),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                key: const Key('topup_reference'),
                label: 'Referência (opcional)',
                controller: _reference,
              ),
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
      FilledButton(onPressed: _submit, child: const Text('Carregar')),
    ],
  );
}

/// Novo limite diário em cêntimos (`0` = sem limite); `null` se cancelado.
Future<int?> showDailyLimitDialog(BuildContext context, Wallet wallet) =>
    showDialog<int>(context: context, builder: (_) => _LimitDialog(wallet));

class _LimitDialog extends StatefulWidget {
  const _LimitDialog(this.wallet);
  final Wallet wallet;

  @override
  State<_LimitDialog> createState() => _LimitDialogState();
}

class _LimitDialogState extends State<_LimitDialog> {
  final _key = GlobalKey<FormState>();
  late final _limit = TextEditingController(
    text: widget.wallet.dailyLimitMinor == 0
        ? ''
        : '${widget.wallet.dailyLimitMinor ~/ 100}',
  );

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Limite diário'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(widget.wallet.holderName),
            ),
            KeyedSubtree(
              key: const Key('limit_amount'),
              child: AppMoneyField(
                label: 'Limite (vazio = sem limite)',
                controller: _limit,
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!_key.currentState!.validate()) return;
          Navigator.of(context).pop(parseMinorUnits(_limit.text) ?? 0);
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}

Future<void> showStatementDialog(BuildContext context, Wallet wallet) =>
    showDialog<void>(
      context: context,
      builder: (_) => _StatementDialog(wallet),
    );

class _StatementDialog extends ConsumerWidget {
  const _StatementDialog(this.wallet);
  final Wallet wallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(walletStatementProvider(wallet.id));
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text('Extracto · ${wallet.holderName}'),
      content: SizedBox(
        width: 520,
        height: 420,
        child: AsyncValueView<List<WalletTransaction>>(
          value: txs,
          onRetry: () => ref.invalidate(walletStatementProvider(wallet.id)),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Sem movimentos',
            message: 'Esta carteira ainda não tem movimentos.',
          ),
          data: (items) => ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final t = items[i];
              final negative = t.signedMinor < 0;
              return ListTile(
                dense: true,
                title: Text(walletTransactionLabel(t.type)),
                subtitle: Text(
                  '${PtAoFormatters.dateTime(t.occurredAt)}'
                  '${t.description == null ? '' : ' · ${t.description}'}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${negative ? '-' : '+'}'
                      '${PtAoFormatters.currency(t.amountMinor)}',
                      style: TextStyle(
                        color: negative ? scheme.error : scheme.primary,
                      ),
                    ),
                    Text(
                      PtAoFormatters.currency(t.balanceAfterMinor),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
