import 'dart:convert';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../academic/data/repositories/api_academic_repositories.dart';
import '../../domain/payroll_repository.dart';
import '../models/payroll_models.dart';

AttendanceRepository apiAttendanceRepository(ApiClient c) =>
    ApiAcademicRepository(
      c,
      '/v1/hr-attendance',
      fromJson: AttendanceRecord.fromJson,
      toJson: (v) => v.toJson(),
    );

LeaveRepository apiLeaveRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/leaves',
  fromJson: LeaveModel.fromJson,
  toJson: (v) => v.toJson(),
);

/// Recibos: só leitura (gerados pelo processamento da folha).
PayslipRepository apiPayslipRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/payslips',
  fromJson: Payslip.fromJson,
  toJson: (v) => v.toJson(),
);

class ApiPayrollRepository implements PayrollRepository {
  ApiPayrollRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PayrollSettings>> settings() => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>('/v1/payroll-settings'),
      PayrollSettings.fromJson,
    ),
  );

  @override
  Future<Result<PayrollSettings>> updateSettings(PayrollSettings value) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.patch<dynamic>(
            '/v1/payroll-settings',
            // `toJson` não converte os escalões aninhados.
            data: jsonDecode(jsonEncode(value)),
          ),
          PayrollSettings.fromJson,
        ),
      );

  @override
  Future<Result<PayrollRunSummary>> run(String month) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        '/v1/payroll-runs',
        data: {'month': month},
      ),
      PayrollRunSummary.fromJson,
    ),
  );
}
