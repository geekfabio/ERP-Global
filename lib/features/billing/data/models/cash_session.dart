import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'cash_session.freezed.dart';
part 'cash_session.g.dart';

/// Sessão de caixa de um operador (abertura até fecho). Depois de fechada é
/// imutável; o fecho guarda o esperado, o contado e a diferença.
@freezed
abstract class CashSession with _$CashSession {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CashSession({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String cashRegisterId,
    required String operatorId,
    @UtcDateTimeConverter() required DateTime openedAt,
    @MinorUnitConverter() required int openingMinor,
    @Default(CashSessionStatus.open) CashSessionStatus status,
    @UtcDateTimeConverter() DateTime? closedAt,
    int? expectedMinor,
    int? countedMinor,
    int? differenceMinor,
    String? closingNotes,
  }) = _CashSession;

  factory CashSession.fromJson(Map<String, dynamic> json) =>
      _$CashSessionFromJson(json);
}

/// Movimento de uma sessão de caixa (valor sempre positivo; o sinal vem do tipo).
@freezed
abstract class CashMovement with _$CashMovement {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CashMovement({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String sessionId,
    required CashMovementType type,
    @MinorUnitConverter() required int amountMinor,
    @UtcDateTimeConverter() required DateTime occurredAt,
    String? description,
    String? paymentId,
  }) = _CashMovement;

  factory CashMovement.fromJson(Map<String, dynamic> json) =>
      _$CashMovementFromJson(json);
}
