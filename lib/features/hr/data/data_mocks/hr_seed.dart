import '../../../../core/utils/seed_generator.dart';
import '../models/hr_models.dart';

class HrSeed {
  const HrSeed({
    required this.positions,
    required this.employees,
    required this.contracts,
  });

  final List<PositionModel> positions;
  final List<EmployeeModel> employees;
  final List<ContractModel> contracts;
}

String _id(String tag, int n) =>
    '01J$tag${n.toString().padLeft(4, '0')}'.padRight(26, '0');

const _positions = [
  ('Professor', PositionCategory.teaching),
  ('Coordenador pedagógico', PositionCategory.teaching),
  ('Secretário', PositionCategory.administrative),
  ('Contabilista', PositionCategory.administrative),
  ('Bibliotecário', PositionCategory.administrative),
  ('Auxiliar de limpeza', PositionCategory.support),
  ('Segurança', PositionCategory.support),
  ('Cozinheiro', PositionCategory.support),
];

/// 60 docentes (F0001–F0060, ligados aos professores do académico) + 20 não
/// docentes. Alguns docentes ficam sem contrato ou com contrato expirado, para
/// exercitar o aviso "docente sem contrato".
HrSeed buildHrSeed({int teachers = 60, int staff = 20}) {
  final positions = [
    for (final (i, p) in _positions.indexed)
      PositionModel(id: _id('POS', i + 1), name: p.$1, category: p.$2),
  ];
  // Mesma sequência de nomes do seed de professores (semente 4201).
  final teacherGen = SeedGenerator(4201);
  final staffGen = SeedGenerator(5301);
  final employees = <EmployeeModel>[];
  final contracts = <ContractModel>[];
  for (var i = 0; i < teachers + staff; i++) {
    final isTeacher = i < teachers;
    final gen = isTeacher ? teacherGen : staffGen;
    final name = gen.fullName();
    final email = gen.email(name);
    final phone = gen.phone();
    final id = _id('EMP', i + 1);
    final position = isTeacher
        ? positions[i % 12 == 0 ? 1 : 0]
        : positions[2 + (i - teachers) % 6];
    employees.add(
      EmployeeModel(
        id: id,
        employeeNumber: 'F${(i + 1).toString().padLeft(4, '0')}',
        fullName: name,
        email: email,
        phone: phone,
        positionId: position.id,
        hireDate: '${2015 + i % 10}-0${1 + i % 9}-01',
        teacherId: isTeacher ? _id('PROF', i + 1) : null,
        isActive: i % 15 != 14,
      ),
    );
    // i % 10 == 9: sem contrato; i % 10 == 4: contrato a termo expirado.
    if (i % 10 == 9) continue;
    if (i % 10 == 4) {
      contracts.add(
        ContractModel(
          id: _id('CTR', i + 1),
          employeeId: id,
          type: ContractType.fixedTerm,
          startDate: '2024-01-01',
          endDate: '2024-12-31',
          baseSalary: 18000000,
        ),
      );
      continue;
    }
    final fixed = i % 3 == 0;
    contracts.add(
      ContractModel(
        id: _id('CTR', i + 1),
        employeeId: id,
        type: fixed ? ContractType.fixedTerm : ContractType.permanent,
        startDate: '2025-01-01',
        endDate: fixed ? '2099-12-31' : null,
        baseSalary: (isTeacher ? 25000000 : 15000000) + (i % 5) * 500000,
      ),
    );
  }
  return HrSeed(
    positions: positions,
    employees: employees,
    contracts: contracts,
  );
}
