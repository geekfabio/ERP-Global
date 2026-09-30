import 'package:dio/dio.dart';

import '../errors/failure.dart';

/// `meta` de listas paginadas (docs/07-mock-api.md).
class PageMeta {
  const PageMeta({
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
    total: json['total'] as int,
  );

  final int page;
  final int pageSize;
  final int total;

  int get totalPages => pageSize == 0 ? 0 : (total + pageSize - 1) ~/ pageSize;
  bool get hasNext => page < totalPages;

  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
    'total': total,
  };
}

/// Lista paginada já convertida para DTOs.
class PagedList<T> {
  const PagedList({required this.items, required this.meta});
  final List<T> items;
  final PageMeta meta;
}

/// Leitura/escrita do envelope `{data, meta}` / `{error}`.
class ApiEnvelope {
  const ApiEnvelope._();

  static Map<String, dynamic> success(Object? data, {PageMeta? meta}) => {
    'data': data,
    if (meta != null) 'meta': meta.toJson(),
  };

  static Map<String, dynamic> error({
    required String code,
    required String message,
    Map<String, String>? fields,
  }) => {
    'error': {
      'code': code,
      'message': message,
      if (fields != null && fields.isNotEmpty) 'fields': fields,
    },
  };

  /// Corpo `data` de uma resposta de sucesso.
  static Object? data(Response<dynamic> response) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      return body['data'];
    }
    throw UnknownFailure(message: 'Resposta fora do contrato (sem "data").');
  }

  static T object<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic> json) fromJson,
  ) => fromJson(data(response)! as Map<String, dynamic>);

  static PagedList<T> page<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final body = response.data;
    if (body is! Map<String, dynamic> || body['meta'] is! Map) {
      throw UnknownFailure(message: 'Resposta fora do contrato (sem "meta").');
    }
    return PagedList(
      items: (body['data'] as List)
          .cast<Map<String, dynamic>>()
          .map(fromJson)
          .toList(growable: false),
      meta: PageMeta.fromJson(body['meta'] as Map<String, dynamic>),
    );
  }

  /// [Failure] a partir de uma resposta de erro; `null` se não seguir o contrato.
  static Failure? failureFrom(Response<dynamic>? response) {
    final body = response?.data;
    if (body is! Map<String, dynamic> || body['error'] is! Map) return null;
    final error = body['error'] as Map<String, dynamic>;
    return Failure.fromApiError(
      statusCode: response!.statusCode,
      code: error['code'] as String?,
      message: error['message'] as String?,
      fields: (error['fields'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v.toString()),
      ),
    );
  }
}
