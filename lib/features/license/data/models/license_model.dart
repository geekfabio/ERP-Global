import 'dart:convert';

/// Limites contratados; `null` = sem limite para essa dimensão.
class LicenseLimits {
  const LicenseLimits({this.campuses, this.students, this.users, this.devices});

  factory LicenseLimits.fromJson(Map<String, dynamic> json) => LicenseLimits(
    campuses: json['campuses'] as int?,
    students: json['students'] as int?,
    users: json['users'] as int?,
    devices: json['devices'] as int?,
  );

  final int? campuses;
  final int? students;
  final int? users;
  final int? devices;

  int? operator [](String key) => switch (key) {
    'campuses' => campuses,
    'students' => students,
    'users' => users,
    'devices' => devices,
    _ => null,
  };
}

/// Licença assinada (docs/02-modulos-e-licenciamento.md). A assinatura cobre o
/// JSON canónico de todos os campos excepto `signature` — ver [signedPayload].
class LicenseModel {
  const LicenseModel({
    required this.licenseId,
    required this.institutionId,
    required this.institutionName,
    required this.plan,
    required this.modules,
    required this.limits,
    required this.issuedAt,
    required this.expiresAt,
    required this.graceDays,
    required this.signature,
    required this.raw,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    T field<T>(String key) {
      final v = json[key];
      if (v is! T) {
        throw FormatException(
          'Licença inválida: campo "$key" em falta ou inválido',
        );
      }
      return v;
    }

    DateTime date(String key) {
      final parsed = DateTime.tryParse(field<String>(key));
      if (parsed == null) {
        throw FormatException('Licença inválida: data "$key"');
      }
      return DateTime.utc(parsed.year, parsed.month, parsed.day);
    }

    return LicenseModel(
      licenseId: field<String>('licenseId'),
      institutionId: field<String>('institutionId'),
      institutionName: field<String>('institutionName'),
      plan: field<String>('plan'),
      modules: List.unmodifiable(
        field<List<dynamic>>('modules').cast<String>(),
      ),
      limits: LicenseLimits.fromJson(
        (json['limits'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      issuedAt: date('issuedAt'),
      expiresAt: date('expiresAt'),
      graceDays: field<int>('graceDays'),
      signature: field<String>('signature'),
      raw: Map<String, dynamic>.of(json),
    );
  }

  /// Interpreta o texto JSON de uma licença.
  factory LicenseModel.parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Licença inválida: não é um objecto JSON');
    }
    return LicenseModel.fromJson(decoded);
  }

  final String licenseId;
  final String institutionId;
  final String institutionName;
  final String plan;
  final List<String> modules;
  final LicenseLimits limits;
  final DateTime issuedAt;

  /// Último dia de validade (inclusive).
  final DateTime expiresAt;
  final int graceDays;

  /// Ed25519 em base64 sobre [signedPayload].
  final String signature;

  /// Documento original (base da assinatura).
  final Map<String, dynamic> raw;

  /// Bytes assinados: JSON canónico (chaves ordenadas, sem espaços) de todos os
  /// campos do documento original excepto `signature`. Usa o documento cru para
  /// que qualquer alteração (mesmo em campos desconhecidos) invalide a assinatura.
  List<int> get signedPayload => utf8.encode(canonicalJson(raw));

  /// JSON canónico de [json] sem a chave `signature`.
  static String canonicalJson(Map<String, dynamic> json) {
    final body = Map<String, dynamic>.of(json)..remove('signature');
    return jsonEncode(_sorted(body));
  }

  static Object? _sorted(Object? v) {
    if (v is Map) {
      final keys = v.keys.cast<String>().toList()..sort();
      return {for (final k in keys) k: _sorted(v[k])};
    }
    if (v is List) return v.map(_sorted).toList();
    return v;
  }
}
