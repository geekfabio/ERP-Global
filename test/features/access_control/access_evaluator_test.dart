import 'package:erp_global/features/access_control/data/models/access_models.dart';
import 'package:erp_global/features/access_control/domain/access_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

const _zone = ZoneModel(id: 'z1', campusId: 'c1', name: 'Portaria');

AccessRuleModel _rule({
  String id = 'r1',
  AccessSubject subject = AccessSubject.student,
  List<int> days = const [1, 2, 3, 4, 5],
  int start = 7 * 60,
  int end = 18 * 60,
  bool activeStudent = false,
  bool financial = false,
  bool isActive = true,
}) => AccessRuleModel(
  id: id,
  zoneId: 'z1',
  name: 'Regra $id',
  subject: subject,
  days: days,
  startMinute: start,
  endMinute: end,
  requireActiveStudent: activeStudent,
  requireFinancialClear: financial,
  isActive: isActive,
);

// 2025-09-01 é uma segunda-feira; 2025-09-06 um sábado.
DateTime _mon(int h, [int m = 0]) => DateTime(2025, 9, 1, h, m);

AccessDecision _eval(
  List<AccessRuleModel> rules,
  DateTime at, {
  AccessSubject subject = AccessSubject.student,
  bool studentActive = true,
  bool financialClear = true,
  ZoneModel? zone = _zone,
}) => evaluateAccess(
  attempt: AccessAttempt(
    zoneId: 'z1',
    at: at,
    subject: subject,
    studentActive: studentActive,
    financialClear: financialClear,
  ),
  zone: zone,
  rules: rules,
);

void main() {
  test('permite dentro da janela; fim é exclusivo', () {
    final rules = [_rule()];
    expect(_eval(rules, _mon(7)).allowed, isTrue);
    expect(_eval(rules, _mon(17, 59)).allowed, isTrue);
    expect(_eval(rules, _mon(18)).reason, AccessReason.outsideSchedule);
    expect(_eval(rules, _mon(6, 59)).reason, AccessReason.outsideSchedule);
  });

  test('nega fora dos dias da regra', () {
    final saturday = DateTime(2025, 9, 6, 10);
    expect(_eval([_rule()], saturday).reason, AccessReason.outsideSchedule);
  });

  test('zona inexistente ou inactiva nega', () {
    expect(
      _eval([_rule()], _mon(9), zone: null).reason,
      AccessReason.zoneInactive,
    );
    expect(
      _eval([_rule()], _mon(9), zone: _zone.copyWith(isActive: false)).reason,
      AccessReason.zoneInactive,
    );
  });

  test('sem regra aplicável ao tipo ou regra inactiva nega', () {
    expect(
      _eval([_rule(subject: AccessSubject.staff)], _mon(9)).reason,
      AccessReason.noRule,
    );
    expect(
      _eval([_rule(isActive: false)], _mon(9)).reason,
      AccessReason.noRule,
    );
    expect(
      _eval(
        [_rule(subject: AccessSubject.all)],
        _mon(9),
        subject: AccessSubject.staff,
      ).allowed,
      isTrue,
    );
  });

  test('exige aluno activo e situação financeira quando configurado', () {
    final rules = [_rule(activeStudent: true, financial: true)];
    expect(_eval(rules, _mon(9)).allowed, isTrue);
    expect(
      _eval(rules, _mon(9), studentActive: false).reason,
      AccessReason.studentInactive,
    );
    expect(
      _eval(rules, _mon(9), financialClear: false).reason,
      AccessReason.financialPending,
    );
  });

  test('basta uma regra satisfeita entre várias', () {
    final strict = _rule(id: 'strict', financial: true);
    final open = _rule(id: 'open', start: 12 * 60, end: 14 * 60);
    expect(
      _eval([strict, open], _mon(9), financialClear: false).allowed,
      isFalse,
    );
    final d = _eval([strict, open], _mon(13), financialClear: false);
    expect(d.allowed, isTrue);
    expect(d.rule?.id, 'open');
  });

  test('formatMinute', () {
    expect(formatMinute(0), '00:00');
    expect(formatMinute(7 * 60 + 5), '07:05');
    expect(formatMinute(1440), '24:00');
  });
}
