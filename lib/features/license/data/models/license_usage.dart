/// Consumo actual face aos limites da licença (`GET /v1/license/usage`).
class LicenseUsage {
  const LicenseUsage({
    required this.students,
    required this.campuses,
    required this.users,
    required this.devices,
  });

  factory LicenseUsage.fromJson(Map<String, dynamic> json) => LicenseUsage(
    students: json['students'] as int? ?? 0,
    campuses: json['campuses'] as int? ?? 0,
    users: json['users'] as int? ?? 0,
    devices: json['devices'] as int? ?? 0,
  );

  final int students;
  final int campuses;
  final int users;
  final int devices;

  /// Consumo da dimensão [key] (`students`, `campuses`, `users`, `devices`).
  int operator [](String key) => switch (key) {
    'students' => students,
    'campuses' => campuses,
    'users' => users,
    'devices' => devices,
    _ => 0,
  };
}
