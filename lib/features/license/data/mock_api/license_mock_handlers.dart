import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';

/// Handlers `/v1/license/*`. O consumo é calculado a partir dos outros módulos
/// por funções injectadas (cada módulo é dono dos seus dados).
class LicenseMockHandlers implements MockApiModule {
  LicenseMockHandlers({
    int Function()? students,
    int Function()? users,
    int Function()? campuses,
    int Function()? devices,
  }) : _students = students ?? (() => 0),
       _users = users ?? (() => 0),
       _campuses = campuses ?? (() => 1),
       _devices = devices ?? (() => 0);

  final int Function() _students;
  final int Function() _users;
  final int Function() _campuses;
  final int Function() _devices;

  @override
  void register(MockApiRegistry registry) {
    registry.get(
      '/v1/license/usage',
      (_) => MockResponse.ok({
        'students': _students(),
        'campuses': _campuses(),
        'users': _users(),
        'devices': _devices(),
      }),
    );
  }
}
