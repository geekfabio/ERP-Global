import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'minor_unit_converter.dart';

part 'debtor.freezed.dart';
part 'debtor.g.dart';

/// Aluno com cobranças vencidas e por pagar (vista calculada, não persistida).
@freezed
abstract class Debtor with _$Debtor {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Debtor({
    required String studentId,
    String? classroomId,
    @MinorUnitConverter() required int overdueMinor,
    required int overdueCount,
    @DateOnlyConverter() required DateTime oldestDueDate,
    required int daysOverdue,
    @Default(false) bool hasAgreement,
  }) = _Debtor;

  factory Debtor.fromJson(Map<String, dynamic> json) => _$DebtorFromJson(json);
}
