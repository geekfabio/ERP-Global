import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/agenda_event_model.dart';
import '../data/models/announcement_model.dart';
import '../data/models/communication_enums.dart';

/// Comunicados. Erros chegam como `Failure` (`VALIDATION_ERROR`, `NOT_FOUND`…).
abstract interface class AnnouncementRepository {
  Future<Result<PagedList<AnnouncementModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    AnnouncementAudience? audience,
    AnnouncementStatus? status,
  });

  Future<Result<AnnouncementModel>> get(String id);

  /// Cria e, se `status == published`, entrega pelos canais escolhidos.
  Future<Result<AnnouncementModel>> create(AnnouncementModel announcement);

  /// Publica um rascunho.
  Future<Result<AnnouncementModel>> publish(String id);

  /// Confirma a leitura do utilizador [userId] (idempotente).
  Future<Result<AnnouncementReadModel>> confirmRead(
    String id, {
    required String userId,
  });

  Future<Result<List<AnnouncementReadModel>>> reads(String id);
}

/// Agenda escolar.
abstract interface class AgendaRepository {
  /// Eventos que começam em `[from, to)` (UTC), por ordem cronológica.
  Future<Result<PagedList<AgendaEventModel>>> list({
    int page = 1,
    int pageSize = 50,
    DateTime? from,
    DateTime? to,
    AgendaEventType? type,
  });

  Future<Result<AgendaEventModel>> create(AgendaEventModel event);
  Future<Result<AgendaEventModel>> update(AgendaEventModel event);
  Future<Result<void>> delete(String id);
}
