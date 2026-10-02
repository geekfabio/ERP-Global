import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Termina a sessão (revoga o refresh token no servidor e limpa a sessão local).
///
/// Contrato do `core`: não conhece `features/auth`; `main` liga-o à sessão real
/// (ver `app/provider_overrides.dart`). Sem ligação, o menu do utilizador não
/// mostra "Terminar sessão" em vez de ficar um botão morto.
final sessionLogoutProvider = Provider<Future<void> Function()?>((ref) => null);
