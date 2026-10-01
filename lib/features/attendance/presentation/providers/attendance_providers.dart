import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/domain/student_repositories.dart';
import '../../../students/presentation/providers/student_providers.dart';
import '../../data/mock_api/attendance_mock_handlers.dart';
import '../../data/models/attendance_models.dart';
import '../../data/repositories/api_attendance_repository.dart';
import '../../domain/attendance_repository.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => ApiAttendanceRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
/// A restrição às turmas atribuídas vem do módulo académico, como no servidor.
final attendanceMockHandlersProvider = Provider<AttendanceMockHandlers>(
  (ref) => AttendanceMockHandlers(
    permissions: () => ref.read(permissionServiceProvider),
    access: (classroomId, {required daily}) async {
      final mine = await ref.read(myClassroomsProvider.future);
      final entry = mine
          .where((m) => m.classroom.id == classroomId)
          .firstOrNull;
      if (entry == null) return false;
      return daily ? entry.isHomeroom : entry.assignments.isNotEmpty;
    },
  ),
);

final attendanceSheetProvider = FutureProvider.autoDispose
    .family<AttendanceSheetModel, AttendanceSheetKey>(
      (ref, key) async =>
          (await ref.watch(attendanceRepositoryProvider).sheet(key))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Faltas da turma ainda sem justificação (a mais recente primeiro).
final unjustifiedAbsencesProvider = FutureProvider.autoDispose
    .family<List<AttendanceRecordModel>, String>((ref, classroomId) async {
      final records = <AttendanceRecordModel>[];
      var page = 1;
      while (true) {
        final result =
            (await ref
                    .watch(attendanceRepositoryProvider)
                    .records(
                      page: page++,
                      classroomId: classroomId,
                      status: AttendanceStatus.absent,
                    ))
                .getOrThrow();
        records.addAll(result.items);
        if (!result.meta.hasNext) break;
      }
      return [
        for (final r in records)
          if ((r.justification ?? '').trim().isEmpty) r,
      ];
    }, retry: (_, _) => null);

final attendanceSettingsProvider =
    FutureProvider.autoDispose<AttendanceSettingsModel>(
      (ref) async => (await ref.watch(attendanceRepositoryProvider).settings())
          .getOrThrow(),
      retry: (_, _) => null,
    );

final attendanceAlertsProvider = FutureProvider.autoDispose
    .family<List<AttendanceAlertModel>, String>(
      (ref, classroomId) async =>
          (await ref
                  .watch(attendanceRepositoryProvider)
                  .alerts(classroomId: classroomId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Alunos da turma (ordem alfabética).
final attendanceRosterProvider = FutureProvider.autoDispose
    .family<List<StudentModel>, String>((ref, classroomId) async {
      final repository = ref.watch(studentRepositoryProvider);
      final students = <StudentModel>[];
      var page = 1;
      while (true) {
        final result = (await repository.list(
          StudentQuery(page: page++, pageSize: 100, classroomId: classroomId),
        )).getOrThrow();
        students.addAll(result.items);
        if (!result.meta.hasNext) return students;
      }
    }, retry: (_, _) => null);

/// Gravação, justificação, limite e aviso ao encarregado.
class AttendanceActions {
  AttendanceActions(this._ref);

  final Ref _ref;

  AttendanceRepository get _repo => _ref.read(attendanceRepositoryProvider);

  Future<Result<AttendanceSheetModel>> save(
    AttendanceSheetKey key,
    List<AttendanceRecordModel> rows,
  ) async {
    final result = await _repo.save(key, rows);
    if (result is Ok) {
      _ref
        ..invalidate(attendanceSheetProvider(key))
        ..invalidate(attendanceAlertsProvider(key.classroomId))
        ..invalidate(unjustifiedAbsencesProvider(key.classroomId));
    }
    return result;
  }

  Future<Result<AttendanceRecordModel>> justify(
    AttendanceRecordModel record,
    String reason,
  ) async {
    final result = await _repo.justify(record.id, reason);
    if (result is Ok) {
      _ref
        ..invalidate(attendanceAlertsProvider(record.classroomId))
        ..invalidate(unjustifiedAbsencesProvider(record.classroomId))
        ..invalidate(attendanceSheetProvider);
    }
    return result;
  }

  Future<Result<AttendanceSettingsModel>> updateLimit(int limit) async {
    final result = await _repo.updateSettings(
      AttendanceSettingsModel(absenceLimit: limit),
    );
    if (result is Ok) {
      _ref
        ..invalidate(attendanceSettingsProvider)
        ..invalidate(attendanceAlertsProvider);
    }
    return result;
  }

  /// Avisa o encarregado pelo módulo `communication`. `false` se o módulo não
  /// estiver licenciado ou o envio falhar.
  Future<bool> notifyGuardian(AttendanceAlertModel alert) async {
    if (!_ref.read(enabledModulesProvider).contains('communication')) {
      return false;
    }
    final result = await _ref
        .read(notificationServiceProvider)
        .send(
          NotificationRequest(
            sourceModule: 'attendance',
            recipientIds: [alert.studentId],
            title: 'Limite de faltas atingido',
            body:
                'O educando tem ${alert.unjustified} faltas injustificadas '
                '(limite: ${alert.limit}).',
            data: {'studentId': alert.studentId},
          ),
        );
    return result is Ok;
  }
}

final attendanceActionsProvider = Provider<AttendanceActions>(
  AttendanceActions.new,
);
