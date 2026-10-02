/// Converte texto digitado (`1 234,56`, `1234.5`, `500 Kz`) em cêntimos (`int`).
/// Devolve `null` se o texto não for um valor monetário válido (>2 decimais, letras).
/// Nunca usa `double`: dinheiro é sempre `int` na menor unidade.
int? parseMinorUnits(String input) {
  var text = input.replaceAll(RegExp(r'[\s ]|Kz', caseSensitive: false), '');
  if (text.isEmpty) return null;
  var negative = false;
  if (text.startsWith('-')) {
    negative = true;
    text = text.substring(1);
  }
  if (!RegExp(r'^[0-9.,]+$').hasMatch(text)) return null;

  String whole;
  var frac = '';
  if (text.contains(',')) {
    // Vírgula = decimal; pontos = milhares.
    final parts = text.split(',');
    if (parts.length != 2) return null;
    whole = parts[0].replaceAll('.', '');
    frac = parts[1];
  } else {
    final dot = text.lastIndexOf('.');
    final isDecimal =
        dot >= 0 && text.indexOf('.') == dot && text.length - dot - 1 <= 2;
    whole = isDecimal ? text.substring(0, dot) : text.replaceAll('.', '');
    frac = isDecimal ? text.substring(dot + 1) : '';
  }
  if (whole.isEmpty) whole = '0';
  if (frac.length > 2 || !RegExp(r'^[0-9]*$').hasMatch(whole + frac)) {
    return null;
  }
  final cents = int.tryParse(whole)! * 100 + int.parse(frac.padRight(2, '0'));
  return negative ? -cents : cents;
}
