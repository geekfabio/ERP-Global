import 'package:freezed_annotation/freezed_annotation.dart';

part 'hr_models.freezed.dart';
part 'hr_models.g.dart';

/// Categoria de um cargo.
enum PositionCategory {
  @JsonValue('teaching')
  teaching('Docente'),
  @JsonValue('administrative')
  administrative('Administrativo'),
  @JsonValue('support')
  support('Apoio');

  const PositionCategory(this.label);

  final String label;
}

/// Tipo de contrato.
enum ContractType {
  @JsonValue('permanent')
  permanent('permanent', 'Efectivo'),
  @JsonValue('fixed_term')
  fixedTerm('fixed_term', 'A termo certo'),
  @JsonValue('service')
  service('service', 'Prestação de serviços');

  const ContractType(this.code, this.label);

  /// Valor no contrato JSON.
  final String code;
  final String label;
}

/// Cargo (ex.: Professor, Secretário, Auxiliar).
@freezed
abstract class PositionModel with _$PositionModel {
  const factory PositionModel({
    required String id,
    required String name,
    @Default(PositionCategory.administrative) PositionCategory category,
  }) = _PositionModel;

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);
}

/// Funcionário (docente ou não docente).
@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required String id,

    /// Atribuído pelo servidor na criação.
    @Default('') String employeeNumber,
    required String fullName,
    required String email,
    @Default('') String phone,
    required String positionId,

    /// Data de admissão (`AAAA-MM-DD`).
    required String hireDate,

    /// Ligação ao professor do módulo académico (só docentes).
    String? teacherId,
    @Default(true) bool isActive,

    /// Calculado pelo servidor: existe contrato em vigor hoje.
    @Default(false) bool hasActiveContract,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}

/// Contrato de um funcionário.
@freezed
abstract class ContractModel with _$ContractModel {
  const factory ContractModel({
    required String id,
    required String employeeId,
    @Default(ContractType.permanent) ContractType type,

    /// `AAAA-MM-DD`.
    required String startDate,

    /// `AAAA-MM-DD`; obrigatório nos contratos que não são efectivos.
    String? endDate,

    /// Salário base mensal em cêntimos.
    required int baseSalary,
  }) = _ContractModel;

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);
}
