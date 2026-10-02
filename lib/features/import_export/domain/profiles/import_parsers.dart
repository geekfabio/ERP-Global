// Conversores partilhados pelos perfis de importação (pt-AO).

import '../../../../core/widgets/inputs/money_parser.dart';

/// Lista separada por `|`, `;` ou `/` (ex.: `MAT|FIS`).
List<String> parseImportList(String raw) {
  final items = [
    for (final s in raw.split(RegExp(r'[|;/]')))
      if (s.trim().isNotEmpty) s.trim(),
  ];
  if (items.isEmpty) throw const FormatException('Lista vazia');
  return items;
}

int parsePositiveInt(String raw) {
  final n = int.tryParse(raw.trim());
  if (n == null || n <= 0) {
    throw const FormatException('Indique um número inteiro maior que zero');
  }
  return n;
}

String parseImportShift(String raw) => switch (raw.toLowerCase()) {
  'manhã' || 'manha' || 'morning' => 'morning',
  'tarde' || 'afternoon' => 'afternoon',
  'noite' || 'nocturno' || 'noturno' || 'evening' => 'evening',
  _ => throw const FormatException('Turno inválido (Manhã, Tarde ou Noite)'),
};

/// Nota decimal com vírgula ou ponto (`14,5`), entre 0 e 100.
double parseImportScore(String raw) {
  final n = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (n == null || n.isNaN || n < 0 || n > 100) {
    throw const FormatException('Nota inválida (use um valor como 14,5)');
  }
  return n;
}

/// Valor em kwanzas (`25 000,50`) → cêntimos, sem `double`.
int parseImportMoney(String raw) =>
    parseMinorUnits(raw) ?? (throw const FormatException('Valor inválido'));

String parsePaymentMethod(String raw) => switch (raw.toLowerCase()) {
  'numerário' || 'numerario' || 'dinheiro' || 'cash' => 'cash',
  'transferência' ||
  'transferencia' ||
  'transferência bancária' ||
  'banktransfer' => 'bankTransfer',
  'cartão' || 'cartao' || 'multicaixa' || 'card' => 'card',
  'referência' || 'referencia' || 'paymentreference' => 'paymentReference',
  _ => throw const FormatException(
    'Método inválido (Numerário, Transferência, Cartão ou Referência)',
  ),
};

DateTime parseImportDate(String raw) {
  final br = RegExp(r'^(\d{1,2})[/.-](\d{1,2})[/.-](\d{4})$').firstMatch(raw);
  final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);
  final (y, m, d) = br != null
      ? (int.parse(br[3]!), int.parse(br[2]!), int.parse(br[1]!))
      : iso != null
      ? (int.parse(iso[1]!), int.parse(iso[2]!), int.parse(iso[3]!))
      : throw const FormatException('Data inválida (use dd/MM/aaaa)');
  final date = DateTime.utc(y, m, d);
  if (date.month != m || date.day != d) {
    throw const FormatException('Data inexistente');
  }
  return date;
}

String parseImportGender(String raw) => switch (raw.toLowerCase()) {
  'm' || 'masculino' => 'male',
  'f' || 'feminino' => 'female',
  _ => throw const FormatException('Use M ou F'),
};

/// BI angolano: 9 dígitos, 2 letras, 3 dígitos.
String parseAngolanBi(String raw) {
  final bi = raw.replaceAll(RegExp(r'\s'), '').toUpperCase();
  if (!RegExp(r'^\d{9}[A-Z]{2}\d{3}$').hasMatch(bi)) {
    throw const FormatException('BI inválido (9 dígitos, 2 letras, 3 dígitos)');
  }
  return bi;
}

/// Telemóvel angolano, com ou sem +244.
String parseAngolanPhone(String raw) {
  final phone = raw.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^(\+244)?9\d{8}$').hasMatch(phone)) {
    throw const FormatException('Telefone inválido');
  }
  return phone;
}

String parseEmail(String raw) {
  final email = raw.trim().toLowerCase();
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    throw const FormatException('E-mail inválido');
  }
  return email;
}

/// Parentesco (rótulo pt-AO ou chave) → chave de `GuardianRelationship`.
String parseRelationship(String raw) => switch (raw.toLowerCase()) {
  'pai' || 'father' => 'father',
  'mãe' || 'mae' || 'mother' => 'mother',
  'tutor' => 'tutor',
  'avô' || 'avó' || 'avo' || 'avô/avó' || 'grandparent' => 'grandparent',
  'irmão' || 'irmã' || 'irmao' || 'irmão/irmã' || 'sibling' => 'sibling',
  'tio' || 'tia' || 'tio/tia' || 'uncleaunt' => 'uncleAunt',
  'outro' || 'other' => 'other',
  _ => throw const FormatException(
    'Parentesco inválido (ex.: Pai, Mãe, Tutor)',
  ),
};
