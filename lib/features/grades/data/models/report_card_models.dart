import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'report_card_models.freezed.dart';
part 'report_card_models.g.dart';

/// Estado do boletim de um aluno num trimestre: observações do director de
/// turma e último envio ao encarregado.
@freezed
abstract class ReportCardStateModel with _$ReportCardStateModel {
  const factory ReportCardStateModel({
    required String studentId,
    required String termId,

    /// Observações do director de turma (texto livre).
    @Default('') String remarks,
    @UtcDateTimeConverter() DateTime? sentAt,
    @Default(<String>[]) List<String> sentToGuardianIds,
  }) = _ReportCardStateModel;

  factory ReportCardStateModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCardStateModelFromJson(json);
}
