import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/models/academic_models.dart';
import 'package:erp_global/features/academic/data/repositories/api_academic_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()..addModule(AcademicStructureMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void expectFailure(Result<Object?> result, int status) => expect(
  result.failureOrNull?.code,
  status == 409 ? 'CONFLICT' : 'VALIDATION_ERROR',
);

void main() {
  test('seed angolano: 4 ciclos, Iniciação → 12.ª e 5 cursos', () async {
    final c = _client();
    final levels = (await apiLevelRepository(c).list()).getOrThrow().items;
    final grades = (await apiGradeRepository(c).list()).getOrThrow().items;
    final courses = (await apiCourseRepository(c).list()).getOrThrow().items;
    expect(levels.map((l) => l.code), ['INI', 'PRI', 'ES1', 'ES2']);
    expect(grades.length, 13);
    expect(grades.first.name, 'Iniciação');
    expect(grades.last.name, '12.ª classe');
    expect(courses.length, 5);
  });

  test('currículo por curso × classe filtra e ordena', () async {
    final c = _client();
    final courses = (await apiCourseRepository(c).list()).getOrThrow().items;
    final grades = (await apiGradeRepository(c).list()).getOrThrow().items;
    final cfb = courses.firstWhere((x) => x.code == 'CFB');
    final g12 = grades.firstWhere((g) => g.order == 12);
    final items = (await apiCurriculumRepository(c).list(
      filters: {'courseId': cfb.id, 'gradeId': g12.id},
    )).getOrThrow().items;
    expect(items, isNotEmpty);
    expect(
      items.every((i) => i.courseId == cfb.id && i.gradeId == g12.id),
      isTrue,
    );
    final none = (await apiCurriculumRepository(c).list(
      filters: {'courseId': cfb.id, 'gradeId': grades.first.id},
    )).getOrThrow().items;
    expect(none, isEmpty);
  });

  test(
    'currículo: duplicado 409, classe fora do curso 422, horas 422',
    () async {
      final c = _client();
      final repo = apiCurriculumRepository(c);
      final courses = (await apiCourseRepository(c).list()).getOrThrow().items;
      final grades = (await apiGradeRepository(c).list()).getOrThrow().items;
      final subjects = (await apiSubjectRepository(
        c,
      ).list()).getOrThrow().items;
      final cfb = courses.firstWhere((x) => x.code == 'CFB');
      final g10 = grades.firstWhere((g) => g.order == 10);
      final g1 = grades.firstWhere((g) => g.order == 1);
      final dir = subjects.firstWhere((s) => s.code == 'DIR');
      final lp = subjects.firstWhere((s) => s.code == 'LP');

      CurriculumItemModel draft(GradeModel g, SubjectModel s, int h) =>
          CurriculumItemModel(
            id: '',
            courseId: cfb.id,
            gradeId: g.id,
            subjectId: s.id,
            weeklyHours: h,
          );

      expectFailure(await repo.create(draft(g10, lp, 3)), 409);
      expectFailure(await repo.create(draft(g1, dir, 3)), 422);
      expectFailure(await repo.create(draft(g10, dir, 0)), 422);
      final ok = (await repo.create(draft(g10, dir, 2))).getOrThrow();
      expect(ok.id, isNotEmpty);
      final upd = (await repo.update(
        ok.id,
        ok.copyWith(weeklyHours: 4),
      )).getOrThrow();
      expect(upd.weeklyHours, 4);
      expect((await repo.delete(ok.id)).isOk, isTrue);
    },
  );

  test(
    'ciclo, classe, curso e disciplina: CRUD e regras de integridade',
    () async {
      final c = _client();
      final levels = apiLevelRepository(c);
      final grades = apiGradeRepository(c);
      final courses = apiCourseRepository(c);
      final subjects = apiSubjectRepository(c);

      final all = (await levels.list()).getOrThrow().items;
      // Ciclo com classes não se elimina.
      expectFailure(await levels.delete(all.first.id), 409);
      // Código duplicado (insensível a maiúsculas).
      expectFailure(
        await levels.create(const LevelModel(id: '', code: 'pri', name: 'X')),
        409,
      );
      expectFailure(
        await levels.create(const LevelModel(id: '', code: '', name: 'X')),
        422,
      );
      final lvl = (await levels.create(
        const LevelModel(id: '', code: 'ESP', name: 'Especial', order: 9),
      )).getOrThrow();
      expect(lvl.code, 'ESP');
      final grade = (await grades.create(
        GradeModel(id: '', levelId: lvl.id, name: '13.ª classe', order: 13),
      )).getOrThrow();
      expectFailure(
        await grades.create(
          GradeModel(id: '', levelId: lvl.id, name: '13.ª classe', order: 14),
        ),
        409,
      );
      expectFailure(
        await grades.create(
          const GradeModel(id: '', levelId: 'nope', name: 'Y', order: 15),
        ),
        422,
      );
      expectFailure(await levels.delete(lvl.id), 409);
      expect((await grades.delete(grade.id)).isOk, isTrue);
      expect((await levels.delete(lvl.id)).isOk, isTrue);

      // Curso com currículo não se elimina; disciplina em uso também não.
      final cfb = (await courses.list()).getOrThrow().items.firstWhere(
        (x) => x.code == 'CFB',
      );
      expectFailure(await courses.delete(cfb.id), 409);
      expectFailure(
        await courses.update(cfb.id, cfb.copyWith(levelIds: [all.first.id])),
        409,
      );
      expectFailure(
        await courses.create(
          const CourseModel(id: '', code: 'X', name: 'X', levelIds: []),
        ),
        422,
      );
      final lp = (await subjects.list(
        q: 'portuguesa',
      )).getOrThrow().items.single;
      expectFailure(await subjects.delete(lp.id), 409);
      final s = (await subjects.create(
        const SubjectModel(id: '', code: 'xyz', name: 'Teste'),
      )).getOrThrow();
      expect(s.code, 'XYZ');
      expect((await subjects.delete(s.id)).isOk, isTrue);
    },
  );
}
