// ignore_for_file: avoid_print
// Gerador de licenças ASSINADAS para desenvolvimento e testes.
//
//   dart run tool/generate_license.dart --public-key
//   dart run tool/generate_license.dart --institution "Colégio Exemplo" \
//       --plan gestao --modules core,students,academic --expires 2027-01-01 \
//       --grace 30 --students 800 --users 60 --campuses 2 --devices 5
//
// ⚠ SÓ DESENVOLVIMENTO: a chave privada abaixo é uma seed pública, determinística,
// usada apenas com a chave pública de desenvolvimento embebida na app. Em produção
// a chave privada existe só no servidor de licenças e a pública é injectada com
// `--dart-define=LICENSE_PUBLIC_KEY=<base64>`.
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:erp_global/features/license/data/models/license_model.dart';

// 32 bytes ASCII: seed de desenvolvimento (não é um segredo).
const _devSeed = 'erp-global-dev-license-seed-0000';

Future<void> main(List<String> args) async {
  final opts = _parse(args);
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(utf8.encode(_devSeed));
  final publicKey = await keyPair.extractPublicKey();

  if (opts.containsKey('public-key')) {
    print(base64Encode(publicKey.bytes));
    return;
  }

  final now = DateTime.now().toUtc();
  String day(DateTime d) => d.toIso8601String().substring(0, 10);
  final body = <String, dynamic>{
    'licenseId': opts['id'] ?? '01JDEVLICENSE0000000000001',
    'institutionId': opts['institution-id'] ?? '01JINSTITUTION000000000001',
    'institutionName': opts['institution'] ?? 'Colégio Exemplo',
    'plan': opts['plan'] ?? 'gestao',
    'modules': (opts['modules'] ?? 'core,students,guardians,academic,grades')
        .split(','),
    'limits': {
      for (final k in ['campuses', 'students', 'users', 'devices'])
        if (opts.containsKey(k)) k: int.parse(opts[k]!),
    },
    'issuedAt': opts['issued'] ?? day(now),
    'expiresAt': opts['expires'] ?? day(now.add(const Duration(days: 365))),
    'graceDays': int.parse(opts['grace'] ?? '30'),
  };
  final signature = await algorithm.sign(
    utf8.encode(LicenseModel.canonicalJson(body)),
    keyPair: keyPair,
  );
  body['signature'] = base64Encode(signature.bytes);
  print(const JsonEncoder.withIndent('  ').convert(body));
}

Map<String, String> _parse(List<String> args) {
  final out = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    if (!args[i].startsWith('--')) continue;
    final key = args[i].substring(2);
    final hasValue = i + 1 < args.length && !args[i + 1].startsWith('--');
    out[key] = hasValue ? args[++i] : '';
  }
  return out;
}
