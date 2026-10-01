import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

/// Módulo a que a regra pertence.
enum SettingModule { academic, finance, tax }

enum SettingType { integer, boolean, text, choice }

/// Regra configurável tipada. O valor, os limites e as opções vêm do servidor;
/// a app não tem valores por omissão no código.
@freezed
abstract class SettingModel with _$SettingModel {
  const factory SettingModel({
    required String key,
    required SettingModule module,
    required SettingType type,

    /// `int`, `bool` ou `String` consoante [type]; percentagens em pontos
    /// base (1400 = 14 %) e dinheiro na menor unidade.
    required Object value,
    int? min,
    int? max,
    @Default(<String>[]) List<String> options,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}
