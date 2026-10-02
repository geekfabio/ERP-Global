import 'package:dio/dio.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_target.dart';
import 'mock_contract_target.dart';

final _ulid = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');

/// Rotas de listagem que têm de cumprir paginação/envelope (docs/07-mock-api.md).
const contractListPaths = ['/v1/students', '/v1/guardians', '/v1/audit-logs'];

/// Suite de contrato partilhada: os mesmos testes correm contra qualquer
/// [ContractTarget] (mock hoje, servidor real depois). Só asserta o que o
/// contrato garante — nada de dados do seed.
void runApiContractSuite(ContractTarget target) {
  group('contrato API — ${target.name}', () {
    late ApiClient client;

    setUp(() async => client = await target.open());

    group('envelope', () {
      for (final path in contractListPaths) {
        test('GET $path → {data: [], meta} com pageSize respeitado', () async {
          final r = await call(client, 'GET', path, query: {'pageSize': 5});
          expect(r.statusCode, 200);
          final body = r.data!;
          expect(body['data'], isA<List<dynamic>>());
          expect((body['data'] as List<dynamic>).length, lessThanOrEqualTo(5));
          final meta = body['meta'] as Map<String, dynamic>;
          expect(meta['page'], 1);
          expect(meta['pageSize'], 5);
          expect(meta['total'], isA<int>());
          expect(body.containsKey('error'), isFalse);
        });

        test('GET $path página 2 não repete a página 1', () async {
          final p1 = await call(
            client,
            'GET',
            path,
            query: {'pageSize': 5, 'page': 1},
          );
          final p2 = await call(
            client,
            'GET',
            path,
            query: {'pageSize': 5, 'page': 2},
          );
          expect(
            _ids(p1.data!['data']).intersection(_ids(p2.data!['data'])),
            isEmpty,
          );
          expect(p2.data!['meta']['page'], 2);
        });

        test('GET $path com pageSize inválido → 422', () async {
          final r = await call(client, 'GET', path, query: {'pageSize': -1});
          expect(r.statusCode, 422);
          expect(r.data!['error']['code'], 'VALIDATION_ERROR');
        });
      }

      test('rota inexistente → 404 NOT_FOUND com envelope de erro', () async {
        final r = await call(client, 'GET', '/v1/nao-existe');
        expect(r.statusCode, 404);
        expect(r.data!['error']['code'], 'NOT_FOUND');
        expect(r.data!['error']['message'], isA<String>());
      });
    });

    group('autenticação (só login)', () {
      test(
        'login válido devolve tokens, utilizador, perfis e licença',
        () async {
          final r = await _login(client);
          expect(r.statusCode, 200);
          final data = r.data!['data'] as Map<String, dynamic>;
          expect(data['accessToken'], isA<String>());
          expect(data['refreshToken'], isA<String>());
          expect(data['expiresIn'], isA<int>());
          expect(data['user'], isA<Map<String, dynamic>>());
          expect(data['roles'], contains('super_admin'));
          expect(data['permissions'], isA<List<dynamic>>());
          expect(data['license'], isA<Map<String, dynamic>>());
        },
      );

      test('credenciais erradas → 401 INVALID_CREDENTIALS', () async {
        final r = await call(
          client,
          'POST',
          '/v1/auth/login',
          data: {'identifier': contractAdmin.identifier, 'password': 'errada'},
        );
        expect(r.statusCode, 401);
        expect(r.data!['error']['code'], 'INVALID_CREDENTIALS');
      });

      test('login sem campos → 422 com fields', () async {
        final r = await call(client, 'POST', '/v1/auth/login', data: {});
        expect(r.statusCode, 422);
        final fields = r.data!['error']['fields'] as Map<String, dynamic>;
        expect(fields.keys, containsAll(['identifier', 'password']));
      });

      test('/auth/me com token devolve a sessão; sem token → 401', () async {
        final anonymous = await call(client, 'GET', '/v1/auth/me');
        expect(anonymous.statusCode, 401);
        expect(anonymous.data!['error']['code'], 'UNAUTHENTICATED');

        final login = await _login(client);
        final token = login.data!['data']['accessToken'] as String;
        final me = await client.dio.get<Map<String, dynamic>>(
          '/v1/auth/me',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (_) => true,
          ),
        );
        expect(me.statusCode, 200);
        expect(me.data!['data']['user'], isA<Map<String, dynamic>>());
      });

      test('refresh roda o token; o refresh antigo deixa de valer', () async {
        final login = await _login(client);
        final refresh = login.data!['data']['refreshToken'] as String;
        final first = await call(
          client,
          'POST',
          '/v1/auth/refresh',
          data: {'refreshToken': refresh},
        );
        expect(first.statusCode, 200);
        expect(first.data!['data']['accessToken'], isA<String>());
        final replay = await call(
          client,
          'POST',
          '/v1/auth/refresh',
          data: {'refreshToken': refresh},
        );
        expect(replay.statusCode, 401);
      });

      test('não existe registo nem recuperação auto-serviço', () async {
        for (final path in const [
          '/v1/auth/register',
          '/v1/auth/signup',
          '/v1/auth/forgot-password',
        ]) {
          final r = await call(client, 'POST', path, data: {});
          expect(r.statusCode, isIn([403, 404, 405]), reason: path);
        }
      });
    });

    group('alunos (CRUD)', () {
      Map<String, dynamic> newStudent([String name = 'Contrato Teste Silva']) =>
          {'fullName': name, 'birthDate': '2012-03-04', 'gender': 'female'};

      test('POST cria (201), GET lê, PATCH edita, DELETE remove', () async {
        final created = await call(
          client,
          'POST',
          '/v1/students',
          data: newStudent(),
        );
        expect(created.statusCode, 201);
        final student = created.data!['data'] as Map<String, dynamic>;
        final id = student['id'] as String;
        expect(id, matches(_ulid));
        expect(student['fullName'], 'Contrato Teste Silva');

        final read = await call(client, 'GET', '/v1/students/$id');
        expect(read.statusCode, 200);
        expect(read.data!['data']['id'], id);

        final patched = await call(
          client,
          'PATCH',
          '/v1/students/$id',
          data: {'fullName': 'Contrato Editado Silva'},
        );
        expect(patched.statusCode, 200);
        expect(patched.data!['data']['fullName'], 'Contrato Editado Silva');
        expect(patched.data!['data']['id'], id);

        final deleted = await call(client, 'DELETE', '/v1/students/$id');
        expect(deleted.statusCode, 200);
      });

      test('POST inválido → 422 com campos em erro', () async {
        final r = await call(
          client,
          'POST',
          '/v1/students',
          data: {'fullName': 'ab'},
        );
        expect(r.statusCode, 422);
        expect(r.data!['error']['code'], 'VALIDATION_ERROR');
        expect(r.data!['error']['fields'], isA<Map<String, dynamic>>());
      });

      test('GET de id desconhecido → 404 NOT_FOUND', () async {
        final r = await call(
          client,
          'GET',
          '/v1/students/01ARZ3NDEKTSV4RRFFQ69G5FAV',
        );
        expect(r.statusCode, 404);
        expect(r.data!['error']['code'], 'NOT_FOUND');
      });

      test('ordenação por sort=fullName / -fullName', () async {
        final asc = await _names(client, 'fullName');
        final desc = await _names(client, '-fullName');
        expect(asc.length, greaterThan(1));
        expect(_isSorted(asc, descending: false), isTrue);
        expect(_isSorted(desc, descending: true), isTrue);
      });

      test('pesquisa q devolve só correspondências', () async {
        await call(
          client,
          'POST',
          '/v1/students',
          data: newStudent('Zzyzx Contrato Unico'),
        );
        final r = await call(
          client,
          'GET',
          '/v1/students',
          query: {'q': 'zzyzx'},
        );
        final items = (r.data!['data'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        expect(items, isNotEmpty);
        expect(
          items.every(
            (s) => '${s['fullName']}'.toLowerCase().contains('zzyzx'),
          ),
          isTrue,
        );
        expect(r.data!['meta']['total'], items.length);
      });

      test(
        'mutações persistem na sessão e /__mock/reset repõe o seed',
        () async {
          final before = await _total(client);
          await call(client, 'POST', '/v1/students', data: newStudent());
          expect(await _total(client), before + 1);
          await call(client, 'POST', '/__mock/reset');
          expect(await _total(client), before);
        },
        skip: target is MockContractTarget
            ? null
            : 'só existe no adaptador mock',
      );
    });
  });
}

Future<Response<Map<String, dynamic>>> _login(ApiClient client) => call(
  client,
  'POST',
  '/v1/auth/login',
  data: {
    'identifier': contractAdmin.identifier,
    'password': contractAdmin.password,
  },
);

Set<String> _ids(Object? data) => {
  for (final item in data! as List<dynamic>)
    (item as Map<String, dynamic>)['id'] as String,
};

bool _isSorted(List<String> names, {required bool descending}) {
  final keys = [for (final n in names) n.toLowerCase()];
  for (var i = 1; i < keys.length; i++) {
    final c = keys[i - 1].compareTo(keys[i]);
    if (descending ? c < 0 : c > 0) return false;
  }
  return true;
}

Future<int> _total(ApiClient client) async {
  final r = await call(client, 'GET', '/v1/students', query: {'pageSize': 1});
  return r.data!['meta']['total'] as int;
}

Future<List<String>> _names(ApiClient client, String sort) async {
  final r = await call(
    client,
    'GET',
    '/v1/students',
    query: {'pageSize': 30, 'sort': sort},
  );
  return [
    for (final s in r.data!['data'] as List<dynamic>)
      (s as Map<String, dynamic>)['fullName'] as String,
  ];
}
