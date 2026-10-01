import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';

/// Toast de sucesso ([done]) ou do erro do [Failure]; devolve `true` se correu bem.
bool reportResult<T>(WidgetRef ref, Result<T> result, {required String done}) {
  final toast = ref.read(toastProvider.notifier);
  return result.when(
    ok: (_) {
      toast.success(done);
      return true;
    },
    err: (f) {
      toast.error(f.message);
      return false;
    },
  );
}
