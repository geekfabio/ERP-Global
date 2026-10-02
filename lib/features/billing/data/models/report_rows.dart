import 'package:freezed_annotation/freezed_annotation.dart';

import 'minor_unit_converter.dart';

part 'report_rows.freezed.dart';
part 'report_rows.g.dart';

/// Agrupamento do relatório de receita.
@JsonEnum(fieldRename: FieldRename.snake)
enum RevenueGroup { period, feeType, campus }

/// Linha do relatório de receita (vista calculada, não persistida). [key] é o
/// mês `yyyy-MM`, o tipo de rubrica ou o id do campus, conforme o agrupamento.
@freezed
abstract class RevenueRow with _$RevenueRow {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory RevenueRow({
    required String key,
    @MinorUnitConverter() required int receivedMinor,
    required int allocationCount,
  }) = _RevenueRow;

  factory RevenueRow.fromJson(Map<String, dynamic> json) =>
      _$RevenueRowFromJson(json);
}

/// Previsto (cobranças com vencimento no mês) vs. recebido (o que já foi
/// pago dessas cobranças).
@freezed
abstract class ForecastRow with _$ForecastRow {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ForecastRow({
    required String period,
    @MinorUnitConverter() required int expectedMinor,
    @MinorUnitConverter() required int receivedMinor,
    required int chargeCount,
  }) = _ForecastRow;

  factory ForecastRow.fromJson(Map<String, dynamic> json) =>
      _$ForecastRowFromJson(json);
}
