import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/modules/module_registry.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/license/data/mock_api/license_mock_handlers.dart';
import 'package:erp_global/features/license/data/models/license_model.dart';
import 'package:erp_global/features/license/data/repositories/api_license_repository.dart';
import 'package:erp_global/features/license/domain/license_service.dart';
import 'package:erp_global/features/license/domain/license_verifier.dart';
import 'package:erp_global/features/license/presentation/pages/license_page.dart';
import 'package:erp_global/features/license/presentation/providers/license_providers.dart';
import 'package:erp_global/features/license/presentation/providers/license_usage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _ed = Ed25519();
late SimpleKeyPair _keys;
late LicenseVerifier _verifier;

final _now = DateTime.utc(2026, 6, 1);

Map<String, dynamic> _body({
  String plan = 'gestao',
  String expires = '2027-01-01',
  List<String> modules = const ['core', 'students', 'academic'],
  Map<String, int> limits = const {'students': 800, 'users': 12, 'campuses': 2},
  String institution = '01JINSTITUTION000000000001',
}) => {
  'licenseId': '01JLICENSE0000000000000001',
  'institutionId': institution,
  'institutionName': 'Colégio Exemplo',
  'plan': plan,
  'modules': modules,
  'limits': limits,
  'issuedAt': '2026-01-01',
  'expiresAt': expires,
  'graceDays': 30,
};

Future<String> _sign(Map<String, dynamic> body) async {
  final sig = await _ed.sign(
    utf8.encode(LicenseModel.canonicalJson(body)),
    keyPair: _keys,
  );
  return jsonEncode({...body, 'signature': base64Encode(sig.bytes)});
}

ApiClient _client(Ref ref) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: ref.watch(mockApiRegistryProvider),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

Future<void> _pump(
  WidgetTester tester, {
  List<String> permissions = const ['*'],
  String? stored,
  LicenseFilePicker? pickFile,
}) async {
  tester.view.physicalSize = const Size(1600, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final store = InMemoryLicenseStore();
  if (stored != null) await store.writeLicense(stored);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      licenseStoreProvider.overrideWithValue(store),
      licenseServiceProvider.overrideWith(
        (ref) => LicenseService(
          store: store,
          registry: ModuleRegistry(moduleCatalog),
          verifier: _verifier,
          now: () => _now,
        ),
      ),
      licenseMockHandlersProvider.overrideWithValue(
        LicenseMockHandlers(students: () => 790, users: () => 13),
      ),
      mockApiModulesProvider.overrideWith(
        (ref) => [ref.watch(licenseMockHandlersProvider)],
      ),
      apiClientProvider.overrideWith(_client),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: Scaffold(
          body: LicenseOverviewPage(pickFile: pickFile ?? () async => null),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await PtAoFormatters.initialize();
    _keys = await _ed.newKeyPair();
    _verifier = LicenseVerifier(
      publicKeyBase64: base64Encode((await _keys.extractPublicKey()).bytes),
    );
  });

  test('GET /v1/license/usage devolve o consumo dos módulos', () async {
    final container = ProviderContainer(
      overrides: [
        licenseMockHandlersProvider.overrideWithValue(
          LicenseMockHandlers(students: () => 5, users: () => 2),
        ),
        mockApiModulesProvider.overrideWith(
          (ref) => [ref.watch(licenseMockHandlersProvider)],
        ),
        apiClientProvider.overrideWith(_client),
      ],
    );
    addTearDown(container.dispose);
    final usage = await ApiLicenseRepository(
      container.read(apiClientProvider),
    ).usage();
    final u = usage.getOrThrow();
    expect((u.students, u.users, u.campuses, u.devices), (5, 2, 1, 0));
  });

  testWidgets('mostra estado, plano, módulos e consumo face aos limites', (
    tester,
  ) async {
    await _pump(tester, stored: await _sign(_body()));
    expect(find.text('Activa'), findsOneWidget);
    expect(find.text('gestao'), findsOneWidget);
    expect(find.text('Colégio Exemplo'), findsOneWidget);
    expect(find.textContaining('para expirar'), findsOneWidget);
    // Consumo: 790/800 alunos, 13/12 utilizadores (excedido), 1/2 campus.
    expect(find.byKey(const Key('usage_Alunos')), findsOneWidget);
    expect(find.text('790 de 800'), findsOneWidget);
    expect(find.text('13 de 12'), findsOneWidget);
    expect(find.text('1 de 2'), findsOneWidget);
    expect(find.text('0 · Ilimitado'), findsOneWidget); // dispositivos
    expect(
      find.text('Limite excedido: não é possível criar novos registos.'),
      findsOneWidget,
    );
    // Módulos: 3 licenciados, outros incluídos por dependência/obrigatórios.
    expect(find.text('Licenciado'), findsNWidgets(3));
    expect(find.text('Não licenciado'), findsWidgets);
  });

  testWidgets('licença expirada mostra só leitura e permite renovar', (
    tester,
  ) async {
    await _pump(tester, stored: await _sign(_body(expires: '2026-01-31')));
    expect(find.text('Expirada — só leitura'), findsOneWidget);
    expect(find.textContaining('só é possível consultar'), findsOneWidget);
    expect(find.text('Activar licença'), findsOneWidget);
  });

  testWidgets('sem licença guia para a activação', (tester) async {
    await _pump(tester);
    expect(find.text('Sem licença'), findsOneWidget);
    expect(find.textContaining('Active uma licença'), findsWidgets);
  });

  testWidgets('quem não é super_admin não vê o formulário de activação', (
    tester,
  ) async {
    await _pump(
      tester,
      permissions: const ['students.record.read'],
      stored: await _sign(_body()),
    );
    expect(find.text('Activar licença'), findsNothing);
    expect(
      find.text('Só o super administrador pode activar licenças.'),
      findsOneWidget,
    );
  });

  testWidgets('activar licença válida actualiza plano e módulos', (
    tester,
  ) async {
    await _pump(tester, stored: await _sign(_body()));
    final renewed = await _sign(
      _body(plan: 'completo', modules: const ['core', 'students', 'billing']),
    );
    await tester.enterText(find.byType(TextField), renewed);
    await tester.tap(find.text('Activar licença'));
    await tester.pumpAndSettle();
    expect(find.text('completo'), findsOneWidget);
    expect(find.text('Licenciado'), findsNWidgets(3));
  });

  testWidgets(
    'licença adulterada, ilegível ou de outra instituição é rejeitada',
    (tester) async {
      await _pump(tester, stored: await _sign(_body()));
      final tampered = jsonDecode(await _sign(_body())) as Map<String, dynamic>;
      tampered['plan'] = 'hacker';
      final other = await _sign(
        _body(institution: '01JOUTRAINSTITUICAO000001'),
      );
      for (final (input, message) in [
        (jsonEncode(tampered), 'Assinatura inválida'),
        ('isto não é json', 'Licença ilegível'),
        (other, 'Licença de outra instituição'),
      ]) {
        await tester.enterText(find.byType(TextField), input);
        await tester.tap(find.text('Activar licença'));
        await tester.pumpAndSettle();
        expect(find.text(message), findsOneWidget);
        // A licença actual mantém-se.
        expect(find.text('gestao'), findsOneWidget);
      }
    },
  );

  testWidgets('importar ficheiro valida e activa', (tester) async {
    final renewed = await _sign(_body(plan: 'essencial'));
    await _pump(
      tester,
      stored: await _sign(_body()),
      pickFile: () async => renewed,
    );
    await tester.tap(find.text('Importar ficheiro'));
    await tester.pumpAndSettle();
    expect(find.text('essencial'), findsOneWidget);
  });
}
