import 'package:erp_global/core/audit/audit_mock_handlers.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/inventory/data/mock_api/inventory_mock_handlers.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';

import 'contract_target.dart';

/// Credenciais de dev (docs/07-mock-api.md); o servidor real aceita as mesmas em staging.
const contractAdmin = (
  identifier: 'admin@erp-global.local',
  password: 'Admin@12345',
);

/// Alvo mock: handlers reais dos módulos sobre `MockApiAdapter` instantâneo.
class MockContractTarget implements ContractTarget {
  MockContractTarget({this.seed = 42, this.students = 300});

  final int seed;
  final int students;

  @override
  String get name => 'mock (seed $seed)';

  @override
  String? get skipReason => null;

  @override
  Future<ApiClient> open() async {
    final registry = MockApiRegistry()
      ..addModule(AuthMockHandlers())
      ..addModule(StudentsMockHandlers(seed: seed, count: students))
      ..addModule(AuditMockHandlers())
      ..addModule(AcademicStructureMockHandlers())
      ..addModule(InventoryMockHandlers());
    final client = ApiClient.create(
      baseUrl: 'https://api.contract.test',
      useMockApi: true,
      registry: registry,
      mockConfig: MockApiConfig.instant(seed: seed),
      logging: false,
    );
    await call(client, 'POST', '/__mock/reset');
    return client;
  }
}
