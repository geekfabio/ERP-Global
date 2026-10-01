import 'dart:async';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/features/academic/data/models/classroom_models.dart';
import 'package:erp_global/features/academic/data/models/academic_models.dart';
import 'package:erp_global/features/academic/presentation/providers/academic_structure_providers.dart';
import 'package:erp_global/features/grades/presentation/pages/grade_statistics_page.dart';
import 'package:erp_global/features/settings/data/models/academic_year_model.dart';
import 'package:erp_global/features/settings/presentation/providers/academic_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('estado de carregamento não rebenta o layout', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final pending = Completer<List<ClassroomModel>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          classroomListProvider.overrideWith((ref) => pending.future),
          gradeListProvider.overrideWith((ref) async => <GradeModel>[]),
          academicYearsProvider.overrideWith(
            (ref) async => <AcademicYearModel>[],
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: GradeStatisticsPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel('A carregar'), findsOneWidget);
  });
}
