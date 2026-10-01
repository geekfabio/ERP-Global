import '../../../core/errors/result.dart';

/// Linha rejeitada pelo servidor na gravação.
class ImportRejection {
  const ImportRejection({required this.index, required this.errors});

  /// Posição (0-based) do registo enviado.
  final int index;
  final Map<String, String> errors;
}

class ImportCommitResult {
  const ImportCommitResult({required this.imported, required this.rejected});

  final int imported;
  final List<ImportRejection> rejected;
}

abstract interface class ImportRepository {
  /// Grava os registos já validados. Só é chamado após confirmação explícita.
  Future<Result<ImportCommitResult>> commit(
    String entity,
    List<Map<String, Object?>> records,
  );
}
