import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/pdf/pdf_template.dart';
import 'settings_providers.dart';

/// Converte a identidade guardada em Definições no cabeçalho usado por todos
/// os documentos. Assim, uma alteração de logótipo, cor ou contactos chega a
/// boletins, pautas, recibos, facturas, fichas, certificados e cartões.
class InstitutionPdfLetterhead {
  InstitutionPdfLetterhead(this._ref);

  final Ref _ref;

  Future<PdfLetterhead> load() async {
    try {
      final institution = await _ref.read(institutionProvider.future);
      if (institution != null) {
        return PdfLetterhead(
          institutionName: institution.name,
          nif: institution.nif,
          address: institution.address,
          phone: institution.phone,
          email: institution.email,
          brandColor: institution.brandColor,
          logo: _decodeLogo(institution.logoUrl),
        );
      }
    } on Object {
      // O documento continua disponível a perfis sem leitura das definições.
    }
    return const PdfLetterhead(institutionName: 'Instituição');
  }

  static Uint8List? _decodeLogo(String? value) {
    if (value == null) return null;
    final comma = value.indexOf(',');
    if (!value.startsWith('data:image/') || comma < 0) return null;
    try {
      return base64Decode(value.substring(comma + 1));
    } on FormatException {
      return null;
    }
  }
}

final institutionPdfLetterheadProvider = Provider<InstitutionPdfLetterhead>(
  InstitutionPdfLetterhead.new,
);
