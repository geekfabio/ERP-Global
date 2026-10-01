/// Regras de multa e juros por atraso (percentagens em pontos base).
class LateFeeRules {
  const LateFeeRules({
    this.graceDays = 5,
    this.lateFeeBp = 200,
    this.lateFeeFixedMinor = 0,
    this.lateInterestMonthlyBp = 100,
  });

  final int graceDays;

  /// Multa percentual única (200 = 2 %).
  final int lateFeeBp;

  /// Multa fixa única, na menor unidade.
  final int lateFeeFixedMinor;

  /// Juro por mês (ou fracção) de atraso (100 = 1 %).
  final int lateInterestMonthlyBp;
}

/// Número de prestações da propina por ano lectivo (Setembro a Junho).
const tuitionInstallments = 10;

/// Dia do mês de vencimento das prestações.
const tuitionDueDay = 5;

/// Ano civil em que começa o ano lectivo que contém [date] (arranca em Agosto).
int schoolYearStart(DateTime date) =>
    date.month >= 8 ? date.year : date.year - 1;

/// Vencimentos das [tuitionInstallments] prestações a partir de Setembro de
/// [startYear] (datas UTC só com dia).
List<DateTime> tuitionDueDates(int startYear) => [
  for (var i = 0; i < tuitionInstallments; i++)
    DateTime.utc(startYear, 9 + i, tuitionDueDay),
];

/// Multa + juros devidos por uma cobrança de [amountMinor] vencida em
/// [dueDate], avaliada em [asOf]. Zero dentro do prazo de tolerância. Toda a
/// aritmética é inteira (arredondamento para baixo).
int computeLateFee({
  required int amountMinor,
  required DateTime dueDate,
  required DateTime asOf,
  LateFeeRules rules = const LateFeeRules(),
}) {
  final daysLate = DateTime.utc(
    asOf.year,
    asOf.month,
    asOf.day,
  ).difference(DateTime.utc(dueDate.year, dueDate.month, dueDate.day)).inDays;
  if (amountMinor <= 0 || daysLate <= rules.graceDays) return 0;
  final months = (daysLate + 29) ~/ 30;
  final penalty =
      amountMinor * rules.lateFeeBp ~/ 10000 + rules.lateFeeFixedMinor;
  final interest = amountMinor * rules.lateInterestMonthlyBp * months ~/ 10000;
  return penalty + interest;
}
