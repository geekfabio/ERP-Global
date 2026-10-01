import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/access_log_model.dart';
import '../data/models/access_models.dart';

abstract interface class AccessLogRepository {
  Future<Result<PagedList<AccessLogModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
    bool? allowed,
  });

  /// Regista uma tentativa; 404/422 se zona ou campos inválidos.
  Future<Result<AccessLogModel>> record(AccessLogModel log);
}

/// Titular de um cartão, com o que as regras precisam de saber.
class AccessHolder {
  const AccessHolder({
    required this.id,
    required this.name,
    required this.subject,
    this.cardBlocked = false,
    this.studentActive = true,
    this.financialClear = true,
  });

  final String id;
  final String name;
  final AccessSubject subject;
  final bool cardBlocked;
  final bool studentActive;
  final bool financialClear;
}

/// Resolve um UID de cartão (cartões, aluno e situação financeira) e os
/// encarregados a avisar; sem dependência de outros módulos.
abstract interface class AccessHolderResolver {
  /// `null` se o cartão não existe.
  Future<Result<AccessHolder?>> byCardUid(String uid);

  /// Ids de utilizador dos encarregados com vínculo válido e conta no portal.
  Future<Result<List<String>>> guardianUserIds(String studentId);
}
