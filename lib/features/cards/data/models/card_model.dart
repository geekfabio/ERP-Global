import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

/// Estado do cartão: só um cartão `active` por titular.
enum CardStatus { active, blocked, replaced }

/// Quem usa o cartão (o cartão é único para aluno e funcionário).
enum CardHolderType { student, staff }

/// Cartão escolar (RFID/NFC/QR) — docs/03-funcionalidades.md.
@freezed
abstract class CardModel with _$CardModel {
  const factory CardModel({
    required String id,

    /// Identificador lido pelo cartão (único).
    required String uid,
    required String holderId,
    required String holderName,
    required CardHolderType holderType,
    @Default(CardStatus.active) CardStatus status,
    @UtcDateTimeConverter() required DateTime issuedAt,

    /// Cartão que esta 2.ª via substitui.
    String? replacesId,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
}
