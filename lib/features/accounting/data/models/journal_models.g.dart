// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalLineModel _$JournalLineModelFromJson(Map<String, dynamic> json) =>
    _JournalLineModel(
      accountId: json['accountId'] as String,
      debitMinor: (json['debitMinor'] as num?)?.toInt() ?? 0,
      creditMinor: (json['creditMinor'] as num?)?.toInt() ?? 0,
      costCenterId: json['costCenterId'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$JournalLineModelToJson(_JournalLineModel instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'debitMinor': instance.debitMinor,
      'creditMinor': instance.creditMinor,
      'costCenterId': instance.costCenterId,
      'description': instance.description,
    };

_JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) =>
    _JournalEntryModel(
      id: json['id'] as String,
      number: (json['number'] as num?)?.toInt() ?? 0,
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      description: json['description'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => JournalLineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status:
          $enumDecodeNullable(_$JournalEntryStatusEnumMap, json['status']) ??
          JournalEntryStatus.posted,
      source:
          $enumDecodeNullable(_$JournalSourceEnumMap, json['source']) ??
          JournalSource.manual,
      sourceRef: json['sourceRef'] as String?,
      reversalOfId: json['reversalOfId'] as String?,
    );

Map<String, dynamic> _$JournalEntryModelToJson(_JournalEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'date': const DateOnlyConverter().toJson(instance.date),
      'description': instance.description,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'status': _$JournalEntryStatusEnumMap[instance.status]!,
      'source': _$JournalSourceEnumMap[instance.source]!,
      'sourceRef': instance.sourceRef,
      'reversalOfId': instance.reversalOfId,
    };

const _$JournalEntryStatusEnumMap = {
  JournalEntryStatus.posted: 'posted',
  JournalEntryStatus.reversed: 'reversed',
};

const _$JournalSourceEnumMap = {
  JournalSource.manual: 'manual',
  JournalSource.billing: 'billing',
  JournalSource.openItem: 'openItem',
};

_LedgerLineModel _$LedgerLineModelFromJson(Map<String, dynamic> json) =>
    _LedgerLineModel(
      entryId: json['entryId'] as String,
      number: (json['number'] as num).toInt(),
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      description: json['description'] as String,
      debitMinor: (json['debitMinor'] as num?)?.toInt() ?? 0,
      creditMinor: (json['creditMinor'] as num?)?.toInt() ?? 0,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
    );

Map<String, dynamic> _$LedgerLineModelToJson(_LedgerLineModel instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'number': instance.number,
      'date': const DateOnlyConverter().toJson(instance.date),
      'description': instance.description,
      'debitMinor': instance.debitMinor,
      'creditMinor': instance.creditMinor,
      'balanceMinor': instance.balanceMinor,
    };

_LedgerModel _$LedgerModelFromJson(Map<String, dynamic> json) => _LedgerModel(
  accountId: json['accountId'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  openingMinor: (json['openingMinor'] as num).toInt(),
  debitMinor: (json['debitMinor'] as num).toInt(),
  creditMinor: (json['creditMinor'] as num).toInt(),
  closingMinor: (json['closingMinor'] as num).toInt(),
  lines: (json['lines'] as List<dynamic>)
      .map((e) => LedgerLineModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LedgerModelToJson(_LedgerModel instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'code': instance.code,
      'name': instance.name,
      'openingMinor': instance.openingMinor,
      'debitMinor': instance.debitMinor,
      'creditMinor': instance.creditMinor,
      'closingMinor': instance.closingMinor,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
    };

_TrialBalanceRowModel _$TrialBalanceRowModelFromJson(
  Map<String, dynamic> json,
) => _TrialBalanceRowModel(
  accountId: json['accountId'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  openingMinor: (json['openingMinor'] as num).toInt(),
  debitMinor: (json['debitMinor'] as num).toInt(),
  creditMinor: (json['creditMinor'] as num).toInt(),
  closingMinor: (json['closingMinor'] as num).toInt(),
);

Map<String, dynamic> _$TrialBalanceRowModelToJson(
  _TrialBalanceRowModel instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'code': instance.code,
  'name': instance.name,
  'openingMinor': instance.openingMinor,
  'debitMinor': instance.debitMinor,
  'creditMinor': instance.creditMinor,
  'closingMinor': instance.closingMinor,
};

_TrialBalanceModel _$TrialBalanceModelFromJson(Map<String, dynamic> json) =>
    _TrialBalanceModel(
      rows: (json['rows'] as List<dynamic>)
          .map((e) => TrialBalanceRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDebitMinor: (json['totalDebitMinor'] as num).toInt(),
      totalCreditMinor: (json['totalCreditMinor'] as num).toInt(),
    );

Map<String, dynamic> _$TrialBalanceModelToJson(_TrialBalanceModel instance) =>
    <String, dynamic>{
      'rows': instance.rows.map((e) => e.toJson()).toList(),
      'totalDebitMinor': instance.totalDebitMinor,
      'totalCreditMinor': instance.totalCreditMinor,
    };

_BillingEventModel _$BillingEventModelFromJson(Map<String, dynamic> json) =>
    _BillingEventModel(
      event: $enumDecode(_$BillingEventTypeEnumMap, json['event']),
      referenceId: json['referenceId'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      occurredOn: const DateOnlyConverter().fromJson(
        json['occurredOn'] as String,
      ),
      method: json['method'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BillingEventModelToJson(_BillingEventModel instance) =>
    <String, dynamic>{
      'event': _$BillingEventTypeEnumMap[instance.event]!,
      'referenceId': instance.referenceId,
      'amountMinor': instance.amountMinor,
      'occurredOn': const DateOnlyConverter().toJson(instance.occurredOn),
      'method': instance.method,
      'description': instance.description,
    };

const _$BillingEventTypeEnumMap = {
  BillingEventType.chargeIssued: 'charge.issued',
  BillingEventType.paymentReceived: 'payment.received',
  BillingEventType.paymentReversed: 'payment.reversed',
};

_OpenItemModel _$OpenItemModelFromJson(Map<String, dynamic> json) =>
    _OpenItemModel(
      id: json['id'] as String,
      kind: $enumDecode(_$OpenItemKindEnumMap, json['kind']),
      party: json['party'] as String,
      description: json['description'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      paidMinor: (json['paidMinor'] as num?)?.toInt() ?? 0,
      issueDate: const DateOnlyConverter().fromJson(
        json['issueDate'] as String,
      ),
      dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
      status:
          $enumDecodeNullable(_$OpenItemStatusEnumMap, json['status']) ??
          OpenItemStatus.open,
      counterAccountId: json['counterAccountId'] as String,
      entryId: json['entryId'] as String?,
    );

Map<String, dynamic> _$OpenItemModelToJson(_OpenItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$OpenItemKindEnumMap[instance.kind]!,
      'party': instance.party,
      'description': instance.description,
      'amountMinor': instance.amountMinor,
      'paidMinor': instance.paidMinor,
      'issueDate': const DateOnlyConverter().toJson(instance.issueDate),
      'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
      'status': _$OpenItemStatusEnumMap[instance.status]!,
      'counterAccountId': instance.counterAccountId,
      'entryId': instance.entryId,
    };

const _$OpenItemKindEnumMap = {
  OpenItemKind.payable: 'payable',
  OpenItemKind.receivable: 'receivable',
};

const _$OpenItemStatusEnumMap = {
  OpenItemStatus.open: 'open',
  OpenItemStatus.partiallyPaid: 'partiallyPaid',
  OpenItemStatus.paid: 'paid',
};
