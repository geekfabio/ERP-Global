import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'minor_unit_converter.dart';

part 'student_account.freezed.dart';
part 'student_account.g.dart';

@freezed
abstract class StudentAccount with _$StudentAccount {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentAccount({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,

    /// Saldo líquido: `prepaidMinor - outstandingMinor` (negativo = em dívida).
    @MinorUnitConverter() required int balanceMinor,

    /// Crédito pré-pago disponível (pagamentos adiantados ainda por usar).
    @MinorUnitConverter() @Default(0) int prepaidMinor,

    /// Total em dívida das cobranças abertas.
    @MinorUnitConverter() @Default(0) int outstandingMinor,
    @Default(<LedgerEntry>[]) List<LedgerEntry> entries,
  }) = _StudentAccount;

  factory StudentAccount.fromJson(Map<String, dynamic> json) =>
      _$StudentAccountFromJson(json);
}

@freezed
abstract class LedgerEntry with _$LedgerEntry {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory LedgerEntry({
    required String id,
    required String referenceId,

    /// `charge` (débito) ou `payment` (crédito).
    @Default('payment') String kind,
    @UtcDateTimeConverter() required DateTime occurredAt,
    @MinorUnitConverter() required int debitMinor,
    @MinorUnitConverter() required int creditMinor,
  }) = _LedgerEntry;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$LedgerEntryFromJson(json);
}
