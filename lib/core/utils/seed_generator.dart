import 'seeded_random.dart';

enum SeedGender { male, female }

/// Gerador determinístico de dados plausíveis angolanos (nomes, BI, telefone, ULID).
/// Reutilizável pelas fixtures de todos os módulos: `SeedGenerator(42)`.
class SeedGenerator {
  SeedGenerator(int seed) : random = SeededRandom(seed);

  final SeededRandom random;

  static const maleNames = [
    'António',
    'Manuel',
    'João',
    'José',
    'Pedro',
    'Paulo',
    'Domingos',
    'Francisco',
    'Miguel',
    'Sebastião',
    'Augusto',
    'Carlos',
    'Fernando',
    'Mário',
    'Joaquim',
    'Adão',
    'Bento',
    'Eduardo',
    'Job',
    'Kiala',
  ];
  static const femaleNames = [
    'Maria',
    'Ana',
    'Luísa',
    'Isabel',
    'Teresa',
    'Joana',
    'Esperança',
    'Filomena',
    'Madalena',
    'Rosa',
    'Beatriz',
    'Celeste',
    'Domingas',
    'Graça',
    'Helena',
    'Lurdes',
    'Natália',
    'Paula',
    'Sandra',
    'Vitória',
  ];
  static const surnames = [
    'Silva',
    'dos Santos',
    'Fernandes',
    'Neto',
    'Mendes',
    'Domingos',
    'Cardoso',
    'Gomes',
    'Pereira',
    'Baptista',
    'Sebastião',
    'Lopes',
    'Cabral',
    'Van-Dúnem',
    'Kiala',
    'Ngola',
    'Tchissola',
    'Kamuenho',
    'Manuel',
    'Francisco',
    'Miguel',
    'António',
    'Vieira',
    'Chipenda',
    'Sambo',
    'Quiosa',
    'Bravo',
    'Pinto',
    'Rodrigues',
    'Costa',
  ];
  static const _provinceCodes = [
    'LA',
    'BE',
    'BG',
    'CB',
    'CC',
    'CN',
    'CS',
    'HL',
    'HM',
    'LN',
    'LS',
    'ML',
    'MX',
    'NM',
    'UE',
    'ZA',
    'BO',
    'CU',
  ];
  static const _crockford = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  SeedGender gender() =>
      random.chance(0.5) ? SeedGender.male : SeedGender.female;

  String firstName(SeedGender gender) =>
      random.pick(gender == SeedGender.male ? maleNames : femaleNames);

  /// Nome completo: 1 nome próprio + 1 ou 2 apelidos.
  String fullName([SeedGender? gender]) {
    final g = gender ?? this.gender();
    final surnameCount = random.chance(0.6) ? 2 : 1;
    return [
      firstName(g),
      for (var i = 0; i < surnameCount; i++) random.pick(surnames),
    ].join(' ');
  }

  /// Nº de BI angolano: 9 dígitos + 2 letras (província) + 3 dígitos. Ex.: `005123456LA042`.
  String bi() {
    final digits = List.generate(9, (_) => random.nextInt(10)).join();
    final tail = random.range(0, 999).toString().padLeft(3, '0');
    return '$digits${random.pick(_provinceCodes)}$tail';
  }

  /// Telemóvel angolano: `9XX XXX XXX`.
  String phone() {
    final prefix = random.pick(const ['91', '92', '93', '94', '95', '99']);
    final rest = List.generate(7, (_) => random.nextInt(10)).join();
    return '$prefix${rest.substring(0, 1)} ${rest.substring(1, 4)} ${rest.substring(4)}';
  }

  String email(String fullName, {String domain = 'escola.local'}) {
    final local = fullName
        .toLowerCase()
        .replaceAll(RegExp('[áàâã]'), 'a')
        .replaceAll(RegExp('[éê]'), 'e')
        .replaceAll('í', 'i')
        .replaceAll(RegExp('[óôõ]'), 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp('[^a-z ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '.');
    return '$local${random.range(1, 99)}@$domain';
  }

  /// Data de nascimento em UTC, para uma idade entre [minAge] e [maxAge] face a [reference].
  DateTime birthDate({
    required int minAge,
    required int maxAge,
    DateTime? reference,
  }) {
    final ref = (reference ?? DateTime.utc(2026, 1, 1)).toUtc();
    final year = ref.year - random.range(minAge, maxAge);
    return DateTime.utc(year, random.range(1, 12), random.range(1, 28));
  }

  /// ULID determinístico (26 chars Crockford). [timestamp] define os 48 bits de tempo.
  String ulid([DateTime? timestamp]) {
    var time = (timestamp ?? DateTime.utc(2026, 1, 1)).millisecondsSinceEpoch;
    final chars = List.filled(26, '0');
    for (var i = 9; i >= 0; i--) {
      chars[i] = _crockford[time % 32];
      time ~/= 32;
    }
    for (var i = 10; i < 26; i++) {
      chars[i] = _crockford[random.nextInt(32)];
    }
    return chars.join();
  }
}
