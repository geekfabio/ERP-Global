import 'dart:convert';
import 'dart:typed_data';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/import_export/data/mock_api/import_mock_handlers.dart';
import 'package:erp_global/features/import_export/presentation/pages/import_page.dart';
import 'package:erp_global/features/import_export/presentation/providers/import_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _csv =
    'Nome;Nascimento;Sexo;BI\n'
    'Ana Paulo;12/03/2012;F;004567890LA041\n'
    'Bruno Dias;10/10/2011;M;004567890LA041\n'
    'Carla;99/99/2010;F;\n';

void main() {
  testWidgets('nada é gravado antes de confirmar; BI duplicado é rejeitado', (
    tester,
  ) async {
    await PtAoFormatters.initialize();
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final handlers = ImportMockHandlers();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(const [
            'import_export.*',
          ]),
          importMockHandlersProvider.overrideWithValue(handlers),
          mockApiModulesProvider.overrideWith((ref) => [handlers]),
          apiClientProvider.overrideWith(
            (ref) => ApiClient.create(
              baseUrl: 'https://api.test',
              useMockApi: true,
              registry: ref.watch(mockApiRegistryProvider),
              mockConfig: const MockApiConfig.instant(),
              logging: false,
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          scaffoldMessengerKey: rootMessengerKey,
          home: Scaffold(
            body: ImportPage(
              pickFile: () async =>
                  ('alunos.csv', Uint8List.fromList(utf8.encode(_csv))),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Escolher ficheiro'));
    await tester.pumpAndSettle();
    expect(find.textContaining('3 linhas'), findsOneWidget);

    await tester.tap(find.text('Pré-visualizar'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('2 linhas válidas · 1 com erros'),
      findsOneWidget,
    );
    expect(find.text('Descarregar relatório de erros'), findsOneWidget);
    expect(handlers.stored('students'), isEmpty);

    await tester.tap(find.text('Confirmar importação (2)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 registos importados'), findsOneWidget);
    expect(find.textContaining('BI já registado'), findsOneWidget);
    expect(handlers.stored('students'), hasLength(1));
  });
}
