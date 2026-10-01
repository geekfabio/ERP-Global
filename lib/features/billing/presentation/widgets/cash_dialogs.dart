import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/cash_register.dart';
import '../../data/models/cash_session.dart';
import '../../domain/cash.dart';
import '../providers/cash_providers.dart';

String cashShortId(String id) =>
    id.length <= 8 ? id : id.substring(id.length - 8);

/// Abertura de caixa: caixa e fundo de abertura.
class OpenCashRequest {
  const OpenCashRequest({
    required this.cashRegisterId,
    required this.openingMinor,
  });

  final String cashRegisterId;
  final int openingMinor;
}

Future<OpenCashRequest?> showOpenCashDialog(
  BuildContext context,
  List<CashRegister> registers,
) => showDialog<OpenCashRequest>(
  context: context,
  builder: (_) => _OpenCashDialog(registers: registers),
);

class _OpenCashDialog extends StatefulWidget {
  const _OpenCashDialog({required this.registers});

  final List<CashRegister> registers;

  @override
  State<_OpenCashDialog> createState() => _OpenCashDialogState();
}

class _OpenCashDialogState extends State<_OpenCashDialog> {
  final _amount = TextEditingController(text: '0');
  late String? _register = widget.registers.firstOrNull?.id;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = parseMinorUnits(_amount.text);
    if (_register == null) {
      setState(() => _error = 'Seleccione o caixa');
    } else if (amount == null || amount < 0) {
      setState(() => _error = 'Indique um fundo de abertura válido');
    } else {
      Navigator.of(
        context,
      ).pop(OpenCashRequest(cashRegisterId: _register!, openingMinor: amount));
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Abrir caixa'),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            key: const Key('field_register'),
            initialValue: _register,
            decoration: const InputDecoration(labelText: 'Caixa'),
            items: [
              for (final r in widget.registers)
                DropdownMenuItem(value: r.id, child: Text(r.name)),
            ],
            onChanged: (v) => setState(() {
              _register = v;
              _error = null;
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          AppMoneyField(
            key: const Key('field_opening'),
            controller: _amount,
            label: 'Fundo de abertura',
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Abrir')),
    ],
  );
}

/// Valor e descrição de uma sangria ou reforço.
class MovementRequest {
  const MovementRequest({required this.amountMinor, this.description});

  final int amountMinor;
  final String? description;
}

Future<MovementRequest?> showMovementDialog(
  BuildContext context,
  CashMovementType type,
) => showDialog<MovementRequest>(
  context: context,
  builder: (_) => _MovementDialog(type: type),
);

class _MovementDialog extends StatefulWidget {
  const _MovementDialog({required this.type});

  final CashMovementType type;

  @override
  State<_MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<_MovementDialog> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = parseMinorUnits(_amount.text) ?? 0;
    if (amount <= 0) {
      setState(() => _error = 'Indique um valor válido');
      return;
    }
    final text = _description.text.trim();
    Navigator.of(context).pop(
      MovementRequest(
        amountMinor: amount,
        description: text.isEmpty ? null : text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(cashMovementLabelsPt[widget.type]!),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppMoneyField(
            key: const Key('field_amount'),
            controller: _amount,
            required: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('field_description'),
            controller: _description,
            label: 'Descrição',
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Registar')),
    ],
  );
}

/// Valor contado e justificação no fecho de caixa.
class CloseRequest {
  const CloseRequest({required this.countedMinor, this.notes});

  final int countedMinor;
  final String? notes;
}

Future<CloseRequest?> showCloseCashDialog(
  BuildContext context,
  int expectedMinor,
) => showDialog<CloseRequest>(
  context: context,
  builder: (_) => _CloseDialog(expectedMinor: expectedMinor),
);

class _CloseDialog extends StatefulWidget {
  const _CloseDialog({required this.expectedMinor});

  final int expectedMinor;

  @override
  State<_CloseDialog> createState() => _CloseDialogState();
}

class _CloseDialogState extends State<_CloseDialog> {
  final _counted = TextEditingController();
  final _notes = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _counted.dispose();
    _notes.dispose();
    super.dispose();
  }

  int? get _countedMinor => parseMinorUnits(_counted.text);

  void _submit() {
    final counted = _countedMinor;
    if (counted == null || counted < 0) {
      setState(() => _error = 'Indique o valor contado');
      return;
    }
    final notes = _notes.text.trim();
    final diff = cashDifferenceMinor(
      countedMinor: counted,
      expectedMinor: widget.expectedMinor,
    );
    if (diff != 0 && notes.isEmpty) {
      setState(() => _error = 'Justifique a diferença de conferência');
      return;
    }
    Navigator.of(context).pop(
      CloseRequest(countedMinor: counted, notes: notes.isEmpty ? null : notes),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counted = _countedMinor;
    final diff = counted == null
        ? null
        : cashDifferenceMinor(
            countedMinor: counted,
            expectedMinor: widget.expectedMinor,
          );
    return AlertDialog(
      title: const Text('Fechar caixa'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Esperado em caixa: '
              '${PtAoFormatters.currency(widget.expectedMinor)}',
              key: const Key('close_expected'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppMoneyField(
              key: const Key('field_counted'),
              controller: _counted,
              label: 'Valor contado',
              onChanged: (_) => setState(() => _error = null),
            ),
            if (diff != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Diferença: ${PtAoFormatters.currency(diff)}',
                key: const Key('close_difference'),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              key: const Key('field_notes'),
              controller: _notes,
              label: 'Justificação da diferença',
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Fechar caixa')),
      ],
    );
  }
}

/// Detalhe de uma sessão: totais, movimentos e acções (sangria, reforço, fecho).
Future<void> showCashSessionDialog(BuildContext context, CashSession session) =>
    showDialog<void>(
      context: context,
      builder: (_) => _SessionDialog(session: session),
    );

class _SessionDialog extends ConsumerStatefulWidget {
  const _SessionDialog({required this.session});

  final CashSession session;

  @override
  ConsumerState<_SessionDialog> createState() => _SessionDialogState();
}

class _SessionDialogState extends ConsumerState<_SessionDialog> {
  late CashSession _session = widget.session;

  bool get _isOpen => _session.status == CashSessionStatus.open;

  Future<void> _movement(CashMovementType type) async {
    final req = await showMovementDialog(context, type);
    if (req == null) return;
    final result = await ref
        .read(cashRepositoryProvider)
        .addMovement(
          sessionId: _session.id,
          type: type,
          amountMinor: req.amountMinor,
          description: req.description,
        );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success('${cashMovementLabelsPt[type]} registado'),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) ref.invalidate(cashMovementsProvider(_session.id));
  }

  Future<void> _close(List<CashMovement> movements) async {
    final req = await showCloseCashDialog(
      context,
      expectedCashMinor(_session.openingMinor, movements),
    );
    if (req == null) return;
    final result = await ref
        .read(cashRepositoryProvider)
        .close(
          sessionId: _session.id,
          countedMinor: req.countedMinor,
          notes: req.notes,
        );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (s) {
        toast.success('Caixa fechado');
        setState(() => _session = s);
      },
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) ref.invalidate(cashSessionsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final movements = ref.watch(cashMovementsProvider(_session.id));
    final canWrite = ref
        .watch(permissionServiceProvider)
        .canAny(cashWritePermission);
    return AlertDialog(
      title: Text('Sessão de caixa · ${cashShortId(_session.id)}'),
      content: SizedBox(
        width: 620,
        child: AsyncValueView<List<CashMovement>>(
          value: movements,
          onRetry: () => ref.invalidate(cashMovementsProvider(_session.id)),
          data: (list) {
            final expected =
                _session.expectedMinor ??
                expectedCashMinor(_session.openingMinor, list);
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Aberta em ${PtAoFormatters.dateTime(_session.openedAt)} · '
                    'Fundo ${PtAoFormatters.currency(_session.openingMinor)}',
                  ),
                  Text(
                    'Esperado em caixa: ${PtAoFormatters.currency(expected)}',
                    key: const Key('session_expected'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (!_isOpen)
                    Text(
                      'Contado: '
                      '${PtAoFormatters.currency(_session.countedMinor ?? 0)} · '
                      'Diferença: '
                      '${PtAoFormatters.currency(_session.differenceMinor ?? 0)}',
                      key: const Key('session_closing'),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  if (list.isEmpty)
                    const Text('Sem movimentos')
                  else
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            for (final h in [
                              'Hora',
                              'Tipo',
                              'Descrição',
                              'Valor',
                            ])
                              Text(
                                h,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                          ],
                        ),
                        for (final m in list)
                          TableRow(
                            children: [
                              Text(PtAoFormatters.dateTime(m.occurredAt)),
                              Text(cashMovementLabelsPt[m.type]!),
                              Text(m.description ?? '-'),
                              Text(
                                PtAoFormatters.currency(signedMovementMinor(m)),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        if (_isOpen && canWrite) ...[
          TextButton(
            onPressed: () => _movement(CashMovementType.supply),
            child: const Text('Reforço'),
          ),
          TextButton(
            onPressed: () => _movement(CashMovementType.withdrawal),
            child: const Text('Sangria'),
          ),
          FilledButton(
            onPressed: () => _close(movements.asData?.value ?? const []),
            child: const Text('Fechar caixa'),
          ),
        ],
        if (!_isOpen)
          TextButton(
            onPressed: () =>
                ref.read(cashReportPdfServiceProvider).exportClosing(_session),
            child: const Text('Relatório em PDF'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar janela'),
        ),
      ],
    );
  }
}
