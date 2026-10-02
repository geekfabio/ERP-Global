import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'billing_enums.dart';

part 'cash_register.freezed.dart';
part 'cash_register.g.dart';

@freezed
abstract class CashRegister with _$CashRegister {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CashRegister({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String name,
    @Default(CashRegisterStatus.active) CashRegisterStatus status,
  }) = _CashRegister;

  factory CashRegister.fromJson(Map<String, dynamic> json) =>
      _$CashRegisterFromJson(json);
}
