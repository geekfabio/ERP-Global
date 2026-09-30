import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:erp_global/app/app.dart';

void main() {
  testWidgets('app arranca em /login (única rota pública)', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ErpGlobalApp()));
    await tester.pumpAndSettle();
    expect(find.text('ERP-Global'), findsWidgets);
  });
}
