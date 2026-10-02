import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/discount.dart';

/// Descontos e bolsas com aprovação.
abstract interface class DiscountRepository {
  Future<Result<PagedList<Discount>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    DiscountStatus? status,
  });

  /// Pede um desconto (fica `pending`). [value] em pontos base (percentagem)
  /// ou menor unidade (valor fixo). 422 em dados inválidos.
  Future<Result<Discount>> request({
    required String studentId,
    required DiscountKind kind,
    required DiscountReason reason,
    required int value,
    FeeType? feeType,
    required DateTime validFrom,
    DateTime? validUntil,
    String? note,
  });

  /// Aprova um desconto pendente e reflecte-o nas cobranças em aberto do
  /// aluno. 409 se já foi decidido.
  Future<Result<Discount>> approve(String id, {String? note});

  /// Rejeita um desconto pendente. 409 se já foi decidido.
  Future<Result<Discount>> reject(String id, {String? note});

  /// Revoga um desconto aprovado e retira-o das cobranças em aberto. 409 se
  /// não estiver aprovado.
  Future<Result<Discount>> revoke(String id, {String? note});
}
