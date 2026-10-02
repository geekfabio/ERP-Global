import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'payment_agreement.freezed.dart';
part 'payment_agreement.g.dart';

/// Prestação de um acordo de pagamento.
@freezed
abstract class AgreementInstallment with _$AgreementInstallment {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AgreementInstallment({
    required int number,
    @DateOnlyConverter() required DateTime dueDate,
    @MinorUnitConverter() required int amountMinor,
    @Default(false) bool paid,
  }) = _AgreementInstallment;

  factory AgreementInstallment.fromJson(Map<String, dynamic> json) =>
      _$AgreementInstallmentFromJson(json);
}

/// Acordo de pagamento: dívida em atraso repartida em prestações.
@freezed
abstract class PaymentAgreement with _$PaymentAgreement {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory PaymentAgreement({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required List<String> chargeIds,
    @MinorUnitConverter() required int totalMinor,
    @MinorUnitConverter() @Default(0) int paidMinor,
    required List<AgreementInstallment> installments,
    @Default(AgreementStatus.active) AgreementStatus status,
  }) = _PaymentAgreement;

  factory PaymentAgreement.fromJson(Map<String, dynamic> json) =>
      _$PaymentAgreementFromJson(json);
}
