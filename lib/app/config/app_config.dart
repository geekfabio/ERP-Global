/// Configuração global. `useMockApi` escolhe o adaptador de rede (docs/07-mock-api.md).
class AppConfig {
  const AppConfig._();

  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.erp-global.local',
  );
}
