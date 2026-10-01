/// Valor lido de uma célula: texto cru (já aparado) ou `null` se vazia.
typedef RawCell = String?;

/// Coluna de destino de um perfil de importação.
class ImportColumn {
  const ImportColumn({
    required this.key,
    required this.label,
    this.required = false,
    this.aliases = const [],
    this.parse,
  });

  /// Chave do campo no registo enviado à API.
  final String key;

  /// Rótulo (pt-AO) mostrado ao utilizador.
  final String label;
  final bool required;

  /// Cabeçalhos alternativos reconhecidos no mapeamento automático.
  final List<String> aliases;

  /// Converte o texto num valor normalizado; lança [FormatException] com a
  /// mensagem para o utilizador se for inválido. `null` = texto tal como está.
  final Object? Function(String raw)? parse;
}

/// Define como importar uma entidade: colunas, regras entre campos e destino.
/// Cada módulo regista o seu perfil em `importProfilesProvider`.
abstract interface class ImportProfile {
  /// Identificador estável (`students`).
  String get id;

  /// Nome apresentado (pt-AO).
  String get label;

  /// Recurso da API que recebe a gravação (`/v1/imports/{entity}`).
  String get entity;

  List<ImportColumn> get columns;

  /// Regras entre campos de uma linha já convertida; devolve erros por chave.
  Map<String, String> validateRecord(Map<String, Object?> record);
}

/// Erro de uma célula/linha.
class ImportRowError {
  const ImportRowError({required this.field, required this.message});
  final String field;
  final String message;
}
