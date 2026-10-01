// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    _PositionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category:
          $enumDecodeNullable(_$PositionCategoryEnumMap, json['category']) ??
          PositionCategory.administrative,
    );

Map<String, dynamic> _$PositionModelToJson(_PositionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$PositionCategoryEnumMap[instance.category]!,
    };

const _$PositionCategoryEnumMap = {
  PositionCategory.teaching: 'teaching',
  PositionCategory.administrative: 'administrative',
  PositionCategory.support: 'support',
};

_EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    _EmployeeModel(
      id: json['id'] as String,
      employeeNumber: json['employeeNumber'] as String? ?? '',
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      positionId: json['positionId'] as String,
      hireDate: json['hireDate'] as String,
      teacherId: json['teacherId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      hasActiveContract: json['hasActiveContract'] as bool? ?? false,
    );

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'positionId': instance.positionId,
      'hireDate': instance.hireDate,
      'teacherId': instance.teacherId,
      'isActive': instance.isActive,
      'hasActiveContract': instance.hasActiveContract,
    };

_ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    _ContractModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      type:
          $enumDecodeNullable(_$ContractTypeEnumMap, json['type']) ??
          ContractType.permanent,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      baseSalary: (json['baseSalary'] as num).toInt(),
    );

Map<String, dynamic> _$ContractModelToJson(_ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'type': _$ContractTypeEnumMap[instance.type]!,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'baseSalary': instance.baseSalary,
    };

const _$ContractTypeEnumMap = {
  ContractType.permanent: 'permanent',
  ContractType.fixedTerm: 'fixed_term',
  ContractType.service: 'service',
};
