import 'package:json_annotation/json_annotation.dart';

/// Normaliza as datas da API e da persistência para UTC.
class UtcDateTimeConverter implements JsonConverter<DateTime, String> {
  const UtcDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    if (!RegExp(
      r'(Z|[+-]\d{2}:?\d{2})$',
      caseSensitive: false,
    ).hasMatch(json)) {
      throw FormatException('A data deve incluir o fuso horário.', json);
    }
    return DateTime.parse(json).toUtc();
  }

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
