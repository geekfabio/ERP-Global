import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/api_envelope.dart';
import 'package:erp_global/core/network/mock/mock_api_adapter.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_query.dart';
import 'package:erp_global/core/network/mock/mock_types.dart';
import 'package:erp_global/core/network/mock/mock_validator.dart';
import 'package:flutter_test/flutter_test.dart';

class _Item {
  const _Item(this.id, this.name, this.grade);
  final int id;
  final String name;
  final int grade;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'grade': grade};
}

final _items = [
  const _Item(1, 'João Silva', 10),
  const _Item(2, 'Ana Neto', 14),
  const _Item(3, 'Joana Kiala', 14),
  const _Item(4, 'Pedro Gomes', 8),
  const _Item(5, 'Maria Lopes', 17),
];

const _spec = MockListSpec<_Item>(
  sortable: {'name': _name, 'grade': _grade},
  filterable: {'grade': _grade},
  searchText: _nameText,
  defaultSort: ['name'],
);
Comparable<Object?> _name(_Item i) => i.name;
String _nameText(_Item i) => i.name;
Comparable<Object?> _grade(_Item i) => i.grade;

ApiClient _client(MockApiRegistry registry, {MockApiConfig? config}) =>
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: config ?? const MockApiConfig.instant(),
      logging: false,
    );

void main() {
  late MockApiRegistry registry;
  late ApiClient client;
  var counter = 0;

  setUp(() {
    counter = 0;
    registry = MockApiRegistry()
      ..get(
        '/v1/items',
        (r) => mockPaginate(_items, r, toJson: (i) => i.toJson(), spec: _spec),
      )
      ..get('/v1/items/{id}', (r) {
        final id = int.parse(r.params['id']!);
        final item = _items.where((i) => i.id == id).firstOrNull;
        if (item == null) throw const MockApiException.notFound();
        return MockResponse.ok(item.toJson());
      })
      ..post('/v1/items', (r) {
        MockValidator(r.jsonBody)
          ..required('name')
          ..email('email')
          ..throwIfInvalid();
        counter++;
        return MockResponse.created({'id': counter});
      })
      ..onReset(() => counter = 0);
    client = _client(registry);
  });

  group('envelope', () {
    test('GET /v1/health responde com envelope e latência', () async {
      final c = _client(
        registry,
        config: MockApiConfig(
          seed: 1,
          minLatency: const Duration(milliseconds: 150),
          maxLatency: const Duration(milliseconds: 600),
          sleep: (_) async {},
        ),
      );
      final r = await c.dio.get<dynamic>('/v1/health');
      final data = ApiEnvelope.data(r)! as Map<String, dynamic>;
      expect(data['status'], 'ok');
      expect(data['latencyMs'], inInclusiveRange(150, 600));
      expect(r.data, isNot(contains('meta')));
    });

    test('sucesso de lista traz data e meta', () async {
      final r = await client.dio.get<dynamic>('/v1/items');
      final page = ApiEnvelope.page(r, (j) => j['name'] as String);
      expect(page.items.length, 5);
      expect(page.meta.total, 5);
      expect(page.meta.page, 1);
      expect(page.meta.pageSize, 20);
    });

    test('rota inexistente → 404 NOT_FOUND como Failure', () async {
      final result = await Result.guard(() => client.dio.get<dynamic>('/nada'));
      expect(result.failureOrNull?.code, 'NOT_FOUND');
    });
  });

  group('paginação, ordenação, filtros e pesquisa', () {
    Future<List<String>> names(Map<String, dynamic> q) async {
      final r = await client.dio.get<dynamic>('/v1/items', queryParameters: q);
      return ApiEnvelope.page(r, (j) => j['name'] as String).items;
    }

    test('página e tamanho', () async {
      final r = await client.dio.get<dynamic>(
        '/v1/items',
        queryParameters: {'page': 2, 'pageSize': 2},
      );
      final page = ApiEnvelope.page(r, (j) => j['name'] as String);
      expect(page.items, ['João Silva', 'Maria Lopes']); // ordem por nome
      expect(page.meta.total, 5);
      expect(page.meta.totalPages, 3);
      expect(page.meta.hasNext, isTrue);
    });

    test('ordenação múltipla com sinal -', () async {
      expect(await names({'sort': '-grade,name'}), [
        'Maria Lopes',
        'Ana Neto',
        'Joana Kiala',
        'João Silva',
        'Pedro Gomes',
      ]);
    });

    test('filtro e pesquisa sem acentos', () async {
      expect(await names({'filter[grade]': '14'}), ['Ana Neto', 'Joana Kiala']);
      expect(await names({'q': 'joao'}), ['João Silva']);
    });

    test('parâmetros inválidos → 422 por campo', () async {
      final r = await Result.guard(
        () => client.dio.get<dynamic>(
          '/v1/items',
          queryParameters: {'page': 0, 'sort': 'x', 'filter[y]': '1'},
        ),
      );
      final f = r.failureOrNull! as ValidationFailure;
      expect(f.fields.keys, containsAll(['page', 'sort', 'filter[y]']));
    });
  });

  group('erros', () {
    test('404 do handler, com parâmetro de rota', () async {
      final ok = await client.dio.get<dynamic>('/v1/items/2');
      expect((ApiEnvelope.data(ok)! as Map)['name'], 'Ana Neto');
      final r = await Result.guard(
        () => client.dio.get<dynamic>('/v1/items/9'),
      );
      expect(r.failureOrNull?.code, 'NOT_FOUND');
    });

    test('422 de validação com fields', () async {
      final r = await Result.guard(
        () => client.dio.post<dynamic>('/v1/items', data: {'email': 'mau'}),
      );
      final f = r.failureOrNull! as ValidationFailure;
      expect(f.fields['name'], 'Campo obrigatório');
      expect(f.fields['email'], 'Formato inválido');
    });

    test('excepção inesperada num handler → 500', () async {
      registry.get('/v1/boom', (_) => throw StateError('x'));
      final r = await Result.guard(() => client.dio.get<dynamic>('/v1/boom'));
      expect(r.failureOrNull?.code, 'INTERNAL_ERROR');
    });

    test('403 de licença e 409 mapeiam para o Failure certo', () async {
      registry
        ..get(
          '/v1/lic',
          (_) => throw const MockApiException.moduleNotLicensed(),
        )
        ..get('/v1/dup', (_) => throw const MockApiException.conflict());
      final lic = await Result.guard(() => client.dio.get<dynamic>('/v1/lic'));
      expect(lic.failureOrNull, isA<LicenseFailure>());
      final dup = await Result.guard(() => client.dio.get<dynamic>('/v1/dup'));
      expect(dup.failureOrNull?.code, 'CONFLICT');
    });

    test('chaos gera falhas 5xx/timeout mas poupa health', () async {
      final c = _client(
        registry,
        config: const MockApiConfig.instant(chaos: true, seed: 7),
      );
      var failures = 0;
      for (var i = 0; i < 40; i++) {
        final r = await Result.guard(() => c.dio.get<dynamic>('/v1/items'));
        if (r.isErr) failures++;
      }
      expect(failures, greaterThan(0));
      expect(failures, lessThan(40));
      final health = await c.dio.get<dynamic>('/v1/health');
      expect(health.statusCode, 200);
    });
  });

  group('estado e reset', () {
    test('POST /__mock/reset repõe o estado dos módulos', () async {
      await client.dio.post<dynamic>('/v1/items', data: {'name': 'A'});
      await client.dio.post<dynamic>('/v1/items', data: {'name': 'B'});
      expect(counter, 2);
      await client.dio.post<dynamic>('/__mock/reset');
      expect(counter, 0);
    });
  });

  group('auth', () {
    test('TOKEN_EXPIRED faz refresh e repete o pedido', () async {
      var valid = 'new';
      var refreshCalls = 0;
      registry
        ..post('/v1/auth/refresh', (r) {
          refreshCalls++;
          expect(r.jsonBody['refreshToken'], 'r1');
          return MockResponse.ok({
            'accessToken': 'new',
            'refreshToken': 'r2',
            'expiresIn': 900,
          });
        })
        ..get('/v1/secure', (r) {
          if (r.headers['Authorization'] != 'Bearer $valid') {
            throw const MockApiException.tokenExpired();
          }
          return MockResponse.ok({'ok': true});
        });
      client.tokens.save(accessToken: 'old', refreshToken: 'r1');

      final res = await client.dio.get<dynamic>('/v1/secure');
      expect(res.statusCode, 200);
      expect(refreshCalls, 1);
      expect(client.tokens.accessToken, 'new');
      expect(client.tokens.refreshToken, 'r2');
    });

    test('refresh falhado limpa tokens e devolve AuthFailure', () async {
      registry
        ..post(
          '/v1/auth/refresh',
          (_) => throw const MockApiException.unauthenticated(),
        )
        ..get('/v1/secure', (_) => throw const MockApiException.tokenExpired());
      client.tokens.save(accessToken: 'old', refreshToken: 'r1');
      final r = await Result.guard(() => client.dio.get<dynamic>('/v1/secure'));
      expect(r.failureOrNull, isA<AuthFailure>());
      expect(client.tokens.accessToken, isNull);
    });
  });

  group('useMockApi', () {
    test('false muda só o adaptador', () {
      final real = ApiClient.create(
        baseUrl: 'https://api.test',
        useMockApi: false,
        logging: false,
      );
      expect(real.isMock, isFalse);
      expect(real.dio.httpClientAdapter, isNot(isA<MockApiAdapter>()));
      expect(real.dio.options.baseUrl, client.dio.options.baseUrl);
      expect(client.isMock, isTrue);
      expect(real.dio.interceptors.length, client.dio.interceptors.length);
    });
  });
}
