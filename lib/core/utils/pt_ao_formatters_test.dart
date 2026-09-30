// Testes nesta pasta para respeitar o âmbito autorizado da pista.
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'pt_ao_formatters.dart';

void main() {
  setUpAll(PtAoFormatters.initialize);

  test('Kz preserva cêntimos, sinal, agrupamento e inteiros grandes', () {
    expect(PtAoFormatters.currency(0), '0,00\u00a0Kz');
    expect(PtAoFormatters.currency(1), '0,01\u00a0Kz');
    expect(PtAoFormatters.currency(-1), '-0,01\u00a0Kz');
    expect(PtAoFormatters.currency(123456), '1\u00a0234,56\u00a0Kz');
    expect(
      PtAoFormatters.currency(9007199254740991),
      '90\u00a0071\u00a0992\u00a0547\u00a0409,91\u00a0Kz',
    );
    expect(
      PtAoFormatters.currency(-9007199254740991),
      '-90\u00a0071\u00a0992\u00a0547\u00a0409,91\u00a0Kz',
    );
  });

  test('números usam vírgula decimal e espaço no agrupamento', () {
    expect(PtAoFormatters.number(12345), '12\u00a0345');
    expect(PtAoFormatters.number(1234.5, decimalDigits: 2), '1\u00a0234,50');
    expect(PtAoFormatters.number(-12.345, decimalDigits: 2), '-12,35');
    expect(() => PtAoFormatters.number(1, decimalDigits: -1), throwsRangeError);
    expect(() => PtAoFormatters.number(1, decimalDigits: 21), throwsRangeError);
  });

  test('datas usam dia/mês/ano e relógio de 24 horas sem mudar o fuso', () {
    final value = DateTime.utc(2024, 2, 29, 23, 5);
    expect(PtAoFormatters.date(value), '29/02/2024');
    expect(PtAoFormatters.dateTime(value), '29/02/2024 23:05');
    expect(value.isUtc, isTrue);
  });
}
