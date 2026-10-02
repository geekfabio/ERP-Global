import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';

int _hash(String text) {
  var h = 0x811c9dc5;
  for (final unit in text.codeUnits) {
    h = ((h ^ unit) * 0x01000193) & 0x7fffffff;
  }
  return h;
}

int _pct(int part, int whole) => whole == 0 ? 0 : (part * 100 / whole).round();

/// `GET /v1/reports/academic-overview`: agrega por classe (matrículas, turmas,
/// pautas e presenças) e devolve totais, como o servidor faria. Os valores
/// derivam do período e do campus (sem estado mutável).
class AcademicOverviewMockHandlers {
  const AcademicOverviewMockHandlers({this.enabledModules});

  /// Módulos licenciados; `null` = sem verificação.
  final Set<String> Function()? enabledModules;

  void register(MockApiRegistry r) =>
      r.get('/v1/reports/academic-overview', _overview);

  Map<String, Object?> _period(
    String year,
    String term,
    String campus,
    bool academic,
    bool attendance,
  ) {
    final rows = <Map<String, Object?>>[];
    var enrolled = 0, active = 0, capacity = 0;
    var approvalSum = 0, attendanceSum = 0;
    for (var g = 0; g < MockRef.gradeCount; g++) {
      final key = '$year|$term|$campus|$g';
      final classes = 2 + _hash('c$key') % 2;
      final cap = classes * 40;
      final enr = (cap * (62 + _hash('e$key') % 36) / 100).round();
      final act = enr - _hash('a$key') % 5;
      final approval = 62 + _hash('p$key') % 37;
      final presence = 82 + _hash('t$key') % 17;
      enrolled += enr;
      active += act;
      capacity += cap;
      approvalSum += approval * act;
      attendanceSum += presence * act;
      rows.add({
        'gradeId': MockRef.gradeId(g),
        'label': MockRef.gradeLabel(g),
        'enrolled': enr,
        'active': act,
        'capacity': cap,
        'occupancy': _pct(enr, cap),
        if (academic) 'approvalRate': approval,
        if (attendance) 'attendanceRate': presence,
      });
    }
    return {
      'rows': rows,
      'totals': {
        'enrolled': enrolled,
        'active': active,
        'occupancy': _pct(enrolled, capacity),
        if (academic) 'approvalRate': _pct(approvalSum, active * 100),
        if (attendance) 'attendanceRate': _pct(attendanceSum, active * 100),
      },
    };
  }

  MockResponse _overview(MockRequest q) {
    final yearId = q.query['yearId'];
    if (yearId == null || yearId.isEmpty) {
      throw const MockApiException.validation({'yearId': 'Campo obrigatório'});
    }
    final licensed = enabledModules?.call();
    if (licensed != null && !licensed.contains('students')) {
      throw const MockApiException.moduleNotLicensed();
    }
    final academic = licensed?.contains('academic') ?? true;
    final attendance = licensed?.contains('attendance') ?? true;
    final campus = q.query['campusId'] ?? '';
    final current = _period(
      yearId,
      q.query['termId'] ?? '',
      campus,
      academic,
      attendance,
    );
    final compareYear = q.query['compareYearId'];
    return MockResponse.ok({
      ...current,
      if (compareYear != null)
        'previous': _period(
          compareYear,
          q.query['compareTermId'] ?? '',
          campus,
          academic,
          attendance,
        )['totals'],
    });
  }
}
