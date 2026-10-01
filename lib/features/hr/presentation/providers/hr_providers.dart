import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../academic/domain/academic_repositories.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../data/mock_api/hr_mock_handlers.dart';
import '../../data/models/hr_models.dart';
import '../../data/repositories/api_hr_repositories.dart';
import '../../domain/hr_repositories.dart';

final positionRepositoryProvider = Provider<PositionRepository>(
  (ref) => apiPositionRepository(ref.watch(apiClientProvider)),
);
final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => apiEmployeeRepository(ref.watch(apiClientProvider)),
);
final contractRepositoryProvider = Provider<ContractRepository>(
  (ref) => apiContractRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do RH, registados em `main.dart` (só com mock activo).
final hrMockHandlersProvider = Provider<HrMockHandlers>(
  (ref) => HrMockHandlers(),
);

Future<List<T>> fetchAllPages<T>(
  AcademicCrudRepository<T> repo, {
  Map<String, String> filters = const {},
}) async {
  final items = <T>[];
  var page = 1;
  while (true) {
    final PagedList<T> result = (await repo.list(
      page: page,
      filters: filters,
    )).getOrThrow();
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}

final positionListProvider = FutureProvider.autoDispose<List<PositionModel>>(
  (ref) => fetchAllPages(ref.watch(positionRepositoryProvider)),
  retry: (_, _) => null,
);

final employeeListProvider = FutureProvider.autoDispose<List<EmployeeModel>>(
  (ref) => fetchAllPages(ref.watch(employeeRepositoryProvider)),
  retry: (_, _) => null,
);

final contractListProvider = FutureProvider.autoDispose<List<ContractModel>>(
  (ref) => fetchAllPages(ref.watch(contractRepositoryProvider)),
  retry: (_, _) => null,
);

/// Contratos de um funcionário (ficha).
final employeeContractsProvider = FutureProvider.autoDispose
    .family<List<ContractModel>, String>(
      (ref, employeeId) => fetchAllPages(
        ref.watch(contractRepositoryProvider),
        filters: {'employeeId': employeeId},
      ),
      retry: (_, _) => null,
    );

/// Nº de atribuições (turma × disciplina) de um docente, vindas do académico.
final teacherAssignmentCountProvider = FutureProvider.autoDispose
    .family<int, String>(
      (ref, teacherId) async => (await fetchAllPages(
        ref.watch(teachingAssignmentRepositoryProvider),
        filters: {'teacherId': teacherId},
      )).length,
      retry: (_, _) => null,
    );
