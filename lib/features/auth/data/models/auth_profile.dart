import 'package:json_annotation/json_annotation.dart';

enum AuthProfile {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('direcao')
  management,
  @JsonValue('coordenacao')
  coordination,
  @JsonValue('secretaria')
  academicOffice,
  @JsonValue('professor')
  teacher,
  @JsonValue('diretor_turma')
  homeroomTeacher,
  @JsonValue('financeiro')
  finance,
  @JsonValue('contabilista')
  accountant,
  @JsonValue('rh')
  humanResources,
  @JsonValue('refeitorio')
  cafeteria,
  @JsonValue('seguranca')
  security,
  @JsonValue('bibliotecario')
  librarian,
  @JsonValue('encarregado')
  guardian,
  @JsonValue('aluno')
  student,
}
