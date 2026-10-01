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
    final name = gen.fullName();
    teachers.add(
      TeacherModel(
        id: '01JPROF${(i + 1).toString().padLeft(4, '0')}'.padRight(26, '0'),
        employeeNumber: 'F${(i + 1).toString().padLeft(4, '0')}',
        fullName: name,
        email: gen.email(name),
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
