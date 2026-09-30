import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/core/widgets/permissions/can.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/auth_test_helpers.dart';

Widget _wrap(List<String> perms, Widget child) => ProviderScope(
  overrides: permissionsOnly(perms),
  child: MaterialApp(home: Scaffold(body: child)),
);

void main() {
  testWidgets('Can mostra o filho só com permissão', (tester) async {
    const button = Text('APAGAR');
    await tester.pumpWidget(
      _wrap([
        'students.record.delete',
      ], const Can(permission: 'students.record.delete', child: button)),
    );
    expect(find.text('APAGAR'), findsOneWidget);

    await tester.pumpWidget(
      _wrap([
        'students.record.read',
      ], const Can(permission: 'students.record.delete', child: button)),
    );
    expect(find.text('APAGAR'), findsNothing);
  });

  testWidgets('Can usa fallback quando negado', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const [],
        const Can(
          permission: 'billing.invoice.void',
          fallback: Text('SEM ACESSO'),
          child: Text('ANULAR'),
        ),
      ),
    );
    expect(find.text('SEM ACESSO'), findsOneWidget);
    expect(find.text('ANULAR'), findsNothing);
  });

  testWidgets('Can respeita o âmbito', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: permissionsOnly(['grades.entry.write']),
        child: const MaterialApp(
          home: Can(
            permission: 'grades.entry.write',
            scope: PermissionScope(classroomId: 'T1'),
            child: Text('LANCAR'),
          ),
        ),
      ),
    );
    // Concessão sem âmbito vale em qualquer turma.
    expect(find.text('LANCAR'), findsOneWidget);
  });

  testWidgets('Restricted mostra desactivado com dica quando negado', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        const [],
        Restricted(
          permission: 'students.record.delete',
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('X'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('X'), warnIfMissed: false);
    expect(taps, 0);
    expect(find.byType(Tooltip), findsOneWidget);
  });

  testWidgets('Restricted deixa passar com permissão', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        ['students.record.delete'],
        Restricted(
          permission: 'students.record.delete',
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('X'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('X'));
    expect(taps, 1);
  });
}
