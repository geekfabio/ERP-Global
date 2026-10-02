import '../../../students/data/models/student_summaries_model.dart';

DateTime _utc(Object? raw) => DateTime.parse(raw! as String).toUtc();

/// Recibo emitido ao encarregado (leitura). Dinheiro em `int` (menor unidade).
class PortalReceipt {
  const PortalReceipt({
    required this.id,
    required this.number,
    required this.description,
    required this.issuedAt,
    required this.amountMinor,
  });

  factory PortalReceipt.fromJson(Map<String, dynamic> json) => PortalReceipt(
    id: json['id'] as String,
    number: json['number'] as String,
    description: json['description'] as String,
    issuedAt: _utc(json['issuedAt']),
    amountMinor: json['amountMinor'] as int,
  );

  final String id;
  final String number;
  final String description;
  final DateTime issuedAt;
  final int amountMinor;

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'description': description,
    'issuedAt': issuedAt.toIso8601String(),
    'amountMinor': amountMinor,
  };
}

/// Conta corrente do educando: cobranças e recibos.
class PortalFinance {
  const PortalFinance({this.charges = const [], this.receipts = const []});

  factory PortalFinance.fromJson(Map<String, dynamic> json) => PortalFinance(
    charges: [
      for (final c in json['charges'] as List)
        StudentChargeLine.fromJson(c as Map<String, dynamic>),
    ],
    receipts: [
      for (final r in json['receipts'] as List)
        PortalReceipt.fromJson(r as Map<String, dynamic>),
    ],
  );

  final List<StudentChargeLine> charges;
  final List<PortalReceipt> receipts;
}

/// Referência de pagamento (simulada) para pagar em multicaixa/banco.
class PortalPaymentReference {
  const PortalPaymentReference({
    required this.entity,
    required this.reference,
    required this.amountMinor,
    required this.validUntil,
  });

  factory PortalPaymentReference.fromJson(Map<String, dynamic> json) =>
      PortalPaymentReference(
        entity: json['entity'] as String,
        reference: json['reference'] as String,
        amountMinor: json['amountMinor'] as int,
        validUntil: _utc(json['validUntil']),
      );

  final String entity;
  final String reference;
  final int amountMinor;
  final DateTime validUntil;
}

enum PortalCardEntryKind { topup, purchase, refund }

/// Movimento do extracto do cartão/carteira do refeitório.
class PortalCardEntry {
  const PortalCardEntry({
    required this.id,
    required this.kind,
    required this.at,
    required this.amountMinor,
    required this.balanceAfterMinor,
    this.description,
  });

  factory PortalCardEntry.fromJson(Map<String, dynamic> json) =>
      PortalCardEntry(
        id: json['id'] as String,
        kind: PortalCardEntryKind.values.byName(json['kind'] as String),
        at: _utc(json['at']),
        amountMinor: json['amountMinor'] as int,
        balanceAfterMinor: json['balanceAfterMinor'] as int,
        description: json['description'] as String?,
      );

  final String id;
  final PortalCardEntryKind kind;
  final DateTime at;

  /// Sempre positivo; o sinal vem do [kind].
  final int amountMinor;
  final int balanceAfterMinor;
  final String? description;

  /// Efeito no saldo: carregamentos e estornos somam, consumos subtraem.
  int get signedMinor =>
      kind == PortalCardEntryKind.purchase ? -amountMinor : amountMinor;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'at': at.toIso8601String(),
    'amountMinor': amountMinor,
    'balanceAfterMinor': balanceAfterMinor,
    'description': description,
  };
}

/// Cartão do educando: saldo, extracto e entradas/saídas.
class PortalCard {
  const PortalCard({
    this.cardNumber,
    this.status,
    this.balanceMinor = 0,
    this.entries = const [],
    this.access = const [],
  });

  factory PortalCard.fromJson(Map<String, dynamic> json) => PortalCard(
    cardNumber: json['cardNumber'] as String?,
    status: json['status'] == null
        ? null
        : StudentCardStatus.values.byName(json['status'] as String),
    balanceMinor: json['balanceMinor'] as int,
    entries: [
      for (final e in json['entries'] as List)
        PortalCardEntry.fromJson(e as Map<String, dynamic>),
    ],
    access: [
      for (final a in json['access'] as List)
        AccessEvent.fromJson(a as Map<String, dynamic>),
    ],
  );

  final String? cardNumber;
  final StudentCardStatus? status;
  final int balanceMinor;
  final List<PortalCardEntry> entries;
  final List<AccessEvent> access;
}
