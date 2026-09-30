import '../../../../core/network/mock/mock_reference_data.dart';
import '../models/agenda_event_model.dart';
import '../models/announcement_model.dart';
import '../models/communication_enums.dart';

/// Seed determinístico de comunicados e agenda (mesmo formato JSON do backend).
({List<AnnouncementModel> announcements, List<AgendaEventModel> events})
buildCommunicationSeed() {
  final base = DateTime.utc(2026, 1, 12, 8);
  String id(String prefix, int i) =>
      '01J$prefix${i.toString().padLeft(2, '0')}'.padRight(26, '0');

  AnnouncementModel ann(
    int i,
    String title,
    String body,
    AnnouncementAudience audience, {
    String? classroomId,
    bool receipt = false,
    List<String> channels = const ['in_app'],
    int recipients = 480,
  }) {
    final at = base.add(Duration(days: i * 7));
    return AnnouncementModel(
      id: id('ANN', i),
      institutionId: MockRef.institutionId,
      createdAt: at,
      updatedAt: at,
      title: title,
      body: body,
      audience: audience,
      classroomId: classroomId,
      requiresReadReceipt: receipt,
      channels: channels,
      publishedAt: at,
      recipientCount: recipients,
      readCount: receipt ? (recipients * 0.4).round() : 0,
    );
  }

  final announcements = [
    ann(
      1,
      'Início do 2.º trimestre',
      'As aulas do 2.º trimestre começam na segunda-feira, às 7h30.',
      AnnouncementAudience.school,
      channels: const ['in_app', 'push'],
    ),
    ann(
      2,
      'Reunião de encarregados — 5.ª classe',
      'Reunião de entrega de avaliações no sábado, às 9h, na sala 5A.',
      AnnouncementAudience.classroom,
      classroomId: MockRef.classroomId(5, 0),
      receipt: true,
      channels: const ['in_app', 'sms'],
      recipients: 28,
    ),
    ann(
      3,
      'Propinas de Fevereiro',
      'Lembramos que o prazo de pagamento termina a dia 10.',
      AnnouncementAudience.guardians,
      receipt: true,
      channels: const ['in_app', 'email', 'sms'],
      recipients: 350,
    ),
  ];

  AgendaEventModel ev(
    int i,
    String title,
    AgendaEventType type,
    DateTime startsAt, {
    bool allDay = true,
    String? classroomId,
    String? location,
  }) => AgendaEventModel(
    id: id('EVT', i),
    institutionId: MockRef.institutionId,
    createdAt: base,
    updatedAt: base,
    title: title,
    type: type,
    startsAt: startsAt,
    allDay: allDay,
    classroomId: classroomId,
    location: location,
  );

  final events = [
    ev(
      1,
      'Dia da Mulher Africana',
      AgendaEventType.holiday,
      DateTime.utc(2026, 7, 31),
    ),
    ev(
      2,
      'Provas do 2.º trimestre',
      AgendaEventType.exam,
      DateTime.utc(2026, 3, 9),
    ),
    ev(
      3,
      'Reunião de pais',
      AgendaEventType.meeting,
      DateTime.utc(2026, 2, 14, 8),
      allDay: false,
      location: 'Sala 5A',
      classroomId: MockRef.classroomId(5, 0),
    ),
    ev(
      4,
      'Limite de pagamento de propinas',
      AgendaEventType.deadline,
      DateTime.utc(2026, 2, 10),
    ),
    ev(
      5,
      'Feira de ciências',
      AgendaEventType.event,
      DateTime.utc(2026, 4, 18, 9),
      allDay: false,
      location: 'Pátio central',
    ),
  ];

  return (announcements: announcements, events: events);
}
