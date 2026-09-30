/// Gerador pseudo-aleatório determinístico (mulberry32): mesma seed → mesma sequência,
/// em qualquer plataforma (só aritmética de 32 bits).
class SeededRandom {
  SeededRandom(int seed) : _state = seed & _mask;

  static const _mask = 0xFFFFFFFF;
  int _state;

  /// Inteiro uniforme em `[0, max)`.
  int nextInt(int max) {
    assert(max > 0);
    _state = (_state + 0x6D2B79F5) & _mask;
    var t = _state;
    t = ((t ^ (t >> 15)) * (t | 1)) & _mask;
    t ^= (t + (((t ^ (t >> 7)) * (t | 61)) & _mask)) & _mask;
    final value = (t ^ (t >> 14)) & _mask;
    return value % max;
  }

  /// Inteiro uniforme em `[min, max]`.
  int range(int min, int max) => min + nextInt(max - min + 1);

  bool chance(double probability) => nextInt(1000000) < probability * 1000000;

  T pick<T>(List<T> items) => items[nextInt(items.length)];
}
