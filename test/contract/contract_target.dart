import 'package:dio/dio.dart';
import 'package:erp_global/core/network/api_client.dart';

/// Ligação a um backend que cumpre docs/07-mock-api.md: o adaptador mock hoje,
/// o servidor real amanhã. A suite de contrato só conhece esta interface.
abstract interface class ContractTarget {
  String get name;

  /// Motivo para saltar a suite (ex.: servidor real não configurado); `null` = corre.
  String? get skipReason;

  /// Cliente novo, com estado de servidor em seed (`POST /__mock/reset` no mock).
  Future<ApiClient> open();
}

/// Resposta crua para asserções sobre o envelope (sem lançar em 4xx).
Future<Response<Map<String, dynamic>>> call(
  ApiClient client,
  String method,
  String path, {
  Object? data,
  Map<String, dynamic>? query,
}) => client.dio.request<Map<String, dynamic>>(
  path,
  data: data,
  queryParameters: query,
  options: Options(method: method, validateStatus: (_) => true),
);
