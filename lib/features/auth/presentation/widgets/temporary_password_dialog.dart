import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';

/// Mostra a password temporária (só aparece uma vez) com botão de copiar.
Future<void> showTemporaryPasswordDialog(
  BuildContext context, {
  required String userName,
  required String password,
}) => showAppDialog<void>(
  context: context,
  title: 'Palavra-passe temporária',
  barrierDismissible: false,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Entregue esta palavra-passe a $userName. Só é mostrada agora e tem de '
        'ser alterada no primeiro início de sessão.',
      ),
      const SizedBox(height: AppSpacing.md),
      SelectableText(
        password,
        key: const Key('temporary_password'),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  ),
  actions: [
    TextButton(
      onPressed: () => Clipboard.setData(ClipboardData(text: password)),
      child: const Text('Copiar'),
    ),
    FilledButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Fechar'),
    ),
  ],
);
