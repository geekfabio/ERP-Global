// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wallet _$WalletFromJson(Map<String, dynamic> json) => _Wallet(
  id: json['id'] as String,
  holderId: json['holderId'] as String,
  holderName: json['holderName'] as String,
  balanceMinor: (json['balanceMinor'] as num?)?.toInt() ?? 0,
  dailyLimitMinor: (json['dailyLimitMinor'] as num?)?.toInt() ?? 0,
  blocked: json['blocked'] as bool? ?? false,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$WalletToJson(_Wallet instance) => <String, dynamic>{
  'id': instance.id,
  'holderId': instance.holderId,
  'holderName': instance.holderName,
  'balanceMinor': instance.balanceMinor,
  'dailyLimitMinor': instance.dailyLimitMinor,
  'blocked': instance.blocked,
  'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
};

_WalletTransaction _$WalletTransactionFromJson(Map<String, dynamic> json) =>
    _WalletTransaction(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      type: $enumDecode(_$WalletTransactionTypeEnumMap, json['type']),
      amountMinor: (json['amountMinor'] as num).toInt(),
      balanceAfterMinor: (json['balanceAfterMinor'] as num).toInt(),
      occurredAt: const UtcDateTimeConverter().fromJson(
        json['occurredAt'] as String,
      ),
      method: json['method'] as String?,
      reference: json['reference'] as String?,
      description: json['description'] as String?,
      refundOfId: json['refundOfId'] as String?,
    );

Map<String, dynamic> _$WalletTransactionToJson(_WalletTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'walletId': instance.walletId,
      'type': _$WalletTransactionTypeEnumMap[instance.type]!,
      'amountMinor': instance.amountMinor,
      'balanceAfterMinor': instance.balanceAfterMinor,
      'occurredAt': const UtcDateTimeConverter().toJson(instance.occurredAt),
      'method': instance.method,
      'reference': instance.reference,
      'description': instance.description,
      'refundOfId': instance.refundOfId,
    };

const _$WalletTransactionTypeEnumMap = {
  WalletTransactionType.topup: 'topup',
  WalletTransactionType.purchase: 'purchase',
  WalletTransactionType.refund: 'refund',
};
