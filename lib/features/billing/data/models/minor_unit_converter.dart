import 'package:json_annotation/json_annotation.dart';

/// Dinheiro em cêntimos. Rejeita decimais, strings e null em vez de os
/// truncar na leitura JSON.
class MinorUnitConverter implements JsonConverter<int, Object?> {
  const MinorUnitConverter();

  @override
  int fromJson(Object? json) {
    if (json is int) return json;
    throw TypeError();
  }

  @override
  Object? toJson(int object) => object;
}
