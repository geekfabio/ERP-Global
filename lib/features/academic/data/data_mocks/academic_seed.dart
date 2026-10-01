import '../../../../core/utils/seed_generator.dart';
import '../models/academic_models.dart';

/// Estrutura académica angolana de desenvolvimento: ciclos, classes
/// (Iniciação → 12.ª), cursos, disciplinas e currículo (mesma seed → mesmos dados).
class AcademicSeed {
  const AcademicSeed({
    required this.levels,
    required this.grades,
    required this.courses,
    required this.subjects,
    required this.curriculum,
  });

  final List<LevelModel> levels;
  final List<GradeModel> grades;
  final List<CourseModel> courses;
  final List<SubjectModel> subjects;
  final List<CurriculumItemModel> curriculum;
}

const _levelDefs = [
  ('INI', 'Iniciação'),
  ('PRI', 'Ensino Primário'),
  ('ES1', 'I Ciclo do Ensino Secundário'),
  ('ES2', 'II Ciclo do Ensino Secundário'),
];

/// (código, designação)
const _subjectDefs = [
  ('LP', 'Língua Portuguesa'),
  ('MAT', 'Matemática'),
  ('EMC', 'Educação Moral e Cívica'),
  ('EF', 'Educação Física'),
  ('EMP', 'Educação Manual e Plástica'),
  ('EDM', 'Estudo do Meio'),
  ('ING', 'Língua Inglesa'),
  ('HIS', 'História'),
  ('GEO', 'Geografia'),
  ('BIO', 'Biologia'),
  ('FIS', 'Física'),
  ('QUI', 'Química'),
  ('EVP', 'Educação Visual e Plástica'),
  ('INF', 'Informática'),
  ('FIL', 'Filosofia'),
  ('DES', 'Desenho'),
  ('ECO', 'Economia'),
  ('DIR', 'Introdução ao Direito'),
  ('SOC', 'Sociologia'),
];

/// (código, designação, ciclos)
const _courseDefs = [
  ('GER', 'Ensino Geral', ['INI', 'PRI', 'ES1']),
  ('CFB', 'Ciências Físicas e Biológicas', ['ES2']),
  ('CEJ', 'Ciências Económicas e Jurídicas', ['ES2']),
  ('CHU', 'Ciências Humanas', ['ES2']),
  ('AVI', 'Artes Visuais', ['ES2']),
];

/// Disciplinas (código → horas semanais) por `curso/ciclo`.
const _plans = <String, Map<String, int>>{
  'GER/INI': {'LP': 5, 'MAT': 5, 'EMC': 2, 'EF': 3, 'EMP': 3},
  'GER/PRI': {'LP': 6, 'MAT': 6, 'EDM': 3, 'EMC': 2, 'EF': 2, 'EMP': 2},
  'GER/ES1': {
    'LP': 4,
    'MAT': 4,
    'ING': 3,
    'HIS': 2,
    'GEO': 2,
    'BIO': 2,
    'FIS': 2,
    'EVP': 2,
    'EF': 2,
    'EMC': 1,
    'INF': 2,
  },
  'CFB/ES2': {
    'LP': 3,
    'ING': 3,
    'MAT': 5,
    'FIS': 4,
    'QUI': 4,
    'BIO': 4,
    'FIL': 2,
    'EF': 2,
    'INF': 2,
  },
  'CEJ/ES2': {
    'LP': 3,
    'ING': 3,
    'MAT': 4,
    'ECO': 4,
    'DIR': 4,
    'HIS': 2,
    'GEO': 2,
    'EF': 2,
    'INF': 2,
  },
  'CHU/ES2': {
    'LP': 4,
    'ING': 3,
    'HIS': 4,
    'GEO': 3,
    'FIL': 3,
    'SOC': 3,
    'EF': 2,
    'INF': 2,
  },
  'AVI/ES2': {
    'LP': 3,
    'ING': 3,
    'DES': 5,
    'EVP': 4,
    'HIS': 2,
    'MAT': 3,
    'EF': 2,
    'INF': 2,
  },
};

AcademicSeed buildAcademicSeed({int seed = 28}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2024, 1, 1);
  var tick = 0;
  String id() => gen.ulid(at.add(Duration(minutes: tick++)));

  final levels = [
    for (var i = 0; i < _levelDefs.length; i++)
      LevelModel(
        id: id(),
        code: _levelDefs[i].$1,
        name: _levelDefs[i].$2,
        order: i,
      ),
  ];
  final levelByCode = {for (final l in levels) l.code: l};

  // Iniciação (0), 1.ª–6.ª (Primário), 7.ª–9.ª (I Ciclo), 10.ª–12.ª (II Ciclo).
  String levelOf(int n) => switch (n) {
    0 => 'INI',
    <= 6 => 'PRI',
    <= 9 => 'ES1',
    _ => 'ES2',
  };
  final grades = [
    for (var n = 0; n <= 12; n++)
      GradeModel(
        id: id(),
        levelId: levelByCode[levelOf(n)]!.id,
        name: n == 0 ? 'Iniciação' : '$n.ª classe',
        order: n,
      ),
  ];

  final subjects = [
    for (final (code, name) in _subjectDefs)
      SubjectModel(id: id(), code: code, name: name),
  ];
  final subjectByCode = {for (final s in subjects) s.code: s};

  final courses = [
    for (final (code, name, lvls) in _courseDefs)
      CourseModel(
        id: id(),
        code: code,
        name: name,
        levelIds: [for (final l in lvls) levelByCode[l]!.id],
      ),
  ];

  final curriculum = <CurriculumItemModel>[];
  for (final course in courses) {
    for (final grade in grades) {
      final level = levels.firstWhere((l) => l.id == grade.levelId);
      if (!course.levelIds.contains(level.id)) continue;
      final plan = _plans['${course.code}/${level.code}']!;
      for (final entry in plan.entries) {
        curriculum.add(
          CurriculumItemModel(
            id: id(),
            courseId: course.id,
            gradeId: grade.id,
            subjectId: subjectByCode[entry.key]!.id,
            weeklyHours: entry.value,
          ),
        );
      }
    }
  }
  return AcademicSeed(
    levels: levels,
    grades: grades,
    courses: courses,
    subjects: subjects,
    curriculum: curriculum,
  );
}
