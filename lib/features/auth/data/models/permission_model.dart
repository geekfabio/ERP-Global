import 'package:freezed_annotation/freezed_annotation.dart';

import 'utc_date_time_converter.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

@freezed
abstract class PermissionModel with _$PermissionModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory PermissionModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String code,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}
