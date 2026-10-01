import '../models/enrollment_rules_model.dart';
import '../models/student_enums.dart';

/// Regras de matrícula iniciais (formato do futuro backend).
const defaultEnrollmentRules = EnrollmentRulesModel(
  minAgeYears: 5,
  capacityPerClassroom: 35,
  requiredDocuments: {
    'new_enrollment': [
      StudentDocumentType.birthCertificate,
      StudentDocumentType.photo,
    ],
    'transfer': [
      StudentDocumentType.birthCertificate,
      StudentDocumentType.photo,
      StudentDocumentType.previousCertificate,
    ],
    'reentry': [StudentDocumentType.birthCertificate],
    'renewal': [],
  },
);
