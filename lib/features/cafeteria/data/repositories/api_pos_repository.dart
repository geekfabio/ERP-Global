import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/pos_repository.dart';
import '../../domain/pos_sale.dart';
import '../../domain/wallet_repository.dart';
import '../models/wallet.dart';
import 'api_wallet_repository.dart';

/// Reúne cartão (`cards`), carteira e ficha de saúde (`students`) por HTTP e
/// sem importar modelos de outros módulos: lê só os campos de que precisa.
class ApiPosRepository implements PosRepository {
  ApiPosRepository(this._client, [WalletRepository? wallets])
    : _wallets = wallets ?? ApiWalletRepository(_client);

  final ApiClient _client;
  final WalletRepository _wallets;

  @override
  Future<Result<PosCustomer>> identifyCard(String uid) =>
      Result.guard(() async {
        final key = uid.trim().toUpperCase();
        final response = await _client.dio.get<dynamic>(
          '/v1/cards',
          queryParameters: {'q': key, 'pageSize': 100},
        );
        final cards = ApiEnvelope.page(response, (j) => j).items;
        final card = cards.where((c) => c['uid'] == key).firstOrNull;
        if (card == null || card['status'] == 'replaced') {
          throw UnknownFailure(
            code: 'NOT_FOUND',
            message: 'Cartão não reconhecido',
          );
        }
        return _build(
          holderId: '${card['holderId']}',
          cardUid: key,
          cardBlocked: card['status'] == 'blocked',
        );
      });

  @override
  Future<Result<PosCustomer>> identifyHolder(String holderId) =>
      Result.guard(() => _build(holderId: holderId));

  Future<PosCustomer> _build({
    required String holderId,
    String? cardUid,
    bool cardBlocked = false,
  }) async {
    final response = await _client.dio.get<dynamic>(
      '/v1/wallets',
      queryParameters: {'filter[holderId]': holderId, 'pageSize': 1},
    );
    final wallet = ApiEnvelope.page(
      response,
      Wallet.fromJson,
    ).items.firstOrNull;
    if (wallet == null) {
      throw UnknownFailure(
        code: 'NOT_FOUND',
        message: 'O titular não tem carteira',
      );
    }
    final student = await _student(holderId);
    final now = DateTime.now().toUtc();
    final txs = (await _wallets.statement(
      wallet.id,
      pageSize: 100,
      from: DateTime.utc(now.year, now.month, now.day),
    )).getOrThrow().items;
    return PosCustomer(
      holderId: holderId,
      holderName: wallet.holderName,
      wallet: wallet,
      cardUid: cardUid,
      cardBlocked: cardBlocked,
      allergies: student.allergies,
      className: student.className,
      spentTodayMinor: netSpent(txs),
    );
  }

  /// Alergias (ficha de saúde) e turma; sem ficha (ex.: funcionário) → vazio.
  Future<({List<String> allergies, String? className})> _student(
    String holderId,
  ) async {
    try {
      final response = await _client.dio.get<dynamic>('/v1/students/$holderId');
      final data = ApiEnvelope.object(response, (j) => j);
      final health = data['health'];
      final list = health is Map ? health['allergies'] : null;
      final name = data['className'];
      return (
        allergies: list is List ? [for (final a in list) '$a'] : <String>[],
        className: name is String && name.isNotEmpty ? name : null,
      );
    } on Object {
      return (allergies: <String>[], className: null);
    }
  }
}

/// Consumo líquido de [todayTxs]: consumos menos estornos desses consumos.
int netSpent(List<WalletTransaction> todayTxs) {
  final purchases = {
    for (final t in todayTxs)
      if (t.type == WalletTransactionType.purchase) t.id: t.amountMinor,
  };
  final refunded = todayTxs
      .where(
        (t) =>
            t.type == WalletTransactionType.refund &&
            purchases.containsKey(t.refundOfId),
      )
      .fold<int>(0, (s, t) => s + t.amountMinor);
  return purchases.values.fold<int>(0, (s, v) => s + v) - refunded;
}
