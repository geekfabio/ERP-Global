import 'package:erp_global/features/guardians/domain/link_validity.dart';
import 'package:erp_global/features/students/data/models/guardian_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:flutter_test/flutter_test.dart';

GuardianLinkModel _link(DateTime? until) => GuardianLinkModel(
  id: 'l1',
  institutionId: 'i',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  studentId: 's',
  guardianId: 'g',
  relationship: GuardianRelationship.father,
  validUntil: until,
);

void main() {
  final now = DateTime.utc(2026, 6, 15, 10);

  test('sem validUntil o vínculo é activo', () {
    expect(linkValidity(_link(null), now), LinkValidity.active);
  });

  test('longe do fim: activo', () {
    expect(
      linkValidity(_link(DateTime.utc(2026, 12, 31)), now),
      LinkValidity.active,
    );
  });

  test('a terminar nos próximos 30 dias: a expirar', () {
    expect(
      linkValidity(_link(DateTime.utc(2026, 7, 1)), now),
      LinkValidity.expiring,
    );
  });

  test('vale até ao fim do dia indicado', () {
    expect(
      linkValidity(_link(DateTime.utc(2026, 6, 15)), now),
      LinkValidity.expiring,
    );
    expect(
      linkValidity(_link(DateTime.utc(2026, 6, 14)), now),
      LinkValidity.expired,
    );
  });
}
