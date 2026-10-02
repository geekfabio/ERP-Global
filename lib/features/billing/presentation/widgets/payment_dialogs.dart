import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/charge.dart';
import '../../data/models/student_account.dart';
import '../../domain/payments.dart';
import '../providers/payment_providers.dart';

String shortId(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

/// Dados recolhidos para registar um pagamento (alocação automática).
class PaymentRequest {
  const PaymentRequest({
    required this.studentId,
    required this.method,
    required this.amountMinor,
  });

  final String studentId;
  final PaymentMethod method;
  final int amountMinor;
}

Future<PaymentRequest?> showRegisterPaymentDialog(BuildContext context) =>
    showDialog<PaymentRequest>(
      context: context,
      builder: (_) => const _RegisterDialog(),
    );

class _RegisterDialog extends ConsumerStatefulWidget {
  const _RegisterDialog();

  @override
  ConsumerState<_RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends ConsumerState<_RegisterDialog> {
  final _amount = TextEditingController();
  String? _studentId;
  PaymentMethod _method = PaymentMethod.cash;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit(StudentAccount? account) {
    final amount = parseMinorUnits(_amount.text) ?? 0;
    String? error;
    if (_studentId == null) {
      error = 'Seleccione o aluno';
    } else if (amount <= 0) {
      error = 'Indique um valor válido';
    } else if (_method == PaymentMethod.prepaidBalance) {
      if (account == null || amount > account.prepaidMinor) {
        error = 'Saldo pré-pago insuficiente';
      } else if (amount > account.outstandingMinor) {
        error = 'O saldo pré-pago só pode pagar cobranças em dívida';
      }
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(
      PaymentRequest(
        studentId: _studentId!,
        method: _method,
        amountMinor: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charges = ref.watch(openChargesProvider);
    final account = _studentId == null
        ? null
        : ref.watch(studentAccountProvider(_studentId!)).asData?.value;
    return AlertDialog(
      title: const Text('Registar pagamento'),
      content: SizedBox(
        width: 460,
        child: AsyncValueView<List<Charge>>(
          value: charges,
          onRetry: () => ref.invalidate(openChargesProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.payments_outlined,
            title: 'Sem cobranças em aberto',
          ),
          data: (list) {
            final students = {for (final c in list) c.studentId}.toList()
              ..sort();
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    key: const Key('field_student'),
                    initialValue: _studentId,
                    decoration: const InputDecoration(labelText: 'Aluno'),
                    items: [
                      for (final s in students)
                        DropdownMenuItem(
                          value: s,
                          child: Text('Aluno ${shortId(s)}'),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      _studentId = v;
                      _error = null;
                    }),
                  ),
                  if (account != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Em dívida: '
                      '${PtAoFormatters.currency(account.outstandingMinor)} · '
                      'Saldo pré-pago: '
                      '${PtAoFormatters.currency(account.prepaidMinor)}',
                      key: const Key('account_hint'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<PaymentMethod>(
                    key: const Key('field_method'),
                    initialValue: _method,
                    decoration: const InputDecoration(labelText: 'Método'),
                    items: [
                      for (final m in PaymentMethod.values)
                        DropdownMenuItem(
                          value: m,
                          child: Text(paymentMethodLabelsPt[m]!),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      _method = v!;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppMoneyField(
                    key: const Key('field_amount'),
                    controller: _amount,
                    required: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Distribuído pelas cobranças mais antigas; o excedente '
                    'fica como saldo pré-pago.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => _submit(account),
          child: const Text('Registar'),
        ),
      ],
    );
  }
}

/// Conta corrente do aluno: totais e lançamentos.
Future<void> showStudentAccountDialog(BuildContext context, String studentId) =>
    showDialog<void>(
      context: context,
      builder: (_) => _AccountDialog(studentId: studentId),
    );

class _AccountDialog extends ConsumerWidget {
  const _AccountDialog({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(studentAccountProvider(studentId));
    return AlertDialog(
      title: Text('Conta corrente · aluno ${shortId(studentId)}'),
      content: SizedBox(
        width: 560,
        child: AsyncValueView<StudentAccount>(
          value: account,
          onRetry: () => ref.invalidate(studentAccountProvider(studentId)),
          data: (a) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Saldo: ${PtAoFormatters.currency(a.balanceMinor)}',
                  key: const Key('account_balance'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Em dívida: ${PtAoFormatters.currency(a.outstandingMinor)} · '
                  'Pré-pago: ${PtAoFormatters.currency(a.prepaidMinor)}',
                ),
                const SizedBox(height: AppSpacing.md),
                if (a.entries.isEmpty)
                  const Text('Sem lançamentos')
                else
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final h in ['Data', 'Débito', 'Crédito'])
                            Text(
                              h,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                        ],
                      ),
                      for (final e in a.entries)
                        TableRow(
                          children: [
                            Text(
                              '${PtAoFormatters.date(e.occurredAt)} · '
                              '${e.kind == 'charge' ? 'Cobrança' : 'Pagamento'}',
                            ),
                            Text(
                              e.debitMinor == 0
                                  ? '-'
                                  : PtAoFormatters.currency(e.debitMinor),
                            ),
                            Text(
                              e.creditMinor == 0
                                  ? '-'
                                  : PtAoFormatters.currency(e.creditMinor),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
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
