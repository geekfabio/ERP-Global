import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Guarda um PDF gerado. `false` = utilizador cancelou.
abstract interface class PdfFileSaver {
  Future<bool> save({required String fileName, required Uint8List bytes});
}

/// Diálogo "Guardar como" do sistema.
class PickerPdfFileSaver implements PdfFileSaver {
  const PickerPdfFileSaver();

  @override
  Future<bool> save({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final saved = await FilePicker.saveFile(
      fileName: '$fileName.pdf',
      bytes: bytes,
      mimeType: 'application/pdf',
    );
    return saved != null;
  }
}
