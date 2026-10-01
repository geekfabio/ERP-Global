import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

/// Desconto ou bolsa de um aluno, com validade e aprovação.
///
/// [value] é em pontos base (1..10000) para `percentage` e na menor unidade
/// monetária, por cobrança, para `fixed`. [feeType] nulo = todos os tipos.
@freezed
abstract class Discount with _$Discount {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Discount({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required DiscountKind kind,
    required DiscountReason reason,
    required int value,
    FeeType? feeType,
    @DateOnlyConverter() required DateTime validFrom,
    @DateOnlyConverter() DateTime? validUntil,
    String? note,
    @Default(DiscountStatus.pending) DiscountStatus status,
    String? decisionNote,
    @UtcDateTimeConverter() DateTime? decidedAt,
  }) = _Discount;

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
}
