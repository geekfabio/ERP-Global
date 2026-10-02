import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/invoice_repository.dart';
import '../models/billing_enums.dart';
import '../models/credit_note.dart';
import '../models/invoice.dart';

class ApiInvoiceRepository implements InvoiceRepository {
  ApiInvoiceRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<Invoice>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    InvoiceStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/invoices',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        'filter[status]': ?status?.name,
      },
    );
    return ApiEnvelope.page(response, Invoice.fromJson);
  });

  @override
  Future<Result<Invoice>> issue({
    required String studentId,
    required List<String> chargeIds,
    required int taxRateBp,
    String? exemptionReason,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/invoices',
      data: {
        'studentId': studentId,
        'chargeIds': chargeIds,
        'taxRateBp': taxRateBp,
        'exemptionReason': ?exemptionReason,
      },
    );
    return ApiEnvelope.object(response, Invoice.fromJson);
  });

  @override
  Future<Result<InvoiceCancellation>> cancel(
    String id, {
    required String reason,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/invoices/$id/cancel',
      data: {'reason': reason},
    );
    final data = ApiEnvelope.data(response)! as Map<String, dynamic>;
    return InvoiceCancellation(
      invoice: Invoice.fromJson(data['invoice'] as Map<String, dynamic>),
      creditNote: CreditNote.fromJson(
        data['creditNote'] as Map<String, dynamic>,
      ),
    );
  });

  @override
  Future<Result<PagedList<CreditNote>>> creditNotes({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/credit-notes',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[invoiceId]': ?invoiceId,
      },
    );
    return ApiEnvelope.page(response, CreditNote.fromJson);
  });
}
