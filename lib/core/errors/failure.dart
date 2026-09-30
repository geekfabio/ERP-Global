/// Falhas tipadas da aplicação. A UI recebe sempre um [Failure], nunca excepções cruas.
sealed class Failure {
  const Failure({required this.code, required this.message, this.cause});

  /// Código estável (igual ao `error.code` do contrato em docs/07-mock-api.md quando existe).
  final String code;

  /// Mensagem pronta para o utilizador (pt-AO).
  final String message;

  /// Erro original, apenas para logging.
  final Object? cause;

  /// Constrói a falha certa a partir do `error` do envelope da API.
  factory Failure.fromApiError({
    required int? statusCode,
    String? code,
    String? message,
    Map<String, String>? fields,
  }) {
    final resolved = code ?? _defaultCode(statusCode);
    switch (resolved) {
      case 'UNAUTHENTICATED':
      case 'TOKEN_EXPIRED':
      case 'INVALID_CREDENTIALS':
        return AuthFailure(code: resolved, message: message);
      case 'MODULE_NOT_LICENSED':
      case 'LICENSE_READ_ONLY':
        return LicenseFailure(code: resolved, message: message);
      case 'FORBIDDEN':
        return PermissionFailure(message: message);
      case 'VALIDATION_ERROR':
        return ValidationFailure(message: message, fields: fields ?? const {});
    }
    return UnknownFailure(code: resolved, message: message);
  }

  static String _defaultCode(int? status) => switch (status) {
    400 => 'BAD_REQUEST',
    401 => 'UNAUTHENTICATED',
    403 => 'FORBIDDEN',
    404 => 'NOT_FOUND',
    409 => 'CONFLICT',
    422 => 'VALIDATION_ERROR',
    _ => 'INTERNAL_ERROR',
  };

  @override
  String toString() => '$runtimeType($code: $message)';
}

/// Mensagens pt-AO por código.
const _messages = <String, String>{
  'NETWORK_ERROR':
      'Sem ligação ao servidor. Verifique a rede e tente novamente.',
  'TIMEOUT': 'O servidor demorou demasiado a responder. Tente novamente.',
  'UNAUTHENTICATED': 'Sessão inválida. Inicie sessão novamente.',
  'TOKEN_EXPIRED': 'A sessão expirou. Inicie sessão novamente.',
  'INVALID_CREDENTIALS': 'Identificador ou palavra-passe incorrectos.',
  'VALIDATION_ERROR': 'Dados inválidos. Corrija os campos assinalados.',
  'FORBIDDEN': 'Não tem permissão para realizar esta acção.',
  'MODULE_NOT_LICENSED': 'Este módulo não está incluído na licença.',
  'LICENSE_READ_ONLY':
      'A licença está em modo de leitura. Não é possível alterar dados.',
  'BAD_REQUEST': 'Pedido inválido.',
  'NOT_FOUND': 'Registo não encontrado.',
  'CONFLICT': 'Operação em conflito com dados existentes.',
  'INTERNAL_ERROR': 'Ocorreu um erro no servidor. Tente novamente mais tarde.',
  'UNKNOWN': 'Ocorreu um erro inesperado.',
};

String _messageFor(String code) => _messages[code] ?? _messages['UNKNOWN']!;

/// Falha de ligação ou tempo esgotado.
final class NetworkFailure extends Failure {
  NetworkFailure({super.code = 'NETWORK_ERROR', String? message, super.cause})
    : super(message: message ?? _messageFor(code));

  NetworkFailure.timeout({Object? cause}) : this(code: 'TIMEOUT', cause: cause);
}

/// Sessão, token ou credenciais.
final class AuthFailure extends Failure {
  AuthFailure({super.code = 'UNAUTHENTICATED', String? message, super.cause})
    : super(message: message ?? _messageFor(code));

  bool get isTokenExpired => code == 'TOKEN_EXPIRED';
}

/// Validação por campo (`fields`: nome do campo → mensagem).
final class ValidationFailure extends Failure {
  ValidationFailure({String? message, this.fields = const {}, super.cause})
    : super(
        code: 'VALIDATION_ERROR',
        message: message ?? _messageFor('VALIDATION_ERROR'),
      );

  final Map<String, String> fields;
}

/// Sem permissão para a acção/âmbito.
final class PermissionFailure extends Failure {
  PermissionFailure({String? message, super.cause})
    : super(code: 'FORBIDDEN', message: message ?? _messageFor('FORBIDDEN'));
}

/// Módulo não licenciado ou licença só de leitura.
final class LicenseFailure extends Failure {
  LicenseFailure({
    super.code = 'MODULE_NOT_LICENSED',
    String? message,
    super.cause,
  }) : super(message: message ?? _messageFor(code));

  bool get isReadOnly => code == 'LICENSE_READ_ONLY';
}

/// Qualquer outro erro (incluindo 400/404/409/5xx).
final class UnknownFailure extends Failure {
  UnknownFailure({super.code = 'UNKNOWN', String? message, super.cause})
    : super(message: message ?? _messageFor(code));
}
