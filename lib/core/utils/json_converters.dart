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

/// Datas de calendário (`yyyy-MM-dd`, ex.: nascimento) sem hora nem fuso:
/// representadas como meia-noite UTC, para não "andarem um dia" entre fusos.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(json);
    if (m == null) {
      throw FormatException('Data inválida (esperado yyyy-MM-dd).', json);
    }
    final y = int.parse(m[1]!), mo = int.parse(m[2]!), d = int.parse(m[3]!);
    final date = DateTime.utc(y, mo, d);
    if (date.month != mo || date.day != d) {
      throw FormatException('Data inexistente.', json);
    }
    return date;
  }

  @override
  String toJson(DateTime object) {
    final u = object.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}';
  }
}
