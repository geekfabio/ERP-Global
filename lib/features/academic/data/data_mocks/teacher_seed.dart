import '../../../../core/utils/seed_generator.dart';
import '../models/teacher_models.dart';
import 'academic_seed.dart';
import 'classroom_seed.dart';

const _specialties = [
  'Licenciatura em Ensino da Matemática',
  'Licenciatura em Ensino do Português',
  'Licenciatura em Biologia',
  'Licenciatura em Física',
  'Licenciatura em História',
  'Licenciatura em Informática',
  'Bacharelato em Educação Física',
  'Licenciatura em Línguas Estrangeiras',
];

/// Os três primeiros docentes ligam os perfis de demonstração às atribuições
/// académicas reais. Os restantes continuam a ser gerados deterministicamente.
const _demoTeachers = <({String fullName, String email})>[
  (fullName: 'Carla Domingos', email: 'coordenacao@erp-global.local'),
  (fullName: 'Helena Costa', email: 'professor@erp-global.local'),
  (fullName: 'Paulo António', email: 'diretor_turma@erp-global.local'),
];

/// ~60 professores determinísticos, com disciplinas e turmas distribuídas.
List<TeacherModel> buildTeacherSeed({
  AcademicSeed? academic,
  ClassroomSeed? classrooms,
  int count = 60,
}) {
  final a = academic ?? buildAcademicSeed();
  final c = classrooms ?? buildClassroomSeed(a);
  final gen = SeedGenerator(4201);
  final teachers = <TeacherModel>[];
  for (var i = 0; i < count; i++) {
    final generatedName = gen.fullName();
    final generatedEmail = gen.email(generatedName);
    final demo = i < _demoTeachers.length ? _demoTeachers[i] : null;
    teachers.add(
      TeacherModel(
        id: '01JPROF${(i + 1).toString().padLeft(4, '0')}'.padRight(26, '0'),
        employeeNumber: 'F${(i + 1).toString().padLeft(4, '0')}',
        fullName: demo?.fullName ?? generatedName,
        email: demo?.email ?? generatedEmail,
        phone: gen.phone(),
        specialty: _specialties[i % _specialties.length],
        subjectIds: [
          a.subjects[i % a.subjects.length].id,
          if (i.isEven) a.subjects[(i * 3 + 1) % a.subjects.length].id,
        ],
        classroomIds: [
          for (var k = i; k < c.classrooms.length; k += count)
            c.classrooms[k].id,
        ],
        isActive: i % 15 != 14,
      ),
    );
  }
  return teachers;
}
