import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

/// Tipo de movimento da carteira.
enum WalletTransactionType { topup, purchase, refund }

/// Carteira pré-paga do refeitório (um titular de cartão, ver `cards`).
/// Dinheiro sempre em `int` (menor unidade). O saldo nunca fica negativo.
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String holderId,
    required String holderName,
    @Default(0) int balanceMinor,

    /// Limite de consumo por dia (UTC); `0` = sem limite.
    @Default(0) int dailyLimitMinor,
    @Default(false) bool blocked,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

/// Movimento (imutável): `amountMinor` é sempre positivo; o sinal vem do tipo.
@freezed
abstract class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    required String walletId,
    required WalletTransactionType type,
    required int amountMinor,

    /// Saldo da carteira depois deste movimento.
    required int balanceAfterMinor,
    @UtcDateTimeConverter() required DateTime occurredAt,

    /// Carregamento: método de pagamento (contrato com billing).
    String? method,

    /// Carregamento: referência do pagamento/recibo no billing.
    String? reference,

    /// Consumo: descrição (ex.: prato). Estorno: motivo.
    String? description,

    /// Estorno: movimento de consumo estornado.
    String? refundOfId,

    /// Consumo: tipo de refeição servida (relatórios de consumo).
    String? mealTypeId,

    /// Consumo: turma do aluno no momento da compra (relatórios de consumo).
    String? className,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}

extension WalletTransactionX on WalletTransaction {
  /// Efeito no saldo: carregamentos e estornos somam, consumos subtraem.
  int get signedMinor =>
      type == WalletTransactionType.purchase ? -amountMinor : amountMinor;
}
