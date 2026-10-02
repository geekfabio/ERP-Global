import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

@freezed
abstract class Receipt with _$Receipt {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Receipt({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String paymentId,
    required String number,
    @UtcDateTimeConverter() required DateTime issuedAt,
    @MinorUnitConverter() required int amountMinor,
    @Default(ReceiptStatus.issued) ReceiptStatus status,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
