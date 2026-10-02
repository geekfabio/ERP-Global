import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Termina a sessão (revoga o refresh token no servidor e limpa a sessão local).
///
/// Contrato do `core`: não conhece `features/auth`; `main` liga-o à sessão real
/// (ver `app/provider_overrides.dart`). Sem ligação, o menu do utilizador não
/// mostra "Terminar sessão" em vez de ficar um botão morto.
final sessionLogoutProvider = Provider<Future<void> Function()?>((ref) => null);

/// Utilizador da sessão tal como a topbar e as saudações o mostram.
class SessionUser {
  const SessionUser({required this.name, this.roleLabel});

  final String name;

  /// Nome do perfil activo (ex.: "Secretaria"); `null` se desconhecido.
  final String? roleLabel;

  /// Primeiro nome, para saudações ("Bom dia, Ana").
  String get firstName => name.trim().split(RegExp(r'\s+')).first;
}

/// Contrato do `core`; `main` liga-o à sessão de auth. `null` = sem sessão.
final sessionUserProvider = Provider<SessionUser?>((ref) => null);
