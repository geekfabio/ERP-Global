import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'payment_notice.freezed.dart';
part 'payment_notice.g.dart';

/// Aviso pré/pós-vencimento enviado ao aluno/encarregado.
@freezed
abstract class PaymentNotice with _$PaymentNotice {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory PaymentNotice({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String chargeId,
    required NoticeKind kind,
    @DateOnlyConverter() required DateTime dueDate,
    @MinorUnitConverter() required int amountMinor,
    required String message,
    @UtcDateTimeConverter() required DateTime sentAt,
  }) = _PaymentNotice;

  factory PaymentNotice.fromJson(Map<String, dynamic> json) =>
      _$PaymentNoticeFromJson(json);
}
