import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'minor_unit_converter.dart';

part 'credit_note.freezed.dart';
part 'credit_note.g.dart';

/// Nota de crédito emitida ao anular uma factura (anula o valor total).
@freezed
abstract class CreditNote with _$CreditNote {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CreditNote({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String invoiceId,
    required String number,
    required String series,
    @UtcDateTimeConverter() required DateTime issuedAt,
    required String reason,
    @MinorUnitConverter() required int totalMinor,
  }) = _CreditNote;

  factory CreditNote.fromJson(Map<String, dynamic> json) =>
      _$CreditNoteFromJson(json);
}
