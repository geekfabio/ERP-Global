import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

enum ToastType { success, error, info }

/// Mensagem de toast. [id] distingue mensagens iguais em sequência.
class ToastMessage {
  const ToastMessage(this.id, this.type, this.text);

  final int id;
  final ToastType type;
  final String text;
}

/// Estado com o último toast; qualquer feature faz `ref.read(toastProvider.notifier).success(...)`.
class ToastNotifier extends Notifier<ToastMessage?> {
  int _seq = 0;

  @override
  ToastMessage? build() => null;

  void show(ToastType type, String text) =>
      state = ToastMessage(++_seq, type, text);

  void success(String text) => show(ToastType.success, text);
  void error(String text) => show(ToastType.error, text);
  void info(String text) => show(ToastType.info, text);
}

final toastProvider = NotifierProvider<ToastNotifier, ToastMessage?>(
  ToastNotifier.new,
);

/// Chave do `ScaffoldMessenger` raiz (passar a `MaterialApp.scaffoldMessengerKey`).
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Mostra os toasts do [toastProvider] como SnackBars. Colocar em `MaterialApp.builder`.
class ToastHost extends ConsumerWidget {
  const ToastHost({super.key, required this.child, this.messengerKey});

  final Widget child;
  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(toastProvider, (_, toast) {
      if (toast == null) return;
      final messenger = (messengerKey ?? rootMessengerKey).currentState;
      if (messenger == null) return;
      final colors = context.appColors;
      final (bg, fg, icon) = switch (toast.type) {
        ToastType.success => (
          colors.success,
          colors.onSuccess,
          Icons.check_circle_outline,
        ),
        ToastType.error => (
          colors.danger,
          colors.onDanger,
          Icons.error_outline,
        ),
        ToastType.info => (colors.info, colors.onInfo, Icons.info_outline),
      };
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: bg,
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: fg,
            content: Row(
              children: [
                Icon(icon, color: fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(toast.text, style: TextStyle(color: fg)),
                ),
              ],
            ),
          ),
        );
    });
    return child;
  }
}
