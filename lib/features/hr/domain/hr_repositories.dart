import '../../academic/domain/academic_repositories.dart';
import '../data/models/hr_models.dart';

/// Contratos CRUD do módulo RH (mesma forma dos do académico).
typedef PositionRepository = AcademicCrudRepository<PositionModel>;
typedef EmployeeRepository = AcademicCrudRepository<EmployeeModel>;
typedef ContractRepository = AcademicCrudRepository<ContractModel>;
