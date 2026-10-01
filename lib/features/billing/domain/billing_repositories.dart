import 'dart:async';

import '../../../core/errors/result.dart';
import '../../../core/events/domain_event.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/charge.dart';
import '../data/models/fee_item.dart';

/// Tabela de preços (ano lectivo × classe × campus × tipo).
abstract interface class FeeItemRepository {
  Future<Result<PagedList<FeeItem>>> list({
    int page = 1,
    int pageSize = 20,
    String? academicYearId,
    String? gradeId,
    FeeType? type,
  });

  /// 409 se já existe preço activo para a mesma combinação.
  Future<Result<FeeItem>> create(FeeItem item);

  /// Altera o valor e/ou o estado.
  Future<Result<FeeItem>> update(
    String id, {
    int? amountMinor,
    FeeItemStatus? status,
  });
}

/// Resultado da aplicação de multas/juros a uma cobrança em atraso.
class LateFeeApplication {
  const LateFeeApplication({
    required this.chargeId,
    required this.penaltyChargeId,
    required this.penaltyMinor,
  });

  final String chargeId;
  final String penaltyChargeId;
  final int penaltyMinor;
}

/// Plano de cobrança: geração de cobranças e multas por atraso.
abstract interface class BillingPlanRepository {
  Future<Result<PagedList<Charge>>> charges({
    int page = 1,
    int pageSize = 20,
    String? studentId,
  });

  /// Gera a taxa de matrícula e as prestações da propina. Idempotente por
  /// matrícula; 422 se a tabela de preços não cobre a classe.
  Future<Result<List<Charge>>> generateForEnrollment(EnrollmentConfirmed event);

  /// Marca como vencidas as cobranças em atraso e cria a multa de cada uma
  /// (uma só vez por cobrança).
  Future<Result<List<LateFeeApplication>>> applyLateFees({DateTime? asOf});
}

/// Reage à matrícula confirmada: gera as cobranças só se o módulo billing
/// estiver licenciado (o evento é ignorado em silêncio caso contrário).
class EnrollmentBillingListener {
  EnrollmentBillingListener({
    required DomainEventBus bus,
    required this.repository,
    required this.isLicensed,
  }) {
    _sub = bus.on<EnrollmentConfirmed>().listen(handle);
  }

  final BillingPlanRepository repository;
  final bool Function() isLicensed;
  late final StreamSubscription<EnrollmentConfirmed> _sub;

  /// Devolve `null` se ignorou o evento.
  Future<Result<List<Charge>>?> handle(EnrollmentConfirmed event) async {
    if (!isLicensed()) return null;
    return repository.generateForEnrollment(event);
  }

  Future<void> dispose() => _sub.cancel();
}
