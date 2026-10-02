import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Flag "reduzir movimento" das definições da app.
class ReduceMotionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final reduceMotionProvider = NotifierProvider<ReduceMotionNotifier, bool>(
  ReduceMotionNotifier.new,
);

/// `true` quando o movimento deve ser suprimido: flag da app ou preferência
/// do sistema (`MediaQuery.disableAnimations`).
bool shouldReduceMotion(BuildContext context, {bool appFlag = false}) =>
    appFlag || MediaQuery.maybeDisableAnimationsOf(context) == true;
