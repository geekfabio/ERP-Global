import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../data/models/license_model.dart';

/// Chave pública Ed25519 embebida na app (base64, 32 bytes). A privada fica só no
/// servidor de licenças. Esta é a chave **de desenvolvimento**; a de produção
/// substitui-se no build (`--dart-define=LICENSE_PUBLIC_KEY=...`).
const devLicensePublicKey = 'CKwkQ2czfaOY7Yf9UOcVFH6M3AaVTQ+WpuTanvIdInw=';

const licensePublicKey = String.fromEnvironment(
  'LICENSE_PUBLIC_KEY',
  defaultValue: devLicensePublicKey,
);

/// Verifica assinaturas de licenças offline (Ed25519).
class LicenseVerifier {
  LicenseVerifier({String publicKeyBase64 = licensePublicKey})
    : _publicKey = SimplePublicKey(
        base64Decode(publicKeyBase64),
        type: KeyPairType.ed25519,
      );

  final SimplePublicKey _publicKey;
  final Ed25519 _algorithm = Ed25519();

  /// `true` só se a assinatura corresponde exactamente ao conteúdo da licença.
  Future<bool> verify(LicenseModel license) async {
    try {
      final signature = Signature(
        base64Decode(license.signature),
        publicKey: _publicKey,
      );
      return await _algorithm.verify(
        license.signedPayload,
        signature: signature,
      );
    } on FormatException {
      return false;
    }
  }
}
