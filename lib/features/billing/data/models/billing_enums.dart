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
