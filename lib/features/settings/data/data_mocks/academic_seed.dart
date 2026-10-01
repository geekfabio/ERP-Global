import '../../../../core/network/mock/mock_reference_data.dart';
import '../../domain/academic_rules.dart';

String _termId(String code, int i) =>
    '01JTERM${code.substring(0, 4)}${code.substring(5)}0000000${i}A'.padRight(
      26,
      '0',
    );

Map<String, dynamic> _year(
  String id,
  String code,
  String status,
  List<String> termStatuses,
) {
  final start = int.parse(code.substring(0, 4));
  return {
    'id': id,
    'institutionId': MockRef.institutionId,
    'campusId': MockRef.campusId,
    'code': code,
    'startDate': '$start-09-01',
    'endDate': '${start + 1}-07-31',
    'status': status,
  };
}

/// Três anos: encerrado, activo (o de [MockRef.academicYearId]) e planeado.
List<Map<String, dynamic>> academicYearSeed() => [
  _year('01JYEAR202420250000000001A', '2024/2025', 'closed', []),
  _year(MockRef.academicYearId, '2025/2026', 'active', []),
  _year('01JYEAR202620270000000001A', '2026/2027', 'planned', []),
];

/// Períodos por ano: 2024/2025 todos fechados; 2025/2026 com o 1.º fechado, o
/// 2.º aberto e o 3.º por abrir; 2026/2027 por abrir.
List<Map<String, dynamic>> termSeed() {
  const states = {
    '2024/2025': ['closed', 'closed', 'closed'],
    '2025/2026': ['closed', 'open', 'closed'],
    '2026/2027': ['closed', 'closed', 'closed'],
  };
  const everClosed = {
    '2024/2025': [true, true, true],
    '2025/2026': [true, false, false],
    '2026/2027': [false, false, false],
  };
  final terms = <Map<String, dynamic>>[];
  for (final year in academicYearSeed()) {
    final code = year['code']! as String;
    final start = DateTime.parse(year['startDate']! as String);
    final end = DateTime.parse(year['endDate']! as String);
    final ranges = splitYear(start, end, 3);
    for (var i = 0; i < 3; i++) {
      String d(DateTime v) => v.toIso8601String().substring(0, 10);
      terms.add({
        'id': _termId(code, i + 1),
        'academicYearId': year['id'],
        'name': defaultTermName(i, 3),
        'order': i + 1,
        'startDate': d(ranges[i].start),
        'endDate': d(ranges[i].end),
        'gradesDeadline': d(ranges[i].end),
        'status': states[code]![i],
        'closedAt': everClosed[code]![i]
            ? '${d(ranges[i].end)}T12:00:00.000Z'
            : null,
      });
    }
  }
  return terms;
}
