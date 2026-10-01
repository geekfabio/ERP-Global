import 'dart:convert';
import 'dart:typed_data';

import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/pdf/pdf_file_saver.dart';
import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/presentation/pdf/student_pdf_templates.dart';
import 'package:erp_global/features/students/presentation/providers/student_pdf_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_test/flutter_test.dart';

final _seed = buildStudentsSeed(seed: 42, count: 20);

class _FakeSaver implements PdfFileSaver {
  final saved = <(String, Uint8List)>[];

  @override
  Future<bool> save({
    required String fileName,
    required Uint8List bytes,
  }) async {
    saved.add((fileName, bytes));
    return true;
  }
}

String _head(Uint8List b) => latin1.decode(b.sublist(0, 5));

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('PdfTemplateEngine', () {
    const letterhead = PdfLetterhead(
      institutionName: 'Colégio Teste',
      nif: '5000000000',
      phone: '+244 900 000 000',
    );

    test('gera um PDF válido com cabeçalho e rodapé', () async {
      final student = _seed.students.first;
      final enrollment = _seed.enrollments.firstWhere(
        (e) => e.studentId == student.id,
      );
      final bytes = await const PdfTemplateEngine().render(
        letterhead: letterhead,
        template: EnrollmentSheetTemplate(
          StudentPdfData(student: student, enrollment: enrollment),
        ),
        generatedAt: DateTime.utc(2026, 1, 5, 10),
      );
      expect(_head(bytes), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    });

    test('logótipo inválido não impede a geração', () async {
      final student = _seed.students.first;
      final enrollment = _seed.enrollments.first;
      final bytes = await const PdfTemplateEngine().render(
        letterhead: PdfLetterhead(
          institutionName: 'X',
          logo: Uint8List.fromList([1, 2, 3]),
        ),
        template: EnrollmentContractTemplate(
          StudentPdfData(student: student, enrollment: enrollment),
        ),
        generatedAt: DateTime.utc(2026),
      );
      expect(_head(bytes), '%PDF-');
    });

    test('parseColor aceita #RRGGBB e usa omissão se inválida', () {
      expect(
        PdfTemplateEngine.parseColor('#FF0000'),
        const PdfColor.fromInt(0xFFFF0000),
      );
      expect(
        PdfTemplateEngine.parseColor('azul'),
        PdfTemplateEngine.parseColor(null),
      );
    });

    test('rodapé junta só os contactos disponíveis', () {
      expect(letterhead.footerLine, 'NIF 5000000000  |  +244 900 000 000');
    });
  });

  group('modelos de matrícula', () {
    final student = _seed.students.first;
    final base = _seed.enrollments.firstWhere((e) => e.studentId == student.id);

    test(
      'todos os modelos geram PDF e códigos de verificação distintos',
      () async {
        final data = StudentPdfData(
          student: student,
          enrollment: base.copyWith(feePaid: true, feeMinor: 1500000),
        );
        final codes = <String>{};
        for (final kind in StudentPdfKind.values) {
          final t = kind.template(data);
          codes.add(t.verificationCode);
          final bytes = await const PdfTemplateEngine().render(
            letterhead: const PdfLetterhead(institutionName: 'Colégio'),
            template: t,
            generatedAt: DateTime.utc(2026),
          );
          expect(_head(bytes), '%PDF-', reason: kind.name);
          expect(t.fileName, contains(student.processNumber));
        }
        expect(codes, hasLength(StudentPdfKind.values.length));
      },
    );

    test('comprovativo só existe com a taxa paga', () {
      expect(
        StudentPdfKind.receipt.isAvailableFor(base.copyWith(feePaid: false)),
        isFalse,
      );
      expect(
        StudentPdfKind.receipt.isAvailableFor(base.copyWith(feePaid: true)),
        isTrue,
      );
      expect(
        StudentPdfKind.contract.isAvailableFor(base.copyWith(feePaid: false)),
        isTrue,
      );
    });

    test('pickEnrollment ignora matrículas anuladas e rejeitadas', () {
      final cancelled = base.copyWith(
        id: 'a',
        status: EnrollmentStatus.cancelled,
      );
      final ok = base.copyWith(id: 'b', status: EnrollmentStatus.confirmed);
      expect(StudentPdfService.pickEnrollment([cancelled, ok])?.id, 'b');
      expect(StudentPdfService.pickEnrollment([cancelled]), isNull);
    });
  });

  group('StudentPdfService', () {
    ProviderContainer container(_FakeSaver saver) {
      final c = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(const ['students.*']),
          studentPdfSaverProvider.overrideWithValue(saver),
          mockApiModulesProvider.overrideWith(
            (ref) => [StudentsMockHandlers(count: 20)],
          ),
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
      );
      addTearDown(c.dispose);
      return c;
    }

    test('exporta a ficha via Api...Repository e guarda o PDF', () async {
      final saver = _FakeSaver();
      final c = container(saver);
      final student = _seed.students.first;
      await c
          .read(studentPdfServiceProvider)
          .export(student, StudentPdfKind.enrollmentSheet);
      expect(saver.saved, hasLength(1));
      expect(saver.saved.single.$1, startsWith('ficha-matricula-'));
      expect(_head(saver.saved.single.$2), '%PDF-');
    });
  });
}
