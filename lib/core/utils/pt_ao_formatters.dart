import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Formatação de apresentação; não altera datas nem valores persistidos.
abstract final class PtAoFormatters {
  static const locale = 'pt_AO';

  /// Deve ser aguardado antes de apresentar datas.
  static Future<void> initialize() => initializeDateFormatting(locale);

  /// Recebe cêntimos e mantém toda a aritmética monetária em inteiros.
  static String currency(int minorUnits) {
    final value = BigInt.from(minorUnits);
    final absolute = value.abs();
    final whole = (absolute ~/ BigInt.from(100)).toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '\u00a0',
    );
    final cents = (absolute % BigInt.from(100)).toString().padLeft(2, '0');
    return '${value.isNegative ? '-' : ''}$whole,$cents\u00a0Kz';
  }

  /// Números gerais, sem conversão monetária.
  static String number(num value, {int decimalDigits = 0}) {
    RangeError.checkValueInInterval(decimalDigits, 0, 20, 'decimalDigits');
    // O intl não inclui símbolos pt_AO; pt_PT partilha os separadores usados
    // em Angola, enquanto o fallback genérico pt usa agrupamento brasileiro.
    final formatter = NumberFormat.decimalPattern('pt_PT')
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  /// Usa a data recebida; o chamador escolhe explicitamente o fuso horário.
  static String date(DateTime value) =>
      DateFormat('dd/MM/yyyy', locale).format(value);

  static String dateTime(DateTime value) =>
      DateFormat('dd/MM/yyyy HH:mm', locale).format(value);
}
