import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_envelope.dart';
import '../../data/models/student_enums.dart';
import '../../data/models/student_model.dart';
import '../../domain/student_repositories.dart';
import 'student_providers.dart';

/// Filtros, pesquisa, ordenação e página da listagem de alunos. Os filtros são
/// combináveis; qualquer alteração (excepto a página) volta à página 1.
class StudentListQueryNotifier extends Notifier<StudentQuery> {
  @override
  StudentQuery build() => const StudentQuery();

  void setSearch(String text) {
    final q = text.trim();
    state = _rebuild(q: q.isEmpty ? null : q, keepQ: false);
  }

  void setStatus(StudentStatus? status) =>
      state = _rebuild(status: status, keepStatus: false);

  void setGender(Gender? gender) =>
      state = _rebuild(gender: gender, keepGender: false);

  /// Mudar de classe limpa a turma (pertence a outra classe).
  void setGrade(String? gradeId) => state = _rebuild(
    gradeId: gradeId,
    keepGrade: false,
    classroomId: null,
    keepClassroom: false,
  );

  void setClassroom(String? classroomId) =>
      state = _rebuild(classroomId: classroomId, keepClassroom: false);

  /// Alterna a ordenação por [field]: asc → desc → asc.
  void toggleSort(String field) {
    final current = state.sort.isEmpty ? null : state.sort.first;
    final next = current == field ? '-$field' : field;
    state = _rebuild(sort: [next]);
  }

  void setPage(int page) => state = _copy(page: page);
  void setPageSize(int size) => state = _copy(page: 1, pageSize: size);
  void clearFilters() => state = StudentQuery(sort: state.sort);

  bool get hasFilters =>
      state.q != null ||
      state.status != null ||
      state.gender != null ||
      state.gradeId != null ||
      state.classroomId != null;

  StudentQuery _copy({int? page, int? pageSize}) => StudentQuery(
    page: page ?? state.page,
    pageSize: pageSize ?? state.pageSize,
    q: state.q,
    status: state.status,
    gender: state.gender,
    gradeId: state.gradeId,
    classroomId: state.classroomId,
    sort: state.sort,
  );

  StudentQuery _rebuild({
    String? q,
    bool keepQ = true,
    StudentStatus? status,
    bool keepStatus = true,
    Gender? gender,
    bool keepGender = true,
    String? gradeId,
    bool keepGrade = true,
    String? classroomId,
    bool keepClassroom = true,
    List<String>? sort,
  }) => StudentQuery(
    page: 1,
    pageSize: state.pageSize,
    q: keepQ ? state.q : q,
    status: keepStatus ? state.status : status,
    gender: keepGender ? state.gender : gender,
    gradeId: keepGrade ? state.gradeId : gradeId,
    classroomId: keepClassroom ? state.classroomId : classroomId,
    sort: sort ?? state.sort,
  );
}

final studentListQueryProvider =
    NotifierProvider<StudentListQueryNotifier, StudentQuery>(
      StudentListQueryNotifier.new,
    );

/// Página actual de alunos para a [studentListQueryProvider]. Um `Failure` do
/// repository chega à UI como `AsyncError` (com "Tentar novamente").
final studentListProvider = FutureProvider.autoDispose<PagedList<StudentModel>>(
  (ref) async {
    final query = ref.watch(studentListQueryProvider);
    final result = await ref.watch(studentRepositoryProvider).list(query);
    return result.getOrThrow();
  },
  // Sem repetição automática do Riverpod: o erro vai para a UI, que oferece
  // "Tentar novamente" (o utilizador decide quando repetir).
  retry: (_, _) => null,
);

/// Resumo da listagem com os filtros em vigor: total, divisão por género e
/// alunos activos.
class StudentListStats {
  const StudentListStats({
    required this.total,
    required this.male,
    required this.female,
    required this.active,
  });

  final int total;
  final int male;
  final int female;
  final int active;
}

/// Contagens via `meta.total` (pedidos de 1 item, em paralelo): funciona com
/// qualquer implementação do repository. Respeita os filtros (um filtro de
/// género/estado incompatível dá 0 sem pedido) e ignora página e ordenação.
final studentListStatsProvider = FutureProvider.autoDispose<StudentListStats>((
  ref,
) async {
  final f = ref.watch(
    studentListQueryProvider.select(
      (q) => (
        q: q.q,
        status: q.status,
        gender: q.gender,
        gradeId: q.gradeId,
        classroomId: q.classroomId,
      ),
    ),
  );
  final repo = ref.watch(studentRepositoryProvider);
  Future<int> count({Gender? gender, StudentStatus? status}) async {
    if (f.gender != null && gender != null && f.gender != gender) return 0;
    if (f.status != null && status != null && f.status != status) return 0;
    final result = await repo.list(
      StudentQuery(
        pageSize: 1,
        q: f.q,
        status: status ?? f.status,
        gender: gender ?? f.gender,
        gradeId: f.gradeId,
        classroomId: f.classroomId,
      ),
    );
    return result.getOrThrow().meta.total;
  }

  final [total, male, female, active] = await Future.wait([
    count(),
    count(gender: Gender.male),
    count(gender: Gender.female),
    count(status: StudentStatus.active),
  ]);
  return StudentListStats(
    total: total,
    male: male,
    female: female,
    active: active,
  );
}, retry: (_, _) => null);
