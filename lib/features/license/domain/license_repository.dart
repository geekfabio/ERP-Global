import '../../../core/errors/result.dart';
import '../data/models/license_usage.dart';

/// Dados de licença vindos da API (o consumo; a validação da licença em si é
/// offline, em `LicenseService`).
abstract interface class LicenseRepository {
  Future<Result<LicenseUsage>> usage();
}
