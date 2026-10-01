import '../data/models/journal_models.dart';

/// Regras das partidas dobradas, partilhadas pela UI e pelo mock da API.
class JournalRules {
  const JournalRules._();

  static int totalDebit(Iterable<JournalLineModel> lines) =>
      lines.fold(0, (s, l) => s + l.debitMinor);

  static int totalCredit(Iterable<JournalLineModel> lines) =>
      lines.fold(0, (s, l) => s + l.creditMinor);

  static bool isBalanced(Iterable<JournalLineModel> lines) {
    final debit = totalDebit(lines);
    return debit > 0 && debit == totalCredit(lines);
  }

  /// Erros por campo (`lines`); vazio se o lançamento é válido.
  static Map<String, String> validate(List<JournalLineModel> lines) {
    if (lines.length < 2) {
      return {'lines': 'Um lançamento tem no mínimo duas linhas'};
    }
    for (final l in lines) {
      final valid =
          l.debitMinor >= 0 &&
          l.creditMinor >= 0 &&
          (l.debitMinor > 0) != (l.creditMinor > 0);
      if (!valid) {
        return {'lines': 'Cada linha tem um valor a débito ou a crédito'};
      }
    }
    if (!isBalanced(lines)) {
      return {'lines': 'O total a débito tem de ser igual ao total a crédito'};
    }
    return const {};
  }

  /// Converte `1500,50` / `1500.5` em unidades menores (centavos); `null` se inválido.
  static int? parseMinor(String text) {
    final m = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$').firstMatch(text.trim());
    if (m == null) return null;
    return int.parse(m[1]!) * 100 + int.parse((m[2] ?? '').padRight(2, '0'));
  }
}
