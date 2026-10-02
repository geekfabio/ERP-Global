import 'package:freezed_annotation/freezed_annotation.dart';

part 'campus_model.freezed.dart';
part 'campus_model.g.dart';

/// Campus/filial da instituição.
@freezed
abstract class CampusModel with _$CampusModel {
  const factory CampusModel({
    required String id,
    required String institutionId,
    required String name,
    required String address,
    required String phone,
  }) = _CampusModel;

  factory CampusModel.fromJson(Map<String, dynamic> json) =>
      _$CampusModelFromJson(json);
}
