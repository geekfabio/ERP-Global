import '../../../../core/notifications/notification_service.dart';

/// Resultado da entrega de uma mensagem num canal.
class AdapterResult {
  const AdapterResult.delivered(this.count) : error = null;
  const AdapterResult.failed(this.error) : count = 0;

  final int count;
  final String? error;

  bool get ok => error == null;
}

/// Adapter de um canal de saída. Em produção seriam FCM/SMS gateway/SMTP; aqui
/// só regista o que "enviou" (o que é simulado é a rede, não o repository).
abstract class ChannelAdapter {
  NotificationChannel get channel;

  /// Mensagens entregues (útil para testes e para inspecção em dev).
  final List<({String title, String body, int count})> log = [];

  AdapterResult deliver({
    required String title,
    required String body,
    required int recipientCount,
  }) {
    final failure = validate(title, body);
    if (failure != null) return AdapterResult.failed(failure);
    log.add((title: title, body: body, count: recipientCount));
    return AdapterResult.delivered(recipientCount);
  }

  /// Devolve o motivo da recusa, ou `null` se o canal aceita a mensagem.
  String? validate(String title, String body) => null;
}

class InAppMockAdapter extends ChannelAdapter {
  @override
  NotificationChannel get channel => NotificationChannel.inApp;
}

class PushMockAdapter extends ChannelAdapter {
  @override
  NotificationChannel get channel => NotificationChannel.push;

  @override
  String? validate(String title, String body) =>
      body.length > 240 ? 'Mensagem demasiado longa para push' : null;
}

class SmsMockAdapter extends ChannelAdapter {
  static const maxLength = 320;

  @override
  NotificationChannel get channel => NotificationChannel.sms;

  @override
  String? validate(String title, String body) =>
      '$title $body'.length > maxLength
      ? 'SMS excede $maxLength caracteres'
      : null;
}

class EmailMockAdapter extends ChannelAdapter {
  @override
  NotificationChannel get channel => NotificationChannel.email;
}

List<ChannelAdapter> defaultChannelAdapters() => [
  InAppMockAdapter(),
  PushMockAdapter(),
  SmsMockAdapter(),
  EmailMockAdapter(),
];
