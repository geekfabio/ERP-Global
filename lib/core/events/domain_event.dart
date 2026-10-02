import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Evento de domínio publicado por um módulo e consumido por outros
/// (billing, cards…) sem dependência de código entre eles (AGENTS.md §2).
abstract class DomainEvent {
  const DomainEvent(this.occurredAt);

  final DateTime occurredAt;
}

/// Matrícula confirmada (aluno com turma atribuída). Os ids e o tipo seguem o
/// formato do servidor; o `core` não conhece os modelos de `students`.
class EnrollmentConfirmed extends DomainEvent {
  const EnrollmentConfirmed({
    required this.enrollmentId,
    required this.studentId,
    required this.academicYearId,
    required this.gradeId,
    required this.classroomId,
    required this.type,
    required this.feeMinor,
    required DateTime occurredAt,
  }) : super(occurredAt);

  final String enrollmentId;
  final String studentId;
  final String academicYearId;
  final String gradeId;
  final String classroomId;

  /// `new_enrollment`, `renewal`, `transfer` ou `reentry`.
  final String type;

  /// Taxa de matrícula na menor unidade.
  final int feeMinor;
}

/// Carteira pré-paga do refeitório carregada. Contrato com o billing: este
/// pode emitir recibo/registar a receita; `cafeteria` não conhece `billing`.
class WalletToppedUp extends DomainEvent {
  const WalletToppedUp({
    required this.walletId,
    required this.holderId,
    required this.transactionId,
    required this.amountMinor,
    required this.method,
    this.reference,
    required DateTime occurredAt,
  }) : super(occurredAt);

  final String walletId;
  final String holderId;
  final String transactionId;
  final int amountMinor;

  /// `cash`, `bank_transfer`, `card` ou `payment_reference`.
  final String method;
  final String? reference;
}

/// Barramento em memória (broadcast). Quem consome subscreve por tipo.
class DomainEventBus {
  final _controller = StreamController<DomainEvent>.broadcast(sync: true);

  void publish(DomainEvent event) => _controller.add(event);

  Stream<T> on<T extends DomainEvent>() =>
      _controller.stream.where((e) => e is T).cast<T>();

  void dispose() => _controller.close();
}

final domainEventBusProvider = Provider<DomainEventBus>((ref) {
  final bus = DomainEventBus();
  ref.onDispose(bus.dispose);
  return bus;
});
