import 'dart:typed_data';

import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/campus_model.dart';
import '../data/models/institution_model.dart';

/// Permissões do módulo (a UI esconde, o router bloqueia, o handler valida).
const settingsReadPermission = 'core.settings.read';
const settingsUpdatePermission = 'core.settings.update';

/// Tamanho máximo do logótipo.
const maxLogoBytes = 2 * 1024 * 1024;

/// Cor da marca `#RRGGBB`.
final brandColorPattern = RegExp(r'^#[0-9a-fA-F]{6}$');

abstract interface class SettingsRepository {
  Future<Result<InstitutionModel>> institution();
  Future<Result<InstitutionModel>> updateInstitution(
    Map<String, dynamic> values,
  );

  /// Envia o logótipo (PNG/JPEG até [maxLogoBytes]).
  Future<Result<InstitutionModel>> uploadLogo(Uint8List bytes);
  Future<Result<PagedList<CampusModel>>> campuses({
    int page = 1,
    int pageSize = 100,
  });

  /// Cria (sem [id]) ou actualiza um campus.
  Future<Result<CampusModel>> saveCampus(
    Map<String, dynamic> values, {
    String? id,
  });
  Future<Result<void>> deleteCampus(String id);
}
