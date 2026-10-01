import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'access_models.freezed.dart';
part 'access_models.g.dart';

/// Quem tenta entrar; cada regra aplica-se a um tipo (ou a todos).
enum AccessSubject { all, student, staff, guardian }

enum DeviceKind { turnstile, reader, door }

enum DeviceStatus { online, offline }

/// Zona física (portaria, laboratório, biblioteca…) de um campus.
@freezed
abstract class ZoneModel with _$ZoneModel {
  const factory ZoneModel({
    required String id,
    required String campusId,
    required String name,
    String? description,
    @Default(true) bool isActive,
  }) = _ZoneModel;

  factory ZoneModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneModelFromJson(json);
}

/// Leitor, torniquete ou porta associado a uma zona.
@freezed
abstract class AccessDeviceModel with _$AccessDeviceModel {
  const factory AccessDeviceModel({
    required String id,
    required String zoneId,
    required String name,
    @Default(DeviceKind.reader) DeviceKind kind,
    @Default(DeviceStatus.online) DeviceStatus status,
    @Default(true) bool isActive,
    @UtcDateTimeConverter() DateTime? lastSeenAt,
  }) = _AccessDeviceModel;

  factory AccessDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$AccessDeviceModelFromJson(json);
}

/// Janela de acesso de uma zona: dias (1 = segunda … 7 = domingo) e horas em
/// minutos desde as 00:00 (`startMinute` inclusivo, `endMinute` exclusivo),
/// com condições opcionais de estado do aluno e financeiro.
@freezed
abstract class AccessRuleModel with _$AccessRuleModel {
  const factory AccessRuleModel({
    required String id,
    required String zoneId,
    required String name,
    @Default(AccessSubject.all) AccessSubject subject,
    required List<int> days,
    required int startMinute,
    required int endMinute,
    @Default(false) bool requireActiveStudent,
    @Default(false) bool requireFinancialClear,
    @Default(true) bool isActive,
  }) = _AccessRuleModel;

  factory AccessRuleModel.fromJson(Map<String, dynamic> json) =>
      _$AccessRuleModelFromJson(json);
}

/// Corpo comum de criação/edição (o `id` é atribuído pelo servidor).
extension AccessRuleDraft on AccessRuleModel {
  Map<String, dynamic> toBody() => toJson()..remove('id');
}

extension ZoneDraft on ZoneModel {
  Map<String, dynamic> toBody() => toJson()..remove('id');
}

extension DeviceDraft on AccessDeviceModel {
  Map<String, dynamic> toBody() => toJson()
    ..remove('id')
    ..remove('lastSeenAt');
}
