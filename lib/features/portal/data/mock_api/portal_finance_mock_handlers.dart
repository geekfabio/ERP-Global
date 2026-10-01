import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../auth/data/data_mocks/auth_mock_data.dart';
import '../../../students/data/data_mocks/student_summaries_seed.dart';
import '../../domain/portal_finance_metrics.dart';
import '../models/portal_finance_models.dart';
import 'portal_mock_handlers.dart';

/// Handlers de leitura financeira do portal (`/v1/portal/pupils/{id}/...`).
/// Só devolve dados de educandos vinculados à conta (403 caso contrário).
class PortalFinanceMockHandlers implements MockApiModule {
  PortalFinanceMockHandlers({
    required this.authenticate,
    required this.pupilsFor,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _summaries = StudentSummariesSeed(now: clock?.call());

  final MockAccount Function(MockRequest request) authenticate;
  final List<PortalPupilRecord> Function(
    String userId, {
    required bool isStudent,
  })
  pupilsFor;
  final StudentSummariesSeed _summaries;
  final DateTime Function() _clock;

  @override
  void register(MockApiRegistry r) {
    r
      ..get('/v1/portal/pupils/{id}/finance', _finance)
      ..post('/v1/portal/pupils/{id}/payment-references', _reference)
      ..get('/v1/portal/pupils/{id}/card', _card);
  }

  String _scopedId(MockRequest req) {
    final account = authenticate(req);
    final perms = account.permissions;
    final isStudent = perms.contains('portal.self.read');
    if (!isStudent && !perms.contains('portal.child.read')) {
      throw const MockApiException.forbidden();
    }
    final id = req.params['id'];
    final linked = pupilsFor(account.user.id, isStudent: isStudent);
    if (id == null || !linked.any((p) => p.student.id == id)) {
      throw const MockApiException.forbidden(
        'Educando não vinculado a esta conta',
      );
    }
    return id;
  }

  MockResponse _finance(MockRequest req) {
    final id = _scopedId(req);
    final finance = _summaries.finance(id);
    final receipts = [
      for (final c in finance.charges.where((c) => c.paidMinor > 0))
        PortalReceipt(
          id: 'rec-${c.id}',
          number: 'RC ${c.dueOn.year}/${c.id.split('-')[1].padLeft(4, '0')}',
          description: c.description,
          issuedAt: c.dueOn.add(const Duration(days: 2, hours: 10)),
          amountMinor: c.paidMinor,
        ),
    ]..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
    return MockResponse.ok({
      'charges': [for (final c in finance.charges) c.toJson()],
      'receipts': [for (final r in receipts) r.toJson()],
    });
  }

  MockResponse _reference(MockRequest req) {
    final id = _scopedId(req);
    final wanted = [
      for (final v in (req.jsonBody['chargeIds'] as List? ?? const []))
        v.toString(),
    ];
    final payable = payableCharges(
      _summaries.finance(id).charges,
    ).where((c) => wanted.isEmpty || wanted.contains(c.id)).toList();
    final amount = totalOutstandingMinor(payable);
    if (amount <= 0) {
      throw const MockApiException.conflict('Não há valores por pagar');
    }
    return MockResponse.created({
      'entity': '11223',
      'reference': buildPaymentReference(id, amount),
      'amountMinor': amount,
      'validUntil': _clock()
          .toUtc()
          .add(const Duration(days: 5))
          .toIso8601String(),
    });
  }

  MockResponse _card(MockRequest req) {
    final id = _scopedId(req);
    final card = _summaries.card(id);
    final now = _clock().toUtc();
    final entries = <PortalCardEntry>[];
    var after = card.mealBalanceMinor;
    for (var i = 0; i < 8; i++) {
      final topup = i.isOdd && after >= 20000;
      final amount = topup ? 20000 : 2500 + (i % 3) * 500;
      entries.add(
        PortalCardEntry(
          id: 'mv-$i-$id',
          kind: topup
              ? PortalCardEntryKind.topup
              : PortalCardEntryKind.purchase,
          at: DateTime.utc(
            now.year,
            now.month,
            now.day,
            12,
          ).subtract(Duration(days: i + 1)),
          amountMinor: amount,
          balanceAfterMinor: after,
          description: topup ? 'Carregamento' : 'Refeição: almoço',
        ),
      );
      after += topup ? -amount : amount;
    }
    return MockResponse.ok({
      'cardNumber': card.cardNumber,
      'status': card.status?.name,
      'balanceMinor': card.mealBalanceMinor,
      'entries': [for (final e in entries) e.toJson()],
      'access': [for (final a in card.recentAccess) a.toJson()],
    });
  }
}
