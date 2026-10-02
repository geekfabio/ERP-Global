import 'package:flutter/material.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/permissions/can.dart';

/// Bloco de um separador com modo de leitura e de edição (padrão da ficha).
///
/// - Leitura: [view]; o botão "Editar" só aparece com [editPermission] (e some
///   com a licença em só leitura, porque o `Can` já o trata).
/// - Edição: [form] dentro de um `Form`; "Guardar" valida, faz `save()` dos
///   campos (`onSaved`) e chama [onSave]. [onSave] devolve `true` se gravou
///   (volta à leitura) ou `false` (fica a editar; quem chama mostra o erro).
/// - [onCancel] deixa o separador descartar o rascunho.
class EditableSection extends StatefulWidget {
  const EditableSection({
    super.key,
    required this.title,
    required this.editPermission,
    required this.view,
    required this.form,
    required this.onSave,
    this.onCancel,
  });

  final String title;
  final String editPermission;
  final WidgetBuilder view;
  final WidgetBuilder form;
  final Future<bool> Function() onSave;
  final VoidCallback? onCancel;

  @override
  State<EditableSection> createState() => _EditableSectionState();
}

class _EditableSectionState extends State<EditableSection> {
  final _formKey = GlobalKey<FormState>();
  bool _editing = false;
  bool _saving = false;

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    setState(() => _saving = true);
    final ok = await widget.onSave();
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (ok) _editing = false;
    });
  }

  void _cancel() {
    widget.onCancel?.call();
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.title, style: text.titleMedium)),
                if (!_editing)
                  Can(
                    permission: widget.editPermission,
                    child: AppButton(
                      label: 'Editar',
                      icon: Icons.edit_outlined,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => setState(() => _editing = true),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_editing) ...[
              Form(key: _formKey, child: widget.form(context)),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.sm,
                children: [
                  AppButton(
                    label: 'Cancelar',
                    variant: AppButtonVariant.text,
                    onPressed: _saving ? null : _cancel,
                  ),
                  AppButton(
                    label: 'Guardar',
                    icon: Icons.save_outlined,
                    loading: _saving,
                    onPressed: _save,
                  ),
                ],
              ),
            ] else
              widget.view(context),
          ],
        ),
      ),
    );
  }
}

/// Linha "rótulo: valor" do modo de leitura (valor vazio → "—").
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final shown = value == null || value!.trim().isEmpty ? '—' : value!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: text.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 560),
            child: Text(shown, style: text.bodyLarge),
          ),
        ],
      ),
    );
  }
}

/// Grelha responsiva de campos do modo de edição: 1 coluna em ecrãs estreitos,
/// 2 a partir de [AppBreakpoints.medium] (segue o espaço disponível).
class FormGrid extends StatelessWidget {
  const FormGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final twoCols = c.maxWidth >= AppBreakpoints.medium;
      final width = twoCols ? (c.maxWidth - AppSpacing.md) / 2 : c.maxWidth;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [for (final w in children) SizedBox(width: width, child: w)],
      );
    },
  );
}
