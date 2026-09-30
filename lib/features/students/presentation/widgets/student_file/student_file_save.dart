import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/feedback/toasts.dart';
import '../../../data/models/student_model.dart';
import '../../providers/student_file_providers.dart';
import '../../providers/student_list_providers.dart';
import '../../providers/student_providers.dart';

/// Grava o aluno editado (PATCH), avisa o utilizador e refresca a ficha e a
/// listagem. Devolve `true` se gravou — serve de `onSave` do `EditableSection`.
Future<bool> saveStudent(WidgetRef ref, StudentModel updated) async {
  // Lidos antes do `await`: o separador pode ser desmontado entretanto.
  final repo = ref.read(studentRepositoryProvider);
  final toast = ref.read(toastProvider.notifier);
  final container = ref.container;
  final result = await repo.update(updated);
  return result.when(
    ok: (_) {
      toast.success('Alterações guardadas');
      container
        ..invalidate(studentProvider(updated.id))
        ..invalidate(studentListProvider);
      return true;
    },
    err: (f) {
      toast.error(f.message);
      return false;
    },
  );
}
