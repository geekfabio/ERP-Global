import 'dart:typed_data';

import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/core/widgets/table/app_data_table.dart';
import 'package:erp_global/core/widgets/table/export_button.dart';
import 'package:erp_global/core/widgets/table/table_controller.dart';
import 'package:erp_global/features/import_export/data/export/export_file.dart';
import 'package:erp_global/features/import_export/data/export/export_file_saver.dart';
import 'package:erp_global/features/import_export/presentation/providers/export_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

class _Saver implements ExportFileSaver {
  final saved = <ExportFile>[];
  bool cancel = false;

  @override
  Future<bool> save(ExportFile file) async {
    saved.add(file);
    return !cancel;
  }
}

const _perm = 'things.record.export';

final _columns = <ExportColumn<String>>[
  ExportColumn(key: 'name', label: 'Nome', text: (s) => s),
];

List<Override> _overrides(
  List<String> perms,
  _Saver saver, {
  bool on = true,
}) => [
  sessionPermissionsProvider.overrideWithValue(perms),
  licenseGateProvider.overrideWithValue(
    LicenseGate(enabledModules: {if (on) 'import_export'}),
  ),
  exportHandlerProvider.overrideWith((ref) => ref.watch(exportRunnerProvider)),
  exportFileSaverProvider.overrideWithValue(saver),
];

Future<void> _pump(WidgetTester tester, List<Override> overrides) async {
  final c = TableController<String>(
    rows: ['a', 'b', 'c'],
    columns: [AppColumn(label: 'Nome', text: (s) => s)],
    rowId: (s) => s,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        scaffoldMessengerKey: rootMessengerKey,
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => Column(
              children: [
                ExportButton(
                  permission: _perm,
                  dataset: () => ExportDataset.from<String>(
                    title: 'Coisas',
                    entity: 'things',
                    permission: _perm,
                    columns: _columns,
                    rows: const ['x', 'y'],
                  ),
                ),
                Expanded(
                  child: AppDataTable<String>(
                    controller: c,
                    onExport: exportHookFor<String>(
                      context,
                      ref,
                      permission: _perm,
                      title: 'Coisas',
                      entity: 'things',
                      columns: _columns,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sem permissão export não há botão (nem na tabela)', (
    tester,
  ) async {
    await _pump(tester, _overrides(['things.record.read'], _Saver()));
    expect(find.byTooltip('Exportar'), findsNothing);
  });

  testWidgets('módulo import_export desligado: sem botão', (tester) async {
    await _pump(tester, _overrides(['things.*'], _Saver(), on: false));
    expect(find.byTooltip('Exportar'), findsNothing);
  });

  testWidgets('botão do menu exporta no formato escolhido', (tester) async {
    final saver = _Saver();
    await _pump(tester, _overrides(['things.record.export'], saver));
    await tester.tap(find.byType(PopupMenuButton<ExportFormat>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CSV'));
    await tester.pumpAndSettle();
    expect(saver.saved, hasLength(1));
    expect(saver.saved.single.fileName, endsWith('.csv'));
    expect(saver.saved.single.rowCount, 2);
    expect(saver.saved.single.bytes, isA<Uint8List>());
  });

  testWidgets('hook da AppDataTable pede formato e exporta as linhas', (
    tester,
  ) async {
    final saver = _Saver();
    await _pump(tester, _overrides(['things.record.export'], saver));
    await tester.tap(find.byTooltip('Exportar').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excel'));
    await tester.pumpAndSettle();
    expect(saver.saved.single.rowCount, 3);
    expect(saver.saved.single.fileName, endsWith('.xlsx'));
  });

  testWidgets('cancelar o "guardar como" não avisa sucesso', (tester) async {
    final saver = _Saver()..cancel = true;
    await _pump(tester, _overrides(['things.record.export'], saver));
    await tester.tap(find.byType(PopupMenuButton<ExportFormat>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CSV'));
    await tester.pumpAndSettle();
    expect(find.textContaining('exportados'), findsNothing);
  });
}
