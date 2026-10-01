import 'package:freezed_annotation/freezed_annotation.dart';

part 'consumption_rows.freezed.dart';
part 'consumption_rows.g.dart';

/// Agrupamento do relatório de consumo.
@JsonEnum(fieldRename: FieldRename.snake)
enum ConsumptionGroup { classroom, day, meal }

/// Linha do relatório de consumo (vista calculada, não persistida). [key] é a
/// turma (vazio = sem turma), o dia `yyyy-MM-dd` ou o id do tipo de refeição;
/// [label] é o texto legível quando o servidor o conhece (tipo de refeição).
@freezed
abstract class ConsumptionRow with _$ConsumptionRow {
  const factory ConsumptionRow({
    required String key,
    String? label,

    /// Número de consumos (líquidos de estornos).
    required int purchaseCount,
    required int totalMinor,
  }) = _ConsumptionRow;

  factory ConsumptionRow.fromJson(Map<String, dynamic> json) =>
      _$ConsumptionRowFromJson(json);
}

/// Saldo pré-pago agregado de todas as carteiras.
@freezed
abstract class PrepaidBalance with _$PrepaidBalance {
  const factory PrepaidBalance({
    required int totalBalanceMinor,
    required int walletCount,
    required int blockedCount,
  }) = _PrepaidBalance;

  factory PrepaidBalance.fromJson(Map<String, dynamic> json) =>
      _$PrepaidBalanceFromJson(json);
}
