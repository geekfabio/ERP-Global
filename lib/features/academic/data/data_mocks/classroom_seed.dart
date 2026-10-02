import '../../../../core/network/mock/mock_reference_data.dart';
import '../models/academic_models.dart';
import '../models/classroom_models.dart';
import 'academic_seed.dart';

/// Salas, turnos e turmas do ano activo (determinístico).
class ClassroomSeed {
  const ClassroomSeed({
    required this.rooms,
    required this.shifts,
    required this.classrooms,
  });

  final List<RoomModel> rooms;
  final List<ShiftModel> shifts;
  final List<ClassroomModel> classrooms;
}

String _id(String prefix, int n) =>
    '01J$prefix${n.toString().padLeft(4, '0')}'.padRight(26, '0');

ClassroomSeed buildClassroomSeed([AcademicSeed? base]) {
  final academic = base ?? buildAcademicSeed();
  final rooms = [
    for (var i = 1; i <= 24; i++)
      RoomModel(
        id: _id('ROOM', i),
        code: 'S${i.toString().padLeft(2, '0')}',
        name: 'Sala ${i.toString().padLeft(2, '0')}',
        capacity: 40,
      ),
    RoomModel(
      id: _id('ROOM', 25),
      code: 'LABINF',
      name: 'Laboratório de Informática',
      capacity: 30,
    ),
  ];
  final shifts = [
    ShiftModel(
      id: _id('SHFT', 1),
      name: 'Manhã',
      startTime: '07:00',
      endTime: '12:00',
    ),
    ShiftModel(
      id: _id('SHFT', 2),
      name: 'Tarde',
      startTime: '12:30',
      endTime: '17:30',
    ),
    ShiftModel(
      id: _id('SHFT', 3),
      name: 'Noite',
      startTime: '18:00',
      endTime: '22:00',
      isActive: false,
    ),
  ];

  final courseByCode = {for (final c in academic.courses) c.code: c};
  final levelCode = {for (final l in academic.levels) l.id: l.code};
  final classrooms = <ClassroomModel>[];
  var n = 0;
  // Uma sala só aloja uma turma por turno; as mesmas salas servem manhã e tarde.
  var morningRoom = 0;
  var afternoonRoom = 0;

  void add(GradeModel g, CourseModel c, ShiftModel s, String name, int room) {
    n++;
    classrooms.add(
      ClassroomModel(
        id: _id('TURM', n),
        academicYearId: MockRef.academicYearId,
        gradeId: g.id,
        courseId: c.id,
        shiftId: s.id,
        roomId: rooms[room].id,
        name: name,
        capacity: 35,
        enrolledCount: 22 + (n * 7) % 14,
      ),
    );
  }

  for (final g in academic.grades) {
    if (levelCode[g.levelId] != 'ES2') {
      final c = courseByCode['GER']!;
      add(g, c, shifts[0], 'A', morningRoom++);
      add(g, c, shifts[1], 'B', afternoonRoom++);
    } else {
      for (final code in const ['CFB', 'CEJ', 'CHU', 'AVI']) {
        final afternoon = code == 'CFB';
        add(
          g,
          courseByCode[code]!,
          shifts[afternoon ? 1 : 0],
          'A',
          afternoon ? afternoonRoom++ : morningRoom++,
        );
      }
    }
  }
  return ClassroomSeed(rooms: rooms, shifts: shifts, classrooms: classrooms);
}
