import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'journal_models.freezed.dart';
part 'journal_models.g.dart';

/// `reversed` = estornado (existe um lançamento de estorno que o anula).
enum JournalEntryStatus { posted, reversed }

/// Origem do lançamento: manual, evento de billing ou conta a pagar/receber.
enum JournalSource { manual, billing, openItem }

enum OpenItemKind { payable, receivable }

enum OpenItemStatus { open, partiallyPaid, paid }

/// Eventos de billing que geram lançamentos automáticos.
enum BillingEventType {
  @JsonValue('charge.issued')
  chargeIssued,
  @JsonValue('payment.received')
  paymentReceived,
  @JsonValue('payment.reversed')
  paymentReversed,
}

/// Partida: exactamente um de [debitMinor]/[creditMinor] é positivo.
@freezed
abstract class JournalLineModel with _$JournalLineModel {
  const factory JournalLineModel({
    required String accountId,
    @Default(0) int debitMinor,
    @Default(0) int creditMinor,
    String? costCenterId,
    String? description,
  }) = _JournalLineModel;

  factory JournalLineModel.fromJson(Map<String, dynamic> json) =>
      _$JournalLineModelFromJson(json);
}

/// Lançamento com partidas dobradas (∑ débitos = ∑ créditos).
@freezed
abstract class JournalEntryModel with _$JournalEntryModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory JournalEntryModel({
    required String id,
    @Default(0) int number,
    @DateOnlyConverter() required DateTime date,
    required String description,
    required List<JournalLineModel> lines,
    @Default(JournalEntryStatus.posted) JournalEntryStatus status,
    @Default(JournalSource.manual) JournalSource source,

    /// Referência da origem (ex.: `payment.received:<id>`); idempotência.
    String? sourceRef,
    String? reversalOfId,
  }) = _JournalEntryModel;

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);
}

/// Linha do razão; [balanceMinor] = acumulado débito − crédito.
@freezed
abstract class LedgerLineModel with _$LedgerLineModel {
  const factory LedgerLineModel({
    required String entryId,
    required int number,
    @DateOnlyConverter() required DateTime date,
    required String description,
    @Default(0) int debitMinor,
    @Default(0) int creditMinor,
    required int balanceMinor,
  }) = _LedgerLineModel;

  factory LedgerLineModel.fromJson(Map<String, dynamic> json) =>
      _$LedgerLineModelFromJson(json);
}

/// Razão de uma conta (inclui as subcontas); saldos em débito − crédito.
@freezed
abstract class LedgerModel with _$LedgerModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory LedgerModel({
    required String accountId,
    required String code,
    required String name,
    required int openingMinor,
    required int debitMinor,
    required int creditMinor,
    required int closingMinor,
    required List<LedgerLineModel> lines,
  }) = _LedgerModel;

  factory LedgerModel.fromJson(Map<String, dynamic> json) =>
      _$LedgerModelFromJson(json);
}

/// Linha do balancete; saldos em débito − crédito.
@freezed
abstract class TrialBalanceRowModel with _$TrialBalanceRowModel {
  const factory TrialBalanceRowModel({
    required String accountId,
    required String code,
    required String name,
    required int openingMinor,
    required int debitMinor,
    required int creditMinor,
    required int closingMinor,
  }) = _TrialBalanceRowModel;

  factory TrialBalanceRowModel.fromJson(Map<String, dynamic> json) =>
      _$TrialBalanceRowModelFromJson(json);
}

@freezed
abstract class TrialBalanceModel with _$TrialBalanceModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory TrialBalanceModel({
    required List<TrialBalanceRowModel> rows,
    required int totalDebitMinor,
    required int totalCreditMinor,
  }) = _TrialBalanceModel;

  factory TrialBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$TrialBalanceModelFromJson(json);
}

/// Evento de billing a contabilizar (`POST /v1/journal-entries/billing-events`).
@freezed
abstract class BillingEventModel with _$BillingEventModel {
  const factory BillingEventModel({
    required BillingEventType event,
    required String referenceId,
    required int amountMinor,
    @DateOnlyConverter() required DateTime occurredOn,

    /// Meio de pagamento (`cash` → caixa; restantes → depósitos à ordem).
    String? method,
    String? description,
  }) = _BillingEventModel;

  factory BillingEventModel.fromJson(Map<String, dynamic> json) =>
      _$BillingEventModelFromJson(json);
}

/// Conta a pagar (fornecedor) ou a receber (encarregado).
@freezed
abstract class OpenItemModel with _$OpenItemModel {
  const factory OpenItemModel({
    required String id,
    required OpenItemKind kind,
    required String party,
    required String description,
    required int amountMinor,
    @Default(0) int paidMinor,
    @DateOnlyConverter() required DateTime issueDate,
    @DateOnlyConverter() required DateTime dueDate,
    @Default(OpenItemStatus.open) OpenItemStatus status,

    /// Contrapartida: despesa (a pagar) ou proveito (a receber).
    required String counterAccountId,
    String? entryId,
  }) = _OpenItemModel;

  factory OpenItemModel.fromJson(Map<String, dynamic> json) =>
      _$OpenItemModelFromJson(json);
}
