import '../../../../core/network/api_client.dart';
import '../../../academic/data/repositories/api_academic_repositories.dart';
import '../../domain/hr_repositories.dart';
import '../models/hr_models.dart';

PositionRepository apiPositionRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/positions',
  fromJson: PositionModel.fromJson,
  toJson: (v) => v.toJson(),
);

EmployeeRepository apiEmployeeRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/employees',
  fromJson: EmployeeModel.fromJson,
  toJson: (v) => v.toJson(),
);

ContractRepository apiContractRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/contracts',
  fromJson: ContractModel.fromJson,
  toJson: (v) => v.toJson(),
);
