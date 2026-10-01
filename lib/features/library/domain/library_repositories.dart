import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/library_models.dart';

/// Contrato do acervo e dos exemplares; a UI só conhece esta interface.
abstract interface class BookRepository {
  Future<Result<PagedList<BookModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
  });

  /// Regista a obra com [copies] exemplares; 409 se o ISBN já existe.
  Future<Result<BookModel>> create(BookModel book, {int copies = 1});

  Future<Result<List<CopyModel>>> copies(String bookId);

  /// Acrescenta um exemplar com o código de barras [barcode] (único).
  Future<Result<CopyModel>> addCopy(String bookId, {required String barcode});

  /// Marca como `lost`/`damaged` ou repõe `available`; 409 se emprestado.
  Future<Result<CopyModel>> setCopyStatus(String copyId, CopyStatus status);
}

/// Contrato de empréstimos, devoluções, multas e reservas.
abstract interface class CirculationRepository {
  Future<Result<PagedList<LoanModel>>> loans({
    int page = 1,
    int pageSize = 20,
    String? q,
    LoanStatus? status,
  });

  /// Empréstimo pelo cartão do leitor: 404 sem cartão/exemplar, 409 se o
  /// exemplar não está disponível, há multas por pagar ou o limite foi atingido.
  Future<Result<LoanModel>> checkout({
    required String cardUid,
    required String barcode,
  });

  /// Devolve o exemplar; gera multa se estava em atraso.
  Future<Result<LoanModel>> giveBack(String loanId);

  Future<Result<PagedList<FineModel>>> fines({
    int page = 1,
    int pageSize = 20,
    FineStatus? status,
  });

  Future<Result<FineModel>> payFine(String fineId);

  Future<Result<PagedList<ReservationModel>>> reservations({
    int page = 1,
    int pageSize = 20,
    ReservationStatus? status,
  });

  /// Reserva uma obra para o leitor do cartão; 409 se há exemplar disponível
  /// ou já tem reserva aberta.
  Future<Result<ReservationModel>> reserve({
    required String bookId,
    required String cardUid,
  });

  Future<Result<ReservationModel>> cancelReservation(String id);
}
