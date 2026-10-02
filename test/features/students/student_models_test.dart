import 'package:erp_global/core/utils/json_converters.dart';
import 'package:erp_global/features/students/data/models/enrollment_model.dart';
import 'package:erp_global/features/students/data/models/guardian_model.dart';
import 'package:erp_global/features/students/data/models/student_document_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _base([Map<String, dynamic> extra = const {}]) => {
  'id': '01JSTUDENT0000000000000001',
  'institutionId': '01JINSTITUTION000000000001',
  'createdAt': '2026-01-01T08:00:00+01:00',
  'updatedAt': '2026-01-02T00:00:00Z',
  ...extra,
};

void main() {
  group('StudentModel', () {
    final json = _base({
      'processNumber': '2026/0001',
      'fullName': 'Ana Maria Neto',
      'birthDate': '2010-03-07',
      'gender': 'female',
      'status': 'transferred',
      'health': {
        'bloodType': 'O+',
        'allergies': ['amendoim'],
        'hasSpecialNeeds': true,
      },
    });

    test('lê do JSON com datas UTC e enums', () {
      final s = StudentModel.fromJson(json);
      expect(s.createdAt, DateTime.utc(2026, 1, 1, 7));
      expect(s.createdAt.isUtc, isTrue);
      expect(s.birthDate, DateTime.utc(2010, 3, 7));
      expect(s.gender, Gender.female);
      expect(s.status, StudentStatus.transferred);
      expect(s.health.bloodType, BloodType.oPositive);
      expect(s.health.allergies, ['amendoim']);
      expect(s.nationality, 'Angolana');
      expect(s.syncState, 'synced');
    });

    test('round-trip preserva os dados (incluindo saúde aninhada)', () {
      final s = StudentModel.fromJson(json);
      final again = StudentModel.fromJson(s.toJson());
      expect(again, s);
      expect(s.toJson()['birthDate'], '2010-03-07');
      expect((s.toJson()['health'] as Map)['bloodType'], 'O+');
    });

    test('valores por omissão: activo, saúde vazia', () {
      final s = StudentModel.fromJson(
        _base({
          'processNumber': 'x',
          'fullName': 'Rui',
          'birthDate': '2012-01-31',
          'gender': 'male',
        }),
      );
      expect(s.status, StudentStatus.active);
      expect(s.health.allergies, isEmpty);
      expect(s.health.hasSpecialNeeds, isFalse);
    });

    test('rejeita datas sem fuso (auditoria) e enums desconhecidos', () {
      expect(
        () => StudentModel.fromJson({
          ...json,
          'createdAt': '2026-01-01T08:00:00',
        }),
        throwsFormatException,
      );
      expect(
        () => StudentModel.fromJson({...json, 'status': 'desconhecido'}),
        throwsA(anything),
      );
    });

    test('copyWith e igualdade por valor', () {
      final s = StudentModel.fromJson(json);
      expect(s.copyWith(status: StudentStatus.active), isNot(s));
      expect(s.copyWith(), s);
    });
  });

  group('Guardian e GuardianLink', () {
    test('encarregado', () {
      final g = GuardianModel.fromJson(
        _base({'fullName': 'Maria João', 'phone': '+244923456789'}),
      );
      expect(g.phone, '+244923456789');
      expect(GuardianModel.fromJson(g.toJson()), g);
    });

    test('vínculo com parentesco, flags e validade', () {
      final l = GuardianLinkModel.fromJson(
        _base({
          'studentId': '01JS',
          'guardianId': '01JG',
          'relationship': 'uncle_aunt',
          'isFinancialResponsible': true,
          'canPickup': true,
          'validUntil': '2027-01-01T00:00:00Z',
        }),
      );
      expect(l.relationship, GuardianRelationship.uncleAunt);
      expect(l.isFinancialResponsible, isTrue);
      expect(l.isEmergency, isFalse);
      expect(l.validUntil, DateTime.utc(2027));
      expect(l.toJson()['relationship'], 'uncle_aunt');
      expect(GuardianLinkModel.fromJson(l.toJson()), l);
    });
  });

  group('EnrollmentModel', () {
    test('taxa em int (cêntimos), tipo e estado', () {
      final e = EnrollmentModel.fromJson(
        _base({
          'studentId': '01JS',
          'academicYearId': '01JY',
          'gradeId': '01JC',
          'type': 'new_enrollment',
          'enrolledOn': '2026-01-15',
          'feeMinor': 1500000,
        }),
      );
      expect(e.type, EnrollmentType.newEnrollment);
      expect(e.status, EnrollmentStatus.application);
      expect(e.feeMinor, isA<int>());
      expect(e.feeMinor, 1500000);
      expect(e.enrolledOn, DateTime.utc(2026, 1, 15));
      expect(EnrollmentModel.fromJson(e.toJson()), e);
    });
  });

  group('StudentDocumentModel', () {
    test('documento com validade e verificação', () {
      final d = StudentDocumentModel.fromJson(
        _base({
          'studentId': '01JS',
          'type': 'id_card',
          'fileName': 'bi.pdf',
          'expiresOn': '2030-05-20',
          'verified': true,
          'verifiedBy': '01JU',
          'verifiedAt': '2026-02-01T10:00:00Z',
        }),
      );
      expect(d.type, StudentDocumentType.idCard);
      expect(d.expiresOn, DateTime.utc(2030, 5, 20));
      expect(d.verifiedAt, DateTime.utc(2026, 2, 1, 10));
      expect(StudentDocumentModel.fromJson(d.toJson()), d);
    });

    test('todos os tipos de documento serializam em snake_case', () {
      for (final t in StudentDocumentType.values) {
        final d = StudentDocumentModel.fromJson(
          _base({'studentId': 's', 'type': 'other', 'fileName': 'f'}),
        ).copyWith(type: t);
        final type = d.toJson()['type'] as String;
        expect(type, matches(RegExp(r'^[a-z_]+$')));
        expect(StudentDocumentModel.fromJson(d.toJson()).type, t);
      }
    });
  });

  group('DateOnlyConverter', () {
    const c = DateOnlyConverter();
    test('aceita só datas válidas', () {
      expect(c.fromJson('2024-02-29'), DateTime.utc(2024, 2, 29));
      expect(() => c.fromJson('2023-02-29'), throwsFormatException);
      expect(() => c.fromJson('07/03/2010'), throwsFormatException);
    });

    test('não muda de dia entre fusos', () {
      final d = c.fromJson('2010-03-07');
      expect(c.toJson(d), '2010-03-07');
      expect(c.toJson(DateTime.utc(2010, 3, 7, 23, 59)), '2010-03-07');
    });
  });
}
