import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'communication_enums.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

/// Comunicado dirigido a um público, com confirmação de leitura opcional.
@freezed
abstract class AnnouncementModel with _$AnnouncementModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AnnouncementModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String title,
    required String body,
    required AnnouncementAudience audience,

    /// Turma alvo (obrigatório para `classroom`; opcional para `guardians`).
    String? classroomId,
    @Default(AnnouncementStatus.published) AnnouncementStatus status,
    @Default(false) bool requiresReadReceipt,

    /// Canais de entrega (`in_app`, `push`, `sms`, `email`).
    @Default(<String>['in_app']) List<String> channels,
    String? createdBy,
    @UtcDateTimeConverter() DateTime? publishedAt,

    /// Quantos já confirmaram a leitura / quantos destinatários (calculado no servidor).
    @Default(0) int readCount,
    @Default(0) int recipientCount,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}

/// Confirmação de leitura de um comunicado por um utilizador.
@freezed
abstract class AnnouncementReadModel with _$AnnouncementReadModel {
  const factory AnnouncementReadModel({
    required String announcementId,
    required String userId,
    @UtcDateTimeConverter() required DateTime readAt,
  }) = _AnnouncementReadModel;

  factory AnnouncementReadModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementReadModelFromJson(json);
}
