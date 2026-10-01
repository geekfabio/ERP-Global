import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/cards/data/mock_api/cards_mock_handlers.dart';
import 'package:erp_global/features/cards/data/models/card_model.dart';
import 'package:erp_global/features/cards/data/repositories/api_card_repository.dart';
import 'package:flutter_test/flutter_test.dart';

const _holder = '01JKHMPQT000000000000000A1';
const _other = '01JKHMPQT000000000000000A2';

ApiCardRepository _repo() {
  final registry = MockApiRegistry()..addModule(CardsMockHandlers());
  return ApiCardRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

Future<CardModel> _issue(
  ApiCardRepository r,
  String uid, [
  String holder = _holder,
]) async => (await r.issue(
  uid: uid,
  holderId: holder,
  holderName: 'Ana Silva',
  holderType: CardHolderType.student,
)).getOrThrow();

void main() {
  test('lista paginada com filtro por estado', () async {
    final r = _repo();
    final page = (await r.list(pageSize: 10)).getOrThrow();
    expect(page.items, hasLength(10));
    expect(page.meta.total, greaterThan(10));
    final blocked = (await r.list(status: CardStatus.blocked)).getOrThrow();
    expect(blocked.items, isNotEmpty);
    expect(blocked.items.every((c) => c.status == CardStatus.blocked), isTrue);
  });

  test('emitir: UID em maiúsculas e um cartão activo por titular', () async {
    final r = _repo();
    final card = await _issue(r, 'abc-1');
    expect(card.uid, 'ABC-1');
    expect(card.status, CardStatus.active);
    final dupHolder = await r.issue(
      uid: 'ABC-2',
      holderId: _holder,
      holderName: 'Ana Silva',
      holderType: CardHolderType.student,
    );
    expect(dupHolder.failureOrNull?.code, 'CONFLICT');
    final dupUid = await r.issue(
      uid: 'abc-1',
      holderId: _other,
      holderName: 'Rui',
      holderType: CardHolderType.staff,
    );
    expect(dupUid.failureOrNull?.code, 'CONFLICT');
  });

  test('emitir valida campos (422)', () async {
    final r = _repo();
    final res = await r.issue(
      uid: '',
      holderId: 'x',
      holderName: '',
      holderType: CardHolderType.student,
    );
    expect(res.failureOrNull?.code, 'VALIDATION_ERROR');
  });

  test('bloquear liberta o titular para novo cartão', () async {
    final r = _repo();
    final card = await _issue(r, 'B-1');
    final blocked = (await r.block(card.id)).getOrThrow();
    expect(blocked.status, CardStatus.blocked);
    expect((await r.block(card.id)).failureOrNull?.code, 'CONFLICT');
    expect(await _issue(r, 'B-2'), isA<CardModel>());
  });

  test('2.ª via substitui o original e herda o titular', () async {
    final r = _repo();
    final card = await _issue(r, 'C-1');
    final second = (await r.replace(card.id, uid: 'C-2')).getOrThrow();
    expect(second.replacesId, card.id);
    expect(second.holderId, _holder);
    final all = (await r.list(pageSize: 100, q: 'Ana')).getOrThrow().items;
    expect(all.firstWhere((c) => c.id == card.id).status, CardStatus.replaced);
    expect(
      (await r.replace(card.id, uid: 'C-3')).failureOrNull?.code,
      'CONFLICT',
    );
    expect(
      (await r.replace(
        '01JNAOEXISTE0000000000000A',
        uid: 'Z',
      )).failureOrNull?.code,
      'NOT_FOUND',
    );
  });

  test('associar respeita um activo por titular', () async {
    final r = _repo();
    final a = await _issue(r, 'D-1');
    await _issue(r, 'D-2', _other);
    final res = await r.associate(
      a.id,
      holderId: _other,
      holderName: 'Rui',
      holderType: CardHolderType.staff,
    );
    expect(res.failureOrNull?.code, 'CONFLICT');
    final free = (await r.associate(
      a.id,
      holderId: '01JKHMPQT000000000000000A3',
      holderName: 'Rui',
      holderType: CardHolderType.staff,
    )).getOrThrow();
    expect(free.holderName, 'Rui');
    expect(free.holderType, CardHolderType.staff);
  });
}
