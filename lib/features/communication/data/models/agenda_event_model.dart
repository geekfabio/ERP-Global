import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'communication_enums.dart';

part 'agenda_event_model.freezed.dart';
part 'agenda_event_model.g.dart';

/// Evento do calendário/agenda escolar.
@freezed
abstract class AgendaEventModel with _$AgendaEventModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AgendaEventModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String title,
    String? description,
    required AgendaEventType type,
    @UtcDateTimeConverter() required DateTime startsAt,
    @UtcDateTimeConverter() DateTime? endsAt,
    @Default(false) bool allDay,

    /// Turma a que se destina; `null` = toda a escola.
    String? classroomId,
    String? location,
  }) = _AgendaEventModel;

  factory AgendaEventModel.fromJson(Map<String, dynamic> json) =>
      _$AgendaEventModelFromJson(json);
}
