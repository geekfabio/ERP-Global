import 'package:flutter_test/flutter_test.dart';

import 'contract_target.dart';
import 'mock_contract_target.dart';

/// Mesma seed → mesmos dados (docs/07-mock-api.md); seeds diferentes divergem.
Future<Object?> _snapshot(MockContractTarget target) async {
  final client = await target.open();
  final out = <String, Object?>{};
  for (final path in const [
    '/v1/students',
    '/v1/guardians',
    '/v1/audit-logs',
  ]) {
    final r = await call(client, 'GET', path, query: {'pageSize': 100});
    out[path] = r.data;
  }
  return out;
}

void main() {
  test('mesma seed produz exactamente os mesmos dados', () async {
    expect(
      await _snapshot(MockContractTarget()),
      equals(await _snapshot(MockContractTarget())),
    );
  });

  test('reset repõe um estado idêntico ao seed inicial', () async {
    final client = await MockContractTarget().open();
    final before = await call(
      client,
      'GET',
      '/v1/students',
      query: {'pageSize': 100},
    );
    await call(
      client,
      'POST',
      '/v1/students',
      data: {
        'fullName': 'Aluno Temporario Silva',
        'birthDate': '2012-03-04',
        'gender': 'male',
      },
    );
    await call(client, 'POST', '/__mock/reset');
    final after = await call(
      client,
      'GET',
      '/v1/students',
      query: {'pageSize': 100},
    );
    expect(after.data, equals(before.data));
  });

  test('seeds diferentes produzem alunos diferentes', () async {
    final a = await _snapshot(MockContractTarget(seed: 1));
    final b = await _snapshot(MockContractTarget(seed: 2));
    expect(a, isNot(equals(b)));
  });

  test('o seed tem o volume documentado (~300 alunos)', () async {
    final client = await MockContractTarget().open();
    final r = await call(client, 'GET', '/v1/students', query: {'pageSize': 1});
    expect(r.data!['meta']['total'], 300);
  });
}
