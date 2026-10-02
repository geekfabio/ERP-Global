import 'package:erp_global/app/app.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sem sessão a app arranca em /login (única rota pública)', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
        ],
        child: const ErpGlobalApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Entre na sua conta'), findsOneWidget);
  });
}
