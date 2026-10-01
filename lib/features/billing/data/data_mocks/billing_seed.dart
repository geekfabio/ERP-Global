import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/utils/seed_generator.dart';
import '../models/billing_enums.dart';
import '../models/fee_item.dart';

/// Preços de desenvolvimento: matrícula (todos os campus) e propina por campus,
/// para as 14 classes do ano lectivo activo. Valores em cêntimos.
List<FeeItem> buildFeeItemSeed({int seed = 53}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 8, 1);
  final items = <FeeItem>[];
  for (var g = 0; g < MockRef.gradeCount; g++) {
    for (final (type, campusId, amount) in [
      (FeeType.enrollment, null, 1500000 + g * 50000),
      (FeeType.tuition, MockRef.campusId, 2500000 + g * 150000),
    ]) {
      items.add(
        FeeItem(
          id: gen.ulid(at.add(Duration(minutes: items.length))),
          institutionId: MockRef.institutionId,
          campusId: campusId,
          createdAt: at,
          updatedAt: at,
          academicYearId: MockRef.academicYearId,
          gradeId: MockRef.gradeId(g),
          type: type,
          amountMinor: amount,
        ),
      );
    }
  }
  return items;
}
