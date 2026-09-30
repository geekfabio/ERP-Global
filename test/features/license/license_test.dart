import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/modules/module_registry.dart';
import 'package:erp_global/features/license/data/models/license_model.dart';
import 'package:erp_global/features/license/domain/license_service.dart';
import 'package:erp_global/features/license/domain/license_status.dart';
import 'package:erp_global/features/license/domain/license_verifier.dart';
import 'package:flutter_test/flutter_test.dart';

final _ed = Ed25519();
late SimpleKeyPair _keys;
late LicenseVerifier _verifier;

Map<String, dynamic> _body({
  String expires = '2027-01-01',
  int grace = 30,
  List<String> modules = const ['core', 'students', 'academic'],
  Map<String, int> limits = const {'students': 800, 'users': 60},
  String institution = '01JINSTITUTION000000000001',
}) => {
  'licenseId': '01JLICENSE0000000000000001',
  'institutionId': institution,
  'institutionName': 'Colégio Exemplo',
  'plan': 'gestao',
  'modules': modules,
  'limits': limits,
  'issuedAt': '2026-01-01',
  'expiresAt': expires,
  'graceDays': grace,
};

Future<String> _sign(Map<String, dynamic> body, {SimpleKeyPair? with_}) async {
  final sig = await _ed.sign(
    utf8.encode(LicenseModel.canonicalJson(body)),
    keyPair: with_ ?? _keys,
  );
  return jsonEncode({...body, 'signature': base64Encode(sig.bytes)});
}

LicenseService _service(LicenseStore store, DateTime Function() now) =>
    LicenseService(
      store: store,
      registry: ModuleRegistry(moduleCatalog),
      verifier: _verifier,
      now: now,
    );

void main() {
  setUpAll(() async {
    _keys = await _ed.newKeyPair();
    _verifier = LicenseVerifier(
      publicKeyBase64: base64Encode((await _keys.extractPublicKey()).bytes),
    );
  });

  group('assinatura', () {
    test('licença válida é aceite', () async {
      final l = LicenseModel.parse(await _sign(_body()));
      expect(await _verifier.verify(l), isTrue);
      expect(l.modules, ['core', 'students', 'academic']);
      expect(l.limits.students, 800);
      expect(l.expiresAt, DateTime.utc(2027, 1, 1));
    });

    test('licença adulterada é rejeitada (módulo acrescentado)', () async {
      final signed = jsonDecode(await _sign(_body())) as Map<String, dynamic>;
      (signed['modules'] as List).add('billing');
      final l = LicenseModel.fromJson(signed);
      expect(await _verifier.verify(l), isFalse);
    });

    test('adulterada: data e limites alterados', () async {
      for (final change in <void Function(Map<String, dynamic>)>[
        (m) => m['expiresAt'] = '2099-01-01',
        (m) => (m['limits'] as Map)['students'] = 99999,
        (m) => m['campo_novo'] = 'x',
      ]) {
        final signed = jsonDecode(await _sign(_body())) as Map<String, dynamic>;
        change(signed);
        expect(await _verifier.verify(LicenseModel.fromJson(signed)), isFalse);
      }
    });

    test('assinada com outra chave é rejeitada', () async {
      final other = await _ed.newKeyPair();
      final l = LicenseModel.parse(await _sign(_body(), with_: other));
      expect(await _verifier.verify(l), isFalse);
    });

    test('assinatura malformada é rejeitada sem lançar', () async {
      final signed = jsonDecode(await _sign(_body())) as Map<String, dynamic>;
      signed['signature'] = '###não-base64###';
      expect(await _verifier.verify(LicenseModel.fromJson(signed)), isFalse);
    });

    test('a ordem das chaves não afecta a assinatura', () async {
      final reordered = Map.fromEntries(_body().entries.toList().reversed);
      final l = LicenseModel.parse(await _sign(_body()));
      final signature = jsonDecode(await _sign(_body()))['signature'];
      final l2 = LicenseModel.fromJson({...reordered, 'signature': signature});
      expect(await _verifier.verify(l), isTrue);
      expect(await _verifier.verify(l2), isTrue);
    });

    test('a chave de desenvolvimento embebida tem 32 bytes', () {
      expect(base64Decode(devLicensePublicKey), hasLength(32));
    });
  });

  group('parser', () {
    test('rejeita documentos inválidos', () {
      expect(() => LicenseModel.parse('[]'), throwsFormatException);
      expect(() => LicenseModel.parse('{}'), throwsFormatException);
      expect(() => LicenseModel.parse('nao json'), throwsFormatException);
    });
  });

  group('estados (datas, graça, recuo do relógio)', () {
    late LicenseModel license;
    setUp(() async {
      license = LicenseModel.parse(await _sign(_body(expires: '2027-01-01')));
    });

    test('activa até ao fim do último dia', () {
      final s = evaluateLicense(license, now: DateTime.utc(2027, 1, 1, 23, 59));
      expect(s.state, LicenseState.active);
      expect(s.canWrite, isTrue);
    });

    test('em graça após expirar, com aviso e escrita permitida', () {
      final s = evaluateLicense(license, now: DateTime.utc(2027, 1, 10));
      expect(s.state, LicenseState.grace);
      expect(s.daysLeft, inInclusiveRange(20, 25));
      expect(s.canWrite, isTrue);
    });

    test('só leitura depois da graça, sem perda de leitura', () {
      final s = evaluateLicense(license, now: DateTime.utc(2027, 3, 1));
      expect(s.state, LicenseState.readOnly);
      expect(s.canRead, isTrue);
      expect(s.canWrite, isFalse);
      expect(s.isReadOnly, isTrue);
    });

    test('recuo do relógio é detectado; pequena correcção é tolerada', () {
      final seen = DateTime.utc(2026, 6, 10);
      final back = evaluateLicense(
        license,
        now: DateTime.utc(2026, 1, 5),
        lastSeen: seen,
      );
      expect(back.state, LicenseState.clockTampered);
      expect(back.canWrite, isFalse);
      final tolerated = evaluateLicense(
        license,
        now: seen.subtract(const Duration(hours: 2)),
        lastSeen: seen,
      );
      expect(tolerated.state, LicenseState.active);
    });
  });

  group('LicenseService (offline)', () {
    test('sem licença → missing e nenhum módulo activo', () async {
      final s = _service(
        InMemoryLicenseStore(),
        () => DateTime.utc(2026, 5, 1),
      );
      expect((await s.load()).state, LicenseState.missing);
      expect(s.enabledModules, isEmpty);
    });

    test('activar guarda e load repõe; módulos incluem dependências', () async {
      final store = InMemoryLicenseStore();
      final s = _service(store, () => DateTime.utc(2026, 5, 1));
      final r = await s.activate(await _sign(_body(modules: ['grades'])));
      expect(r, isA<Activated>());
      // grades → academic → students → core
      expect(s.enabledModules, {'core', 'students', 'academic', 'grades'});
      expect(s.isModuleEnabled('billing'), isFalse);
      expect(s.licenseDependencyProblems, isNotEmpty);

      final again = _service(store, () => DateTime.utc(2026, 5, 2));
      expect((await again.load()).state, LicenseState.active);
    });

    test('activar licença adulterada é rejeitado e mantém a actual', () async {
      final s = _service(
        InMemoryLicenseStore(),
        () => DateTime.utc(2026, 5, 1),
      );
      await s.activate(await _sign(_body()));
      final tampered = jsonDecode(await _sign(_body())) as Map<String, dynamic>
        ..['plan'] = 'completo';
      final r = await s.activate(jsonEncode(tampered));
      expect(r, isA<ActivationRejected>());
      expect(s.license?.plan, 'gestao');
      expect(await s.activate('lixo'), isA<ActivationRejected>());
    });

    test('recusa licença de outra instituição', () async {
      final s = _service(
        InMemoryLicenseStore(),
        () => DateTime.utc(2026, 5, 1),
      );
      await s.activate(await _sign(_body()));
      final r = await s.activate(await _sign(_body(institution: 'OUTRA')));
      expect(r, isA<ActivationRejected>());
    });

    test(
      'limites impedem novos registos mas não bloqueiam se ilimitado',
      () async {
        final s = _service(
          InMemoryLicenseStore(),
          () => DateTime.utc(2026, 5, 1),
        );
        await s.activate(await _sign(_body()));
        expect(s.limitOf('students'), 800);
        expect(s.canAdd('students', 799), isTrue);
        expect(s.canAdd('students', 800), isFalse);
        expect(s.canAdd('campuses', 1000), isTrue); // sem limite contratado
      },
    );

    test('após a graça: só leitura e sem novos registos', () async {
      final store = InMemoryLicenseStore();
      await _service(
        store,
        () => DateTime.utc(2026, 5, 1),
      ).activate(await _sign(_body(expires: '2026-06-01', grace: 10)));
      final s = _service(store, () => DateTime.utc(2026, 8, 1));
      expect((await s.load()).state, LicenseState.readOnly);
      expect(s.canAdd('students', 0), isFalse);
      expect(s.enabledModules, isNotEmpty); // dados continuam acessíveis
    });

    test('recuo do relógio após uso normal → clockTampered', () async {
      final store = InMemoryLicenseStore();
      final s1 = _service(store, () => DateTime.utc(2026, 9, 1));
      await s1.activate(await _sign(_body()));
      final s2 = _service(store, () => DateTime.utc(2026, 3, 1));
      expect((await s2.load()).state, LicenseState.clockTampered);
      expect(s2.canAdd('students', 0), isFalse);
    });

    test('licença guardada e adulterada no armazenamento → invalid', () async {
      final store = InMemoryLicenseStore();
      final tampered = jsonDecode(await _sign(_body())) as Map<String, dynamic>
        ..['expiresAt'] = '2099-01-01';
      await store.writeLicense(jsonEncode(tampered));
      final s = _service(store, () => DateTime.utc(2026, 5, 1));
      expect((await s.load()).state, LicenseState.invalid);
      expect(s.enabledModules, isEmpty);
    });
  });
}
