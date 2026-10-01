import 'package:dio/dio.dart';
import 'package:erp_global/core/network/api_client.dart';

import 'contract_target.dart';

const _baseUrl = String.fromEnvironment('CONTRACT_BASE_URL');

/// Servidor real: `flutter test test/contract --dart-define=CONTRACT_BASE_URL=https://staging.../`.
/// Sem a variável, a suite é saltada. Só deve apontar a ambientes descartáveis
/// (a suite cria e apaga registos).
class RealContractTarget implements ContractTarget {
  @override
  String get name => 'servidor real';

  @override
  String? get skipReason => _baseUrl.isEmpty
      ? 'CONTRACT_BASE_URL não definido (--dart-define=CONTRACT_BASE_URL=...)'
      : null;

  @override
  Future<ApiClient> open() async {
    final client = ApiClient.create(
      baseUrl: _baseUrl,
      useMockApi: false,
      logging: false,
    );
    // O reset só existe no mock; num servidor real devolve 404 e ignora-se.
    try {
      await client.dio.post<dynamic>('/__mock/reset');
    } on DioException catch (_) {}
    return client;
  }
}
