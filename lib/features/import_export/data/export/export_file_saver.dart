import 'package:file_picker/file_picker.dart';

import 'export_file.dart';

/// Guarda o ficheiro exportado. `false` = utilizador cancelou.
abstract interface class ExportFileSaver {
  Future<bool> save(ExportFile file);
}

/// Diálogo "Guardar como" do sistema.
class PickerExportFileSaver implements ExportFileSaver {
  const PickerExportFileSaver();

  @override
  Future<bool> save(ExportFile file) async {
    final saved = await FilePicker.saveFile(
      fileName: file.fileName,
      bytes: file.bytes,
      mimeType: file.format.mimeType,
    );
    return saved != null;
  }
}
