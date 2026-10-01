import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/cards_seed.dart';
import '../models/card_model.dart';

/// Handlers de `/v1/cards` (docs/07-mock-api.md). Estado mutável em memória;
/// `POST /__mock/reset` repõe o seed.
class CardsMockHandlers implements MockApiModule {
  CardsMockHandlers() {
    _reset();
  }

  static final _ulid = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');
  static const _holderTypes = {'student', 'staff'};

  late Map<String, CardModel> _cards;
  late SeedGenerator _ids;

  void _reset() {
    _ids = SeedGenerator(640);
    _cards = {for (final c in buildCardsSeed()) c.id: c};
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/cards', _list)
      ..post('/v1/cards', _issue)
      ..post('/v1/cards/{id}/block', _block)
      ..post('/v1/cards/{id}/replace', _replace)
      ..post('/v1/cards/{id}/associate', _associate);
  }

  late final _spec = MockListSpec<CardModel>(
    searchText: (c) => '${c.uid} ${c.holderName}',
    sortable: {
      'uid': (c) => c.uid,
      'holderName': (c) => foldText(c.holderName),
      'issuedAt': (c) => c.issuedAt,
    },
    filterable: {'status': (c) => c.status.name, 'holderId': (c) => c.holderId},
    defaultSort: const ['-issuedAt'],
  );

  MockResponse _list(MockRequest req) =>
      mockPaginate(_cards.values, req, toJson: (c) => c.toJson(), spec: _spec);

  CardModel _find(MockRequest req) =>
      _cards[req.params['id']] ?? (throw const MockApiException.notFound());

  void _validateHolder(Map<String, dynamic> body) => MockValidator(body)
    ..required('holderName')
    ..required('holderId')
    ..check(
      'holderId',
      !body.containsKey('holderId') || _ulid.hasMatch('${body['holderId']}'),
      'Indique o ULID do titular',
    )
    ..check(
      'holderType',
      _holderTypes.contains(body['holderType']),
      'Tipo de titular inválido',
    )
    ..throwIfInvalid();

  /// Valida o UID e devolve-o normalizado; 409 se já foi emitido.
  String _newUid(Map<String, dynamic> body) {
    MockValidator(body)
      ..required('uid')
      ..throwIfInvalid();
    final uid = '${body['uid']}'.trim().toUpperCase();
    if (_cards.values.any((c) => c.uid == uid)) {
      throw const MockApiException.conflict('UID já emitido');
    }
    return uid;
  }

  /// Um cartão activo por titular (409 se [holderId] já tem outro).
  void _ensureSingleActive(String holderId, {String? except}) {
    final taken = _cards.values.any(
      (c) =>
          c.id != except &&
          c.holderId == holderId &&
          c.status == CardStatus.active,
    );
    if (taken) {
      throw const MockApiException.conflict(
        'O titular já tem um cartão activo',
      );
    }
  }

  MockResponse _issue(MockRequest req) {
    final body = req.jsonBody;
    final uid = _newUid(body);
    _validateHolder(body);
    final holderId = '${body['holderId']}';
    _ensureSingleActive(holderId);
    final now = DateTime.now().toUtc();
    final card = CardModel(
      id: _ids.ulid(now),
      uid: uid,
      holderId: holderId,
      holderName: '${body['holderName']}'.trim(),
      holderType: CardHolderType.values.byName('${body['holderType']}'),
      issuedAt: now,
    );
    _cards[card.id] = card;
    return MockResponse.created(card.toJson());
  }

  MockResponse _block(MockRequest req) {
    final card = _find(req);
    if (card.status != CardStatus.active) {
      throw const MockApiException.conflict(
        'Só um cartão activo pode ser bloqueado',
      );
    }
    return _save(card.copyWith(status: CardStatus.blocked));
  }

  MockResponse _replace(MockRequest req) {
    final old = _find(req);
    if (old.status == CardStatus.replaced) {
      throw const MockApiException.conflict('O cartão já foi substituído');
    }
    final uid = _newUid(req.jsonBody);
    _ensureSingleActive(old.holderId, except: old.id);
    final now = DateTime.now().toUtc();
    final card = old.copyWith(
      id: _ids.ulid(now),
      uid: uid,
      status: CardStatus.active,
      issuedAt: now,
      replacesId: old.id,
    );
    _cards[old.id] = old.copyWith(status: CardStatus.replaced);
    _cards[card.id] = card;
    return MockResponse.created(card.toJson());
  }

  MockResponse _associate(MockRequest req) {
    final card = _find(req);
    if (card.status == CardStatus.replaced) {
      throw const MockApiException.conflict('O cartão já foi substituído');
    }
    final body = req.jsonBody;
    _validateHolder(body);
    final holderId = '${body['holderId']}';
    if (card.status == CardStatus.active) {
      _ensureSingleActive(holderId, except: card.id);
    }
    return _save(
      card.copyWith(
        holderId: holderId,
        holderName: '${body['holderName']}'.trim(),
        holderType: CardHolderType.values.byName('${body['holderType']}'),
      ),
    );
  }

  MockResponse _save(CardModel card) {
    _cards[card.id] = card;
    return MockResponse.ok(card.toJson());
  }
}
