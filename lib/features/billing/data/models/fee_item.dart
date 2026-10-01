import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'fee_item.freezed.dart';
part 'fee_item.g.dart';

@freezed
abstract class FeeItem with _$FeeItem {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory FeeItem({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String academicYearId,
    required String gradeId,
    required FeeType type,
    @MinorUnitConverter() required int amountMinor,
    @Default(FeeItemStatus.active) FeeItemStatus status,
  }) = _FeeItem;

  factory FeeItem.fromJson(Map<String, dynamic> json) =>
      _$FeeItemFromJson(json);
}
