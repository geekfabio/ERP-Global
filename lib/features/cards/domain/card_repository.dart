import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/card_model.dart';

/// Contrato do cartão escolar; a UI só conhece esta interface.
abstract interface class CardRepository {
  Future<Result<PagedList<CardModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    CardStatus? status,
  });

  /// Emite um cartão novo; 409 se o UID existe ou o titular já tem um activo.
  Future<Result<CardModel>> issue({
    required String uid,
    required String holderId,
    required String holderName,
    required CardHolderType holderType,
  });

  Future<Result<CardModel>> block(String id);

  /// 2.ª via: o cartão [id] passa a `replaced` e o novo herda o titular.
  Future<Result<CardModel>> replace(String id, {required String uid});

  /// Passa o cartão para outro titular.
  Future<Result<CardModel>> associate(
    String id, {
    required String holderId,
    required String holderName,
    required CardHolderType holderType,
  });
}
