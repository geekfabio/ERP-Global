/// Parâmetros da simulação de rede.
class MockApiConfig {
  const MockApiConfig({
    this.seed = 42,
    this.minLatency = const Duration(milliseconds: 150),
    this.maxLatency = const Duration(milliseconds: 600),
    this.chaos = false,
    this.chaosRate = 0.2,
    this.sleep = _realSleep,
  });

  /// Sem latência, para testes rápidos.
  const MockApiConfig.instant({int seed = 42, bool chaos = false})
    : this(
        seed: seed,
        minLatency: Duration.zero,
        maxLatency: Duration.zero,
        chaos: chaos,
        sleep: _noSleep,
      );

  /// Seed do gerador de latência/chaos e dos dados (mesma seed → mesmo comportamento).
  final int seed;
  final Duration minLatency;
  final Duration maxLatency;

  /// Falhas aleatórias 5xx/timeout (só dev) para testar estados de erro.
  final bool chaos;

  /// Probabilidade de falha por pedido quando [chaos] está activo.
  final double chaosRate;

  /// Função de espera; substituível em testes.
  final Future<void> Function(Duration) sleep;

  static Future<void> _realSleep(Duration d) => Future<void>.delayed(d);
  static Future<void> _noSleep(Duration d) => Future<void>.value();
}
