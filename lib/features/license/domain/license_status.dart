import '../data/models/license_model.dart';

enum LicenseState {
  /// Sem licença instalada.
  missing,

  /// Assinatura inválida ou documento adulterado.
  invalid,

  /// Dentro da validade.
  active,

  /// Expirada mas dentro do período de graça: aviso, tudo funciona.
  grace,

  /// Fora da graça: só leitura, nunca perda de dados.
  readOnly,

  /// Relógio do sistema recuado: tratado como só leitura até normalizar.
  clockTampered,
}

/// Estado calculado de uma licença num instante.
class LicenseStatus {
  const LicenseStatus(this.state, {this.daysLeft});

  final LicenseState state;

  /// Dias até expirar (`active`) ou até ao fim da graça (`grace`).
  final int? daysLeft;

  /// Consultas permitidas; `false` só em `missing`/`invalid`.
  bool get canRead =>
      state != LicenseState.missing && state != LicenseState.invalid;

  /// Escritas permitidas (novos registos, edições).
  bool get canWrite =>
      state == LicenseState.active || state == LicenseState.grace;

  bool get isReadOnly =>
      state == LicenseState.readOnly || state == LicenseState.clockTampered;
}

/// Tolerância para pequenas correcções de relógio/fuso antes de suspeitar de recuo.
const clockRollbackTolerance = Duration(hours: 24);

/// Calcula o estado da licença (assinatura já verificada) em [now].
/// [lastSeen] é o instante mais recente alguma vez observado (anti-recuo do relógio).
LicenseStatus evaluateLicense(
  LicenseModel license, {
  required DateTime now,
  DateTime? lastSeen,
}) {
  final utc = now.toUtc();
  if (lastSeen != null &&
      utc.isBefore(lastSeen.toUtc().subtract(clockRollbackTolerance))) {
    return const LicenseStatus(LicenseState.clockTampered);
  }
  // `expiresAt` é o último dia válido (inclusive).
  final validUntil = license.expiresAt.add(const Duration(days: 1));
  if (utc.isBefore(validUntil)) {
    return LicenseStatus(
      LicenseState.active,
      daysLeft: validUntil.difference(utc).inDays,
    );
  }
  final graceUntil = validUntil.add(Duration(days: license.graceDays));
  if (utc.isBefore(graceUntil)) {
    return LicenseStatus(
      LicenseState.grace,
      daysLeft: graceUntil.difference(utc).inDays,
    );
  }
  return const LicenseStatus(LicenseState.readOnly);
}
