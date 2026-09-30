import 'package:freezed_annotation/freezed_annotation.dart';

import 'utc_date_time_converter.dart';
import 'scope_model.dart';

part 'user_role.freezed.dart';
part 'user_role.g.dart';

@freezed
abstract class UserRole with _$UserRole {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory UserRole({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String userId,
    required String roleId,
    ScopeModel? scope,
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
}
