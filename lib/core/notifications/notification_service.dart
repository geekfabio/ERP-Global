import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/result.dart';

/// Canais de entrega de uma notificação.
enum NotificationChannel {
  inApp,
  push,
  sms,
  email;

  /// Nome no JSON/API (`inApp` → `in_app`).
  String get wire => switch (this) {
    NotificationChannel.inApp => 'in_app',
    _ => name,
  };

  static NotificationChannel fromWire(String value) =>
      values.firstWhere((c) => c.wire == value);
}

/// Pedido de envio. Os outros módulos só conhecem este contrato: quem entrega
/// (canais, adapters, servidor) é assunto do módulo `communication`.
class NotificationRequest {
  const NotificationRequest({
    required this.sourceModule,
    required this.recipientIds,
    required this.title,
    required this.body,
    this.channels = const [NotificationChannel.inApp],
    this.data = const {},
  });

  /// Código do módulo que origina o envio (ex.: `billing`).
  final String sourceModule;

  /// Ids de utilizador dos destinatários.
  final List<String> recipientIds;
  final String title;
  final String body;
  final List<NotificationChannel> channels;

  /// Dados para navegação/contexto (ex.: `{'invoiceId': '...'}`).
  final Map<String, Object?> data;

  Map<String, dynamic> toJson() => {
    'sourceModule': sourceModule,
    'recipientIds': recipientIds,
    'title': title,
    'body': body,
    'channels': [for (final c in channels) c.wire],
    'data': data,
  };
}

/// Entrega de uma notificação num canal.
class ChannelDelivery {
  const ChannelDelivery({
    required this.channel,
    required this.delivered,
    required this.count,
    this.error,
  });

  final NotificationChannel channel;
  final bool delivered;
  final int count;
  final String? error;
}

/// Resultado de um envio: entregas por canal.
class NotificationReceipt {
  const NotificationReceipt({required this.id, required this.deliveries});

  factory NotificationReceipt.fromJson(Map<String, dynamic> json) =>
      NotificationReceipt(
        id: json['id'] as String,
        deliveries: [
          for (final d in (json['deliveries'] as List).cast<Map>())
            ChannelDelivery(
              channel: NotificationChannel.fromWire(d['channel'] as String),
              delivered: d['status'] == 'delivered',
              count: d['count'] as int,
              error: d['error'] as String?,
            ),
        ],
      );

  final String id;
  final List<ChannelDelivery> deliveries;

  bool get allDelivered => deliveries.every((d) => d.delivered);
}

/// Contrato reutilizável de envio de notificações.
abstract interface class NotificationService {
  Future<Result<NotificationReceipt>> send(NotificationRequest request);
}

/// Ligado à implementação do módulo `communication` em `main.dart`
/// (o `core` não conhece `features/`).
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(
    'notificationServiceProvider não foi ligado ao módulo de comunicação.',
  ),
);
