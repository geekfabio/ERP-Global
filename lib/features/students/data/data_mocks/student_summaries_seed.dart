import 'dart:math';

import '../models/student_summaries_model.dart';

/// Gera, de forma determinística a partir do id do aluno, as vistas que a ficha
/// pede aos módulos de notas, presenças, financeiro e cartões (mesmo aluno →
/// mesmos dados). `now` fixa a data de referência.
class StudentSummariesSeed {
  StudentSummariesSeed({DateTime? now})
    : _now = (now ?? DateTime.now()).toUtc();

  final DateTime _now;

  Random _rng(String studentId, String salt) {
    var h = 17;
    for (final c in '$studentId/$salt'.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return Random(h);
  }

  DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  static const _subjects = [
    'Língua Portuguesa',
    'Matemática',
    'Ciências da Natureza',
    'História',
    'Geografia',
    'Educação Física',
  ];

  StudentGradesSummary grades(String studentId) {
    final r = _rng(studentId, 'grades');
    double? mark(int base) => (base + r.nextInt(7)).toDouble();
    final year = _now.year;
    return StudentGradesSummary(
      subjects: [
        for (final s in _subjects)
          SubjectGrades(
            subject: s,
            term1: mark(8),
            term2: mark(8),
            // O 3.º trimestre ainda não tem notas.
            term3: null,
          ),
      ],
      bulletins: [
        BulletinRef(
          id: 'bol-1-$studentId',
          label: '1.º trimestre',
          issuedOn: DateTime.utc(year - 1, 12, 15),
        ),
        BulletinRef(
          id: 'bol-2-$studentId',
          label: '2.º trimestre',
          issuedOn: DateTime.utc(year, 3, 28),
        ),
      ],
    );
  }

  StudentAttendanceSummary attendance(String studentId) {
    final r = _rng(studentId, 'attendance');
    final records = <AttendanceRecord>[];
    var day = _day(_now);
    while (records.length < 40) {
      day = day.subtract(const Duration(days: 1));
      if (day.weekday > DateTime.friday) continue;
      final roll = r.nextInt(100);
      records.add(
        AttendanceRecord(
          date: day,
          kind: roll < 82
              ? AttendanceKind.present
              : roll < 90
              ? AttendanceKind.late
              : roll < 96
              ? AttendanceKind.justified
              : AttendanceKind.unjustified,
        ),
      );
    }
    return StudentAttendanceSummary(records: records);
  }

  StudentFinanceSummary finance(String studentId) {
    final r = _rng(studentId, 'finance');
    final fee = 1500000 + r.nextInt(5) * 250000; // propina mensal em cêntimos
    final today = _day(_now);
    final charges = <StudentChargeLine>[];
    for (var m = 0; m < 6; m++) {
      final due = DateTime.utc(today.year, today.month - 3 + m, 5);
      final paid = due.isBefore(today.subtract(const Duration(days: 20)))
          ? r.nextInt(100) < 85
          : false;
      charges.add(
        StudentChargeLine(
          id: 'ch-$m-$studentId',
          description:
              'Propina ${due.month.toString().padLeft(2, '0')}/${due.year}',
          dueOn: due,
          amountMinor: fee,
          paidMinor: paid ? fee : 0,
          status: paid
              ? StudentChargeStatus.paid
              : due.isBefore(today)
              ? StudentChargeStatus.overdue
              : StudentChargeStatus.open,
        ),
      );
    }
    return StudentFinanceSummary(
      charges: charges,
      discountPercent: r.nextInt(100) < 15 ? 20 : 0,
    );
  }

  StudentCardSummary card(String studentId) {
    final r = _rng(studentId, 'card');
    final at = DateTime.utc(_now.year, _now.month, _now.day, 7, 20);
    return StudentCardSummary(
      cardNumber: 'CT-${(100000 + r.nextInt(899999))}',
      status: StudentCardStatus.active,
      mealBalanceMinor: r.nextInt(400) * 100,
      recentAccess: [
        for (var i = 0; i < 6; i++)
          AccessEvent(
            at: at
                .subtract(Duration(days: i ~/ 2))
                .add(i.isEven ? Duration.zero : const Duration(hours: 6)),
            direction: i.isEven ? AccessDirection.entry : AccessDirection.exit,
            gate: 'Portão principal',
          ),
      ],
    );
  }
}
