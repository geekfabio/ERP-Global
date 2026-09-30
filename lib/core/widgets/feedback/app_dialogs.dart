import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';

/// Diálogo modal. Fecha com Esc/toque fora; o foco é gerido pela rota do diálogo.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget> actions = const [],
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  builder: (context) => AlertDialog(
    title: Text(title),
    content: SingleChildScrollView(child: content),
    actions: actions,
  ),
);

/// Confirmação. `destructive` usa botão de perigo e dá o foco inicial a "Cancelar"
/// (Enter nunca apaga por engano). Devolve `true` só se confirmado.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          autofocus: destructive,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          autofocus: !destructive,
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.appColors.danger,
                  foregroundColor: context.appColors.onDanger,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Bottom-sheet modal com pega e altura ajustável ao conteúdo.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Flexible(child: SingleChildScrollView(child: child)),
      ],
    ),
  ),
);
