/// Seed das regras (formato do futuro backend). Percentagens em pontos base
/// (1400 = 14 %); dinheiro na menor unidade.
List<Map<String, dynamic>> rulesSeed() => [
  _int('academic', 'minPassingGrade', 10, 0, 100),
  _int('academic', 'gradeScaleMax', 20, 1, 100),
  _int('academic', 'termCount', 3, 2, 4),
  _int('academic', 'maxAbsences', 30, 0, 365),
  _text('finance', 'currency', 'AOA', const ['AOA', 'USD', 'EUR']),
  _int('finance', 'lateFeeBp', 200, 0, 10000),
  _int('finance', 'lateFeeFixed', 0, 0, 100000000),
  _int('finance', 'lateInterestMonthlyBp', 100, 0, 10000),
  _int('finance', 'graceDays', 5, 0, 90),
  _int('tax', 'vatRateBp', 1400, 0, 10000),
  {
    'key': 'vatExemptionEnabled',
    'module': 'tax',
    'type': 'boolean',
    'value': true,
    'options': <String>[],
  },
  _text('tax', 'vatExemptionReason', 'M10 — Isento (Art. 12.º do CIVA)', null),
];

Map<String, dynamic> _int(String module, String key, int v, int min, int max) =>
    {
      'key': key,
      'module': module,
      'type': 'integer',
      'value': v,
      'min': min,
      'max': max,
      'options': <String>[],
    };

Map<String, dynamic> _text(
  String module,
  String key,
  String v,
  List<String>? options,
) => {
  'key': key,
  'module': module,
  'type': options == null ? 'text' : 'choice',
  'value': v,
  'options': options ?? <String>[],
};
