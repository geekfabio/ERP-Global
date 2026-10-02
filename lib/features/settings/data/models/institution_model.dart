import 'package:freezed_annotation/freezed_annotation.dart';

part 'institution_model.freezed.dart';
part 'institution_model.g.dart';

/// Dados da instituição (docs/03 · Estrutura académica). `brandColor` é `#RRGGBB`.
@freezed
abstract class InstitutionModel with _$InstitutionModel {
  const factory InstitutionModel({
    required String id,
    required String name,
    required String nif,
    required String address,
    required String phone,
    required String email,
    required String brandColor,
    String? logoUrl,
  }) = _InstitutionModel;

  factory InstitutionModel.fromJson(Map<String, dynamic> json) =>
      _$InstitutionModelFromJson(json);
}
