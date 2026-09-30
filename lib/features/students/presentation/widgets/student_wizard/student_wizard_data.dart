import '../../../../../core/utils/seed_generator.dart';
import '../../../data/models/guardian_model.dart';
import '../../../data/models/student_document_model.dart';
import '../../../data/models/student_enums.dart';
import '../../../data/models/student_model.dart';

/// Chaves dos valores do wizard. Só tipos simples (texto, bool, listas de
/// mapas), para o rascunho poder ser guardado como JSON.
abstract final class WizardKeys {
  static const fullName = 'fullName';

  /// `yyyy-MM-dd`.
  static const birthDate = 'birthDate';
  static const birthPlace = 'birthPlace';

  /// `male` | `female`.
  static const gender = 'gender';
  static const nationality = 'nationality';
  static const idNumber = 'idNumber';
  static const nif = 'nif';
  static const address = 'address';
  static const phone = 'phone';
  static const email = 'email';
  static const originSchool = 'originSchool';

  static const guardians = 'guardians';

  /// [BloodType.name].
  static const bloodType = 'bloodType';
  static const allergies = 'allergies';
  static const medication = 'medication';
  static const conditions = 'conditions';
  static const insurance = 'insurance';
  static const medicalContact = 'medicalContact';
  static const hasSpecialNeeds = 'hasSpecialNeeds';
  static const specialNeedsNotes = 'specialNeedsNotes';

  /// Lista de [StudentDocumentType.name] entregues.
  static const documents = 'documents';
}

/// Encarregado indicado no cadastro (ainda sem id; é criado ao guardar).
class WizardGuardian {
  const WizardGuardian({
    required this.fullName,
    required this.phone,
    required this.relationship,
    this.isFinancialResponsible = false,
    this.isEmergency = false,
    this.canPickup = false,
  });

  factory WizardGuardian.fromMap(Map<String, Object?> m) => WizardGuardian(
    fullName: '${m['fullName']}',
    phone: '${m['phone']}',
    relationship: GuardianRelationship.values.byName('${m['relationship']}'),
    isFinancialResponsible: m['isFinancialResponsible'] == true,
    isEmergency: m['isEmergency'] == true,
    canPickup: m['canPickup'] == true,
  );

  final String fullName;
  final String phone;
  final GuardianRelationship relationship;
  final bool isFinancialResponsible;
  final bool isEmergency;
  final bool canPickup;

  Map<String, Object?> toMap() => {
    'fullName': fullName,
    'phone': phone,
    'relationship': relationship.name,
    'isFinancialResponsible': isFinancialResponsible,
    'isEmergency': isEmergency,
    'canPickup': canPickup,
  };
}

String? _text(Map<String, Object?> v, String key) {
  final t = (v[key] as String?)?.trim();
  return t == null || t.isEmpty ? null : t;
}

/// `yyyy-MM-dd` ↔ data de calendário (meia-noite UTC).
String formatWizardDate(DateTime d) => d.toIso8601String().substring(0, 10);

DateTime? parseWizardDate(String? text) {
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text ?? '');
  return m == null
      ? null
      : DateTime.utc(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
}

/// Encarregados (por ordem) guardados nos valores do wizard.
List<WizardGuardian> wizardGuardians(Map<String, Object?> values) => [
  for (final m in (values[WizardKeys.guardians] as List?) ?? const [])
    WizardGuardian.fromMap((m as Map).cast<String, Object?>()),
];

/// Tipos de documento marcados como entregues.
List<StudentDocumentType> wizardDocuments(Map<String, Object?> values) => [
  for (final n in (values[WizardKeys.documents] as List?) ?? const [])
    StudentDocumentType.values.byName('$n'),
];

/// Alergias escritas numa só linha, separadas por vírgula (ou ponto e vírgula).
List<String> splitAllergies(String? text) => [
  for (final a in (text ?? '').split(RegExp(r'[,;]')))
    if (a.trim().isNotEmpty) a.trim(),
];

/// Monta o aluno a criar. O n.º de processo fica vazio: é gerado pelo servidor;
/// a instituição também é imposta pelo servidor.
StudentModel wizardStudent(
  Map<String, Object?> values, {
  required String id,
  required DateTime now,
}) {
  final blood = _text(values, WizardKeys.bloodType);
  return StudentModel(
    id: id,
    institutionId: 'mock',
    createdAt: now,
    updatedAt: now,
    processNumber: '',
    fullName: _text(values, WizardKeys.fullName) ?? '',
    birthDate: parseWizardDate(values[WizardKeys.birthDate] as String?)!,
    birthPlace: _text(values, WizardKeys.birthPlace),
    gender: Gender.values.byName(
      _text(values, WizardKeys.gender) ?? Gender.male.name,
    ),
    nationality: _text(values, WizardKeys.nationality) ?? 'Angolana',
    idNumber: _text(values, WizardKeys.idNumber),
    nif: _text(values, WizardKeys.nif),
    address: _text(values, WizardKeys.address),
    phone: _text(values, WizardKeys.phone),
    email: _text(values, WizardKeys.email),
    originSchool: _text(values, WizardKeys.originSchool),
    health: HealthInfo(
      bloodType: blood == null ? null : BloodType.values.byName(blood),
      allergies: splitAllergies(values[WizardKeys.allergies] as String?),
      medication: _text(values, WizardKeys.medication),
      conditions: _text(values, WizardKeys.conditions),
      insurance: _text(values, WizardKeys.insurance),
      medicalContact: _text(values, WizardKeys.medicalContact),
      hasSpecialNeeds: values[WizardKeys.hasSpecialNeeds] == true,
      specialNeedsNotes: values[WizardKeys.hasSpecialNeeds] == true
          ? _text(values, WizardKeys.specialNeedsNotes)
          : null,
    ),
  );
}

/// Encarregado + vínculo prontos a enviar para um aluno já criado.
({GuardianModel guardian, GuardianLinkModel link}) wizardGuardianModels(
  WizardGuardian g, {
  required String studentId,
  required DateTime now,
}) {
  String id(int salt) => SeedGenerator(
    now.microsecondsSinceEpoch + salt,
  ).ulid(now.add(Duration(microseconds: salt)));
  final guardianId = id(1);
  return (
    guardian: GuardianModel(
      id: guardianId,
      institutionId: 'mock',
      createdAt: now,
      updatedAt: now,
      fullName: g.fullName,
      phone: g.phone,
    ),
    link: GuardianLinkModel(
      id: id(2),
      institutionId: 'mock',
      createdAt: now,
      updatedAt: now,
      studentId: studentId,
      guardianId: guardianId,
      relationship: g.relationship,
      isFinancialResponsible: g.isFinancialResponsible,
      isEmergency: g.isEmergency,
      canPickup: g.canPickup,
    ),
  );
}

StudentDocumentModel wizardDocument(
  StudentDocumentType type, {
  required String studentId,
  required DateTime now,
}) => StudentDocumentModel(
  id: SeedGenerator(now.microsecondsSinceEpoch + type.index).ulid(now),
  institutionId: 'mock',
  createdAt: now,
  updatedAt: now,
  studentId: studentId,
  type: type,
  fileName: documentTypeLabel(type),
);

String documentTypeLabel(StudentDocumentType t) => switch (t) {
  StudentDocumentType.idCard => 'Bilhete de identidade',
  StudentDocumentType.birthCertificate => 'Cédula / certidão de nascimento',
  StudentDocumentType.passport => 'Passaporte',
  StudentDocumentType.previousCertificate => 'Certificado da escola anterior',
  StudentDocumentType.vaccination => 'Cartão de vacinas',
  StudentDocumentType.photo => 'Fotografia',
  StudentDocumentType.contract => 'Contrato de matrícula',
  StudentDocumentType.other => 'Outro documento',
};
