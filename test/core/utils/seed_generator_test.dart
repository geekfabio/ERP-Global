import 'package:erp_global/core/utils/seed_generator.dart';
import 'package:erp_global/core/utils/seeded_random.dart';
import 'package:flutter_test/flutter_test.dart';

List<Object> _sample(int seed) {
  final g = SeedGenerator(seed);
  return [
    for (var i = 0; i < 50; i++) ...[
      g.fullName(),
      g.bi(),
      g.phone(),
      g.ulid(),
      g.birthDate(minAge: 6, maxAge: 18),
    ],
  ];
}

void main() {
  test('mesma seed → mesmos dados; seed diferente → dados diferentes', () {
    expect(_sample(42), _sample(42));
    expect(_sample(42), isNot(_sample(43)));
  });

  test('SeededRandom é determinístico e respeita limites', () {
    final a = SeededRandom(1);
    final b = SeededRandom(1);
    for (var i = 0; i < 100; i++) {
      final v = a.nextInt(10);
      expect(v, b.nextInt(10));
      expect(v, inInclusiveRange(0, 9));
    }
    expect(SeededRandom(5).range(3, 3), 3);
  });

  test('formatos plausíveis', () {
    final g = SeedGenerator(7);
    for (var i = 0; i < 100; i++) {
      expect(g.bi(), matches(RegExp(r'^\d{9}[A-Z]{2}\d{3}$')));
      expect(g.phone(), matches(RegExp(r'^9\d{2} \d{3} \d{3}$')));
      expect(g.ulid(), matches(RegExp(r'^[0-9A-HJKMNP-TV-Z]{26}$')));
      expect(g.fullName().split(' ').length, greaterThanOrEqualTo(2));
    }
    final email = g.email('João Conceição Neto');
    expect(email, matches(RegExp(r'^joao\.conceicao\.neto\d+@escola\.local$')));
  });

  test('ULIDs do mesmo instante ordenam por tempo', () {
    final g = SeedGenerator(1);
    final early = g.ulid(DateTime.utc(2025));
    final late = g.ulid(DateTime.utc(2026));
    expect(
      early.substring(0, 10).compareTo(late.substring(0, 10)),
      lessThan(0),
    );
  });

  test('birthDate respeita a idade', () {
    final g = SeedGenerator(3);
    final ref = DateTime.utc(2026, 1, 1);
    for (var i = 0; i < 50; i++) {
      final d = g.birthDate(minAge: 6, maxAge: 18, reference: ref);
      expect(d.isUtc, isTrue);
      expect(ref.year - d.year, inInclusiveRange(6, 18));
    }
  });
}
