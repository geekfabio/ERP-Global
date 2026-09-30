import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audit/audit_providers.dart';
import '../../../../core/widgets/forms/stepper_form.dart';

/// Rascunho do cadastro de aluno, por utilizador: sobrevive a sair do ecrã e a
/// voltar (mesma sessão) e não passa para outro utilizador depois do logout.
/// Fica em memória — a persistência em disco chega com a base de dados local.
final studentWizardDraftStoreProvider = Provider<DraftStore>((ref) {
  ref.watch(auditActorProvider.select((a) => a?.id));
  return InMemoryDraftStore();
});
