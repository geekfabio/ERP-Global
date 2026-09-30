import 'mock_types.dart';

/// Validação 422 por campo para handlers mock.
///
/// ```dart
/// MockValidator(req.jsonBody)
///   ..required('name')
///   ..email('email')
///   ..throwIfInvalid();
/// ```
class MockValidator {
  MockValidator(this.body);

  final Map<String, dynamic> body;
  final Map<String, String> errors = {};

  void required(String field, [String message = 'Campo obrigatório']) {
    final v = body[field];
    if (v == null || (v is String && v.trim().isEmpty)) {
      errors.putIfAbsent(field, () => message);
    }
  }

  void email(String field, [String message = 'Formato inválido']) {
    final v = body[field];
    if (v is String &&
        v.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
      errors.putIfAbsent(field, () => message);
    }
  }

  void minLength(String field, int min, [String? message]) {
    final v = body[field];
    if (v is String && v.isNotEmpty && v.length < min) {
      errors.putIfAbsent(field, () => message ?? 'Mínimo de $min caracteres');
    }
  }

  /// Regra livre: se [valid] for falso regista [message] para [field].
  void check(String field, bool valid, String message) {
    if (!valid) errors.putIfAbsent(field, () => message);
  }

  bool get isValid => errors.isEmpty;

  void throwIfInvalid() {
    if (!isValid) throw MockApiException.validation(Map.of(errors));
  }
}
