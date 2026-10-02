import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Payment({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required PaymentMethod method,
    @MinorUnitConverter() required int amountMinor,
    @UtcDateTimeConverter() required DateTime paidAt,
    @Default(PaymentStatus.completed) PaymentStatus status,
    @Default(<PaymentAllocation>[]) List<PaymentAllocation> allocations,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

@freezed
abstract class PaymentAllocation with _$PaymentAllocation {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory PaymentAllocation({
    required String chargeId,
    @MinorUnitConverter() required int amountMinor,
  }) = _PaymentAllocation;

  factory PaymentAllocation.fromJson(Map<String, dynamic> json) =>
      _$PaymentAllocationFromJson(json);
}
