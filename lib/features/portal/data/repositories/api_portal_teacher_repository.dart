import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/portal_teacher_repository.dart';
import '../models/portal_teacher_models.dart';

/// Compõe "as minhas turmas" a partir dos endpoints do módulo académico
/// (`/v1/teachers`, `/v1/teaching-assignments`, `/v1/homerooms`,
/// `/v1/classrooms`…), sem importar o interior desse módulo.
class ApiPortalTeacherRepository implements PortalTeacherRepository {
  ApiPortalTeacherRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> _all(
    String path, {
    Map<String, dynamic> query = const {},
  }) async {
    final items = <Map<String, dynamic>>[];
    var page = 1;
    while (true) {
      final response = await _client.dio.get<dynamic>(
        path,
        queryParameters: {...query, 'page': page, 'pageSize': 100},
      );
      final result = ApiEnvelope.page(response, (json) => json);
      items.addAll(result.items);
      if (!result.meta.hasNext) return items;
      page++;
    }
  }

  @override
  Future<Result<List<TeacherClass>>> myClasses({required String email}) =>
      Result.guard(() async {
        final wanted = email.trim().toLowerCase();
        if (wanted.isEmpty) return const <TeacherClass>[];
        final teachers = await _all('/v1/teachers', query: {'q': wanted});
        final teacher = teachers
            .where((t) => '${t['email']}'.toLowerCase() == wanted)
            .firstOrNull;
        if (teacher == null) return const <TeacherClass>[];
        final teacherId = teacher['id'] as String;

        final filter = {'filter[teacherId]': teacherId};
        final assignments = await _all(
          '/v1/teaching-assignments',
          query: filter,
        );
        final homerooms = await _all('/v1/homerooms', query: filter);
        final homeroomIds = {for (final h in homerooms) h['classroomId']};
        final classIds = {
          for (final a in assignments) a['classroomId'],
          ...homeroomIds,
        };
        if (classIds.isEmpty) return const <TeacherClass>[];

        final classrooms = await _all('/v1/classrooms');
        final grades = _names(await _all('/v1/grades'));
        final shifts = _names(await _all('/v1/shifts'));
        final subjects = _names(await _all('/v1/subjects'));
        return [
          for (final c in classrooms)
            if (classIds.contains(c['id']))
              TeacherClass(
                classroomId: c['id'] as String,
                name: '${c['name']}',
                gradeName: grades[c['gradeId']] ?? '',
                shiftName: shifts[c['shiftId']] ?? '',
                enrolledCount: (c['enrolledCount'] as num?)?.toInt() ?? 0,
                isHomeroom: homeroomIds.contains(c['id']),
                subjects: _subjectsOf(c['id'], assignments, subjects),
              ),
        ]..sort((a, b) => a.label.compareTo(b.label));
      });

  static Map<Object?, String> _names(List<Map<String, dynamic>> rows) => {
    for (final r in rows) r['id']: '${r['name']}',
  };

  static List<TeacherSubject> _subjectsOf(
    Object? classroomId,
    List<Map<String, dynamic>> assignments,
    Map<Object?, String> names,
  ) {
    final seen = <Object?>{};
    return [
      for (final a in assignments)
        if (a['classroomId'] == classroomId && seen.add(a['subjectId']))
          TeacherSubject(
            id: a['subjectId'] as String,
            name: names[a['subjectId']] ?? '${a['subjectId']}',
          ),
    ]..sort((a, b) => a.name.compareTo(b.name));
  }
}
