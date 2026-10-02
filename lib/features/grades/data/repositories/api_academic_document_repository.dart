import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/academic_document_repository.dart';
import '../models/academic_document_models.dart';

class ApiAcademicDocumentRepository implements AcademicDocumentRepository {
  ApiAcademicDocumentRepository(this._client);

  final ApiClient _client;

  static const _path = '/v1/academic-documents';
  static const _templates = '/v1/document-templates';

  @override
  Future<Result<List<DocumentTemplateModel>>> templates() => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(_templates),
      DocumentTemplateModel.fromJson,
    ).items,
  );

  @override
  Future<Result<DocumentTemplateModel>> updateTemplate(
    String id,
    String body,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>('$_templates/$id', data: {'body': body}),
      DocumentTemplateModel.fromJson,
    ),
  );

  @override
  Future<Result<PagedList<AcademicDocumentModel>>> list({
    int page = 1,
    int pageSize = 100,
    DocumentKind? kind,
    DocumentStatus? status,
    String? studentId,
  }) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        _path,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'sort': '-requestedAt',
          'filter[kind]': ?kind?.name,
          'filter[status]': ?status?.name,
          'filter[studentId]': ?studentId,
        },
      ),
      AcademicDocumentModel.fromJson,
    ),
  );

  @override
  Future<Result<AcademicDocumentModel>> request({
    required DocumentKind kind,
    required String studentId,
    required String studentName,
    required String processNumber,
    required String purpose,
    required Map<String, String> variables,
  }) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        _path,
        data: {
          'kind': kind.name,
          'studentId': studentId,
          'studentName': studentName,
          'processNumber': processNumber,
          'purpose': purpose,
          'variables': variables,
        },
      ),
      AcademicDocumentModel.fromJson,
    ),
  );

  @override
  Future<Result<AcademicDocumentModel>> issue(String id) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('$_path/$id/issue'),
      AcademicDocumentModel.fromJson,
    ),
  );

  @override
  Future<Result<AcademicDocumentModel>> cancel(String id) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('$_path/$id/cancel'),
      AcademicDocumentModel.fromJson,
    ),
  );

  @override
  Future<Result<DocumentVerificationModel>> verify(String number) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.get<dynamic>(
            '$_path/verify',
            queryParameters: {'number': number},
          ),
          DocumentVerificationModel.fromJson,
        ),
      );
}
