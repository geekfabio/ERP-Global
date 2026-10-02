import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';
import 'minor_unit_converter.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Invoice({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    String? number,

    /// Série local (`FT 2026`); a numeração fiscal definitiva é do backend.
    String? series,
    @UtcDateTimeConverter() DateTime? issuedAt,
    @Default(InvoiceStatus.draft) InvoiceStatus status,
    @Default(<InvoiceLine>[]) List<InvoiceLine> lines,
    @MinorUnitConverter() @Default(0) int taxMinor,
    @MinorUnitConverter() required int totalMinor,

    /// Preenchidos ao anular (a factura passa a `cancelled`).
    String? cancelReason,
    String? creditNoteId,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}

@freezed
abstract class InvoiceLine with _$InvoiceLine {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory InvoiceLine({
    required String chargeId,
    required String description,
    @MinorUnitConverter() required int amountMinor,

    /// Taxa de IVA em pontos-base (1400 = 14 %); 0 = isento.
    @Default(0) int taxRateBp,
    @MinorUnitConverter() @Default(0) int taxMinor,
    String? exemptionReason,
  }) = _InvoiceLine;

  factory InvoiceLine.fromJson(Map<String, dynamic> json) =>
      _$InvoiceLineFromJson(json);
}
