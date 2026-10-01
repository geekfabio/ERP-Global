import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'charge.freezed.dart';
part 'charge.g.dart';

@freezed
abstract class Charge with _$Charge {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Charge({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String feeItemId,
    @DateOnlyConverter() required DateTime dueDate,
    @MinorUnitConverter() required int amountMinor,
    @MinorUnitConverter() @Default(0) int discountMinor,
    @Default(ChargeStatus.pending) ChargeStatus status,
  }) = _Charge;

  factory Charge.fromJson(Map<String, dynamic> json) => _$ChargeFromJson(json);
}
