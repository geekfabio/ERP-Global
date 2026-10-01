import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/academic_models.dart';
import '../data/models/classroom_models.dart';

/// Contrato CRUD de um recurso da estrutura académica; a UI só conhece isto.
///
/// Erros: 422 por campo inválido, 409 em duplicados e ao eliminar registos
/// ainda em uso (ex.: ciclo com classes, disciplina no currículo).
abstract interface class AcademicCrudRepository<T> {
  Future<Result<PagedList<T>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
    Map<String, String> filters = const {},
  });

  Future<Result<T>> create(T value);

  /// Actualiza com os campos de [value] (o `id` é o do caminho).
  Future<Result<T>> update(String id, T value);

  Future<Result<void>> delete(String id);
}

typedef LevelRepository = AcademicCrudRepository<LevelModel>;
typedef GradeRepository = AcademicCrudRepository<GradeModel>;
typedef CourseRepository = AcademicCrudRepository<CourseModel>;
typedef SubjectRepository = AcademicCrudRepository<SubjectModel>;
typedef CurriculumRepository = AcademicCrudRepository<CurriculumItemModel>;
typedef RoomRepository = AcademicCrudRepository<RoomModel>;
typedef ShiftRepository = AcademicCrudRepository<ShiftModel>;
typedef ClassroomRepository = AcademicCrudRepository<ClassroomModel>;
