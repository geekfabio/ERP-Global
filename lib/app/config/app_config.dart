/// Configuração global. `useMockApi` escolhe o adaptador de rede (docs/07-mock-api.md).
class AppConfig {
  const AppConfig._();

  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );

  /// `true` troca os repositories de referência (alunos) para SQLite local
  /// (Drift) em vez de `Api...Repository` (docs/08-persistencia-local.md).
  static const bool useLocalDb = bool.fromEnvironment('USE_LOCAL_DB');
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.erp-global.local',
  );
}
