import '../../../../core/utils/seed_generator.dart';
import '../models/card_model.dart';

/// Cartões de desenvolvimento (mesma seed → mesmos dados): maioria activos,
/// alguns bloqueados e uma 2.ª via (o original fica `replaced`).
List<CardModel> buildCardsSeed({int seed = 64, int count = 24}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 9, 1);
  final cards = <CardModel>[];
  for (var i = 0; i < count; i++) {
    cards.add(
      CardModel(
        id: gen.ulid(at.add(Duration(hours: i))),
        uid: 'RFID-${1000 + i}',
        holderId: gen.ulid(at.add(Duration(minutes: i))),
        holderName: gen.fullName(),
        holderType: i % 6 == 5 ? CardHolderType.staff : CardHolderType.student,
        status: i % 8 == 7 ? CardStatus.blocked : CardStatus.active,
        issuedAt: at.add(Duration(days: i)),
      ),
    );
  }
  // 2.ª via do primeiro cartão: o original deixa de estar activo.
  final first = cards.first;
  cards[0] = first.copyWith(status: CardStatus.replaced);
  cards.add(
    first.copyWith(
      id: gen.ulid(at.add(const Duration(days: 60))),
      uid: 'RFID-${1000 + count}',
      status: CardStatus.active,
      issuedAt: at.add(const Duration(days: 60)),
      replacesId: first.id,
    ),
  );
  return cards;
}
