import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum FeeType {
  enrollment,
  tuition,
  uniform,
  material,
  exam,
  transport,
  cafeteria,
  other,
}

enum FeeItemStatus { active, inactive }

@JsonEnum(fieldRename: FieldRename.snake)
enum ChargeStatus { pending, partiallyPaid, paid, overdue, cancelled }

enum InvoiceStatus { draft, issued, cancelled }

enum ReceiptStatus { issued, cancelled }

enum PaymentStatus { pending, completed, failed, reversed }

@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  paymentReference,
  prepaidBalance,
}

/// Estado do registo do caixa; abertura/fecho pertencem à sessão de caixa.
enum CashRegisterStatus { active, inactive }

enum CashSessionStatus { open, closed }

/// Tipo de movimento de caixa: recebimento em numerário (vindo de um
/// pagamento), reforço (entrada) ou sangria (saída).
@JsonEnum(fieldRename: FieldRename.snake)
enum CashMovementType { cashPayment, supply, withdrawal }

/// Aviso de cobrança: lembrete antes do vencimento ou aviso de atraso.
@JsonEnum(fieldRename: FieldRename.snake)
enum NoticeKind { preDue, postDue }

/// Estado de um acordo de pagamento (calculado a partir dos pagamentos).
@JsonEnum(fieldRename: FieldRename.snake)
enum AgreementStatus { active, completed, broken, cancelled }

/// Tipo de desconto: percentagem (pontos base) ou valor fixo por cobrança.
@JsonEnum(fieldRename: FieldRename.snake)
enum DiscountKind { percentage, fixed }

/// Motivo do desconto ou bolsa.
@JsonEnum(fieldRename: FieldRename.snake)
enum DiscountReason { sibling, merit, scholarship, other }

/// Estado do desconto: só os aprovados se reflectem na cobrança.
@JsonEnum(fieldRename: FieldRename.snake)
enum DiscountStatus { pending, approved, rejected, revoked }
