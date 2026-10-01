import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/wallet_seed.dart';
import '../models/wallet.dart';

/// Handlers de `/v1/wallets` (docs/07-mock-api.md). Estado mutável em memória;
/// `POST /__mock/reset` repõe o seed. O saldo nunca fica negativo.
class WalletMockHandlers implements MockApiModule {
  WalletMockHandlers({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final DateTime Function() _clock;

  static final _ulid = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');
  static const _methods = {
    'cash',
    'bank_transfer',
    'card',
    'payment_reference',
  };

  late Map<String, Wallet> _wallets;
  late List<WalletTransaction> _txs;
  late SeedGenerator _ids;

  void _reset() {
    _ids = SeedGenerator(650);
    final seed = buildWalletSeed();
    _wallets = {for (final w in seed.wallets) w.id: w};
    _txs = [...seed.transactions];
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/wallets', _list)
      ..post('/v1/wallets', _open)
      ..get('/v1/wallets/{id}', (req) => MockResponse.ok(_find(req).toJson()))
      ..patch('/v1/wallets/{id}', _setLimit)
      ..post('/v1/wallets/{id}/block', (req) => _setBlocked(req, true))
      ..post('/v1/wallets/{id}/unblock', (req) => _setBlocked(req, false))
      ..get('/v1/wallets/{id}/transactions', _statement)
      ..post('/v1/wallets/{id}/topups', _topUp)
      ..post('/v1/wallets/{id}/purchases', _purchase)
      ..post('/v1/wallets/{id}/refunds', _refund);
  }

  late final _walletSpec = MockListSpec<Wallet>(
    searchText: (w) => w.holderName,
    sortable: {
      'holderName': (w) => foldText(w.holderName),
      'balanceMinor': (w) => w.balanceMinor,
    },
    filterable: {
      'blocked': (w) => '${w.blocked}',
      'holderId': (w) => w.holderId,
    },
    defaultSort: const ['holderName'],
  );

  late final _txSpec = MockListSpec<WalletTransaction>(
    filterable: {'type': (t) => t.type.name},
  );

  MockResponse _list(MockRequest req) => mockPaginate(
    _wallets.values,
    req,
    toJson: (w) => w.toJson(),
    spec: _walletSpec,
  );

  Wallet _find(MockRequest req) =>
      _wallets[req.params['id']] ?? (throw const MockApiException.notFound());

  MockResponse _save(Wallet w) {
    _wallets[w.id] = w;
    return MockResponse.ok(w.toJson());
  }

  int _amount(Map<String, dynamic> body, {bool allowZero = false}) {
    final v = body['amountMinor'];
    MockValidator(body)
      ..check(
        'amountMinor',
        v is int && (allowZero ? v >= 0 : v > 0),
        'Indique um valor positivo',
      )
      ..throwIfInvalid();
    return v as int;
  }

  MockResponse _open(MockRequest req) {
    final body = req.jsonBody;
    final limit = body['dailyLimitMinor'] ?? 0;
    MockValidator(body)
      ..required('holderName')
      ..check(
        'holderId',
        _ulid.hasMatch('${body['holderId']}'),
        'Indique o ULID do titular',
      )
      ..check('dailyLimitMinor', limit is int && limit >= 0, 'Limite inválido')
      ..throwIfInvalid();
    final holderId = '${body['holderId']}';
    if (_wallets.values.any((w) => w.holderId == holderId)) {
      throw const MockApiException.conflict('O titular já tem carteira');
    }
    final now = _clock();
    final wallet = Wallet(
      id: _ids.ulid(now),
      holderId: holderId,
      holderName: '${body['holderName']}'.trim(),
      dailyLimitMinor: limit as int,
      createdAt: now,
      updatedAt: now,
    );
    _wallets[wallet.id] = wallet;
    return MockResponse.created(wallet.toJson());
  }

  MockResponse _setLimit(MockRequest req) {
    final w = _find(req);
    final v = req.jsonBody['dailyLimitMinor'];
    MockValidator(req.jsonBody)
      ..check('dailyLimitMinor', v is int && v >= 0, 'Limite inválido')
      ..throwIfInvalid();
    return _save(w.copyWith(dailyLimitMinor: v as int, updatedAt: _clock()));
  }

  MockResponse _setBlocked(MockRequest req, bool blocked) {
    final w = _find(req);
    return _save(w.copyWith(blocked: blocked, updatedAt: _clock()));
  }

  MockResponse _statement(MockRequest req) {
    final w = _find(req);
    final from = DateTime.tryParse(req.query['from'] ?? '');
    final to = DateTime.tryParse(req.query['to'] ?? '');
    final items = _txs
        .where((t) => t.walletId == w.id)
        .where((t) {
          if (from != null && t.occurredAt.isBefore(from)) return false;
          if (to != null && t.occurredAt.isAfter(to)) return false;
          return true;
        })
        .toList()
        .reversed;
    return mockPaginate(items, req, toJson: (t) => t.toJson(), spec: _txSpec);
  }

  WalletTransaction _record(
    Wallet w,
    WalletTransactionType type,
    int amount, {
    String? method,
    String? reference,
    String? description,
    String? refundOfId,
  }) {
    final signed = type == WalletTransactionType.purchase ? -amount : amount;
    final after = w.balanceMinor + signed;
    // Invariante: o saldo nunca fica negativo.
    if (after < 0) {
      throw const MockApiException.validation({
        'amountMinor': 'Saldo insuficiente',
      }, 'Saldo insuficiente');
    }
    final now = _clock();
    final tx = WalletTransaction(
      id: _ids.ulid(now),
      walletId: w.id,
      type: type,
      amountMinor: amount,
      balanceAfterMinor: after,
      occurredAt: now,
      method: method,
      reference: reference,
      description: description,
      refundOfId: refundOfId,
    );
    _txs.add(tx);
    _wallets[w.id] = w.copyWith(balanceMinor: after, updatedAt: now);
    return tx;
  }

  MockResponse _topUp(MockRequest req) {
    final w = _find(req);
    final body = req.jsonBody;
    final amount = _amount(body);
    MockValidator(body)
      ..check('method', _methods.contains(body['method']), 'Método inválido')
      ..throwIfInvalid();
    final tx = _record(
      w,
      WalletTransactionType.topup,
      amount,
      method: '${body['method']}',
      reference: body['reference'] as String?,
    );
    return MockResponse.created(tx.toJson());
  }

  /// Consumido hoje (UTC): consumos menos estornos desses consumos.
  int _spentToday(Wallet w) {
    final now = _clock();
    bool today(DateTime d) =>
        d.year == now.year && d.month == now.month && d.day == now.day;
    final mine = _txs.where((t) => t.walletId == w.id).toList();
    final todayPurchases = {
      for (final t in mine)
        if (t.type == WalletTransactionType.purchase && today(t.occurredAt))
          t.id: t.amountMinor,
    };
    final refunded = mine
        .where(
          (t) =>
              t.type == WalletTransactionType.refund &&
              todayPurchases.containsKey(t.refundOfId),
        )
        .fold<int>(0, (s, t) => s + t.amountMinor);
    return todayPurchases.values.fold<int>(0, (s, v) => s + v) - refunded;
  }

  MockResponse _purchase(MockRequest req) {
    final w = _find(req);
    final amount = _amount(req.jsonBody);
    if (w.blocked) {
      throw const MockApiException.conflict('Carteira bloqueada');
    }
    if (w.dailyLimitMinor > 0 && _spentToday(w) + amount > w.dailyLimitMinor) {
      throw const MockApiException.conflict('Limite diário excedido');
    }
    final tx = _record(
      w,
      WalletTransactionType.purchase,
      amount,
      description: req.jsonBody['description'] as String?,
    );
    return MockResponse.created(tx.toJson());
  }

  MockResponse _refund(MockRequest req) {
    final w = _find(req);
    final id = req.jsonBody['transactionId'];
    final original = _txs
        .where(
          (t) =>
              t.id == id &&
              t.walletId == w.id &&
              t.type == WalletTransactionType.purchase,
        )
        .firstOrNull;
    if (original == null) throw const MockApiException.notFound();
    if (_txs.any((t) => t.refundOfId == original.id)) {
      throw const MockApiException.conflict('Consumo já estornado');
    }
    final tx = _record(
      w,
      WalletTransactionType.refund,
      original.amountMinor,
      description: req.jsonBody['reason'] as String?,
      refundOfId: original.id,
    );
    return MockResponse.created(tx.toJson());
  }
}
