import '../data/models/billing_enums.dart';
import '../data/models/cash_session.dart';

/// Rótulos (pt-AO) dos tipos de movimento de caixa.
const cashMovementLabelsPt = <CashMovementType, String>{
  CashMovementType.cashPayment: 'Recebimento',
  CashMovementType.supply: 'Reforço',
  CashMovementType.withdrawal: 'Sangria',
};

/// Valor com sinal de um movimento: entradas positivas, sangrias negativas.
int signedMovementMinor(CashMovement m) =>
    m.type == CashMovementType.withdrawal ? -m.amountMinor : m.amountMinor;

/// Numerário esperado em caixa: abertura + entradas - sangrias.
int expectedCashMinor(int openingMinor, Iterable<CashMovement> movements) =>
    openingMinor + movements.fold<int>(0, (a, m) => a + signedMovementMinor(m));

/// Total de [type] nos [movements].
int totalOfType(Iterable<CashMovement> movements, CashMovementType type) =>
    movements
        .where((m) => m.type == type)
        .fold<int>(0, (a, m) => a + m.amountMinor);

/// Diferença de conferência: contado - esperado (negativo = falta).
int cashDifferenceMinor({
  required int countedMinor,
  required int expectedMinor,
}) => countedMinor - expectedMinor;
