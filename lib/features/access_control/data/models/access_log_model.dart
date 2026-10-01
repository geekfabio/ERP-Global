import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'access_log_model.freezed.dart';
part 'access_log_model.g.dart';

enum GateDirection { entry, exit }

/// Registo de uma tentativa de acesso numa zona (permitida ou negada).
@freezed
abstract class AccessLogModel with _$AccessLogModel {
  const factory AccessLogModel({
    required String id,
    required String zoneId,
    String? deviceId,
    required String cardUid,
    String? holderId,
    String? holderName,
    String? holderType,
    @Default(GateDirection.entry) GateDirection direction,
    required bool allowed,

    /// Nome de `AccessReason` (ex.: `granted`, `outsideSchedule`).
    required String reason,

    /// `true` se o encarregado foi avisado desta passagem.
    @Default(false) bool guardianAlerted,
    @UtcDateTimeConverter() required DateTime occurredAt,
  }) = _AccessLogModel;

  factory AccessLogModel.fromJson(Map<String, dynamic> json) =>
      _$AccessLogModelFromJson(json);
}

extension AccessLogDraft on AccessLogModel {
  Map<String, dynamic> toBody() => toJson()..remove('id');
}
