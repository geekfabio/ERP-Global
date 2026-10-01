import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/import_mock_handlers.dart';
import '../../data/repositories/api_import_repository.dart';
import '../../domain/import_engine.dart';
import '../../domain/import_profile.dart';
import '../../domain/import_repository.dart';
import '../../domain/import_table.dart';
import '../../domain/profiles/guardians_import_profile.dart';
import '../../domain/profiles/students_import_profile.dart';

final importRepositoryProvider = Provider<ImportRepository>(
  (ref) => ApiImportRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final importMockHandlersProvider = Provider<ImportMockHandlers>(
  (ref) => ImportMockHandlers(),
);

/// Perfis disponíveis. Outros módulos acrescentam os seus por `overrideWith`.
final importProfilesProvider = Provider<List<ImportProfile>>(
  (ref) => const [StudentsImportProfile(), GuardiansImportProfile()],
);

enum ImportStep { file, mapping, preview, done }

class ImportState {
  const ImportState({
    required this.profile,
    this.step = ImportStep.file,
    this.fileName,
    this.table,
    this.mapping = const {},
    this.preview,
    this.result,
    this.busy = false,
    this.error,
  });

  final ImportProfile profile;
  final ImportStep step;
  final String? fileName;
  final ImportTable? table;
  final ColumnMapping mapping;
  final ImportPreview? preview;
  final ImportCommitResult? result;
  final bool busy;
  final String? error;

  ImportState copyWith({
    ImportStep? step,
    ColumnMapping? mapping,
    ImportPreview? preview,
    ImportCommitResult? result,
    bool? busy,
    String? error,
  }) => ImportState(
    profile: profile,
    step: step ?? this.step,
    fileName: fileName,
    table: table,
    mapping: mapping ?? this.mapping,
    preview: preview ?? this.preview,
    result: result ?? this.result,
    busy: busy ?? this.busy,
    error: error,
  );
}

/// Fluxo ficheiro → mapeamento → pré-visualização → confirmação.
/// Nada é enviado à API antes de [confirm].
class ImportController extends Notifier<ImportState> {
  static const _engine = ImportEngine();

  @override
  ImportState build() =>
      ImportState(profile: ref.read(importProfilesProvider).first);

  void selectProfile(ImportProfile profile) =>
      state = ImportState(profile: profile);

  void loadFile(String name, Uint8List bytes) {
    final profile = state.profile;
    try {
      final table = ImportTable.fromBytes(name, bytes);
      state = ImportState(
        profile: profile,
        step: ImportStep.mapping,
        fileName: name,
        table: table,
        mapping: _engine.autoMap(profile, table.headers),
      );
    } on FormatException catch (e) {
      state = ImportState(profile: profile, error: e.message);
    }
  }

  void setMapping(String key, int? column) =>
      state = state.copyWith(mapping: {...state.mapping, key: column});

  bool get canPreview =>
      _engine.missingRequired(state.profile, state.mapping).isEmpty;

  void buildPreview() {
    if (!canPreview) return;
    state = state.copyWith(
      step: ImportStep.preview,
      preview: _engine.validate(state.profile, state.table!, state.mapping),
    );
  }

  void back() => state = state.copyWith(
    step: state.step == ImportStep.preview
        ? ImportStep.mapping
        : ImportStep.file,
  );

  String errorReport() => _engine.errorReportCsv(state.profile, state.preview!);

  /// Grava só as linhas válidas, depois da confirmação do utilizador.
  Future<void> confirm() async {
    final valid = state.preview!.valid;
    if (valid.isEmpty || state.busy) return;
    state = state.copyWith(busy: true);
    final result = await ref.read(importRepositoryProvider).commit(
      state.profile.entity,
      [for (final r in valid) r.record],
    );
    state = result.when(
      ok: (v) => state.copyWith(busy: false, step: ImportStep.done, result: v),
      err: (f) => state.copyWith(busy: false, error: f.message),
    );
  }

  void reset() => state = ImportState(profile: state.profile);
}

final importControllerProvider =
    NotifierProvider.autoDispose<ImportController, ImportState>(
      ImportController.new,
    );
