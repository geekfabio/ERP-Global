import '../data/models/hr_models.dart';

/// Data `AAAA-MM-DD` → UTC (ou `null` se inválida).
DateTime? parseIsoDate(String? value) {
  if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return null;
  }
  final d = DateTime.tryParse('${value}T00:00:00Z');
  return d != null && d.toIso8601String().startsWith(value) ? d : null;
}

/// O contrato está em vigor em [day] (início ≤ dia ≤ fim, fim opcional).
bool isContractActiveOn(ContractModel c, DateTime day) {
  final start = parseIsoDate(c.startDate);
  if (start == null) return false;
  final today = DateTime.utc(day.year, day.month, day.day);
  if (start.isAfter(today)) return false;
  final end = parseIsoDate(c.endDate);
  return end == null || !end.isBefore(today);
}

/// Dois contratos do mesmo funcionário não podem sobrepor-se.
bool contractsOverlap(ContractModel a, ContractModel b) {
  final aStart = parseIsoDate(a.startDate);
  final bStart = parseIsoDate(b.startDate);
  if (aStart == null || bStart == null) return false;
  final aEnd = parseIsoDate(a.endDate);
  final bEnd = parseIsoDate(b.endDate);
  final aBeforeB = aEnd != null && aEnd.isBefore(bStart);
  final bBeforeA = bEnd != null && bEnd.isBefore(aStart);
  return !aBeforeB && !bBeforeA;
}

/// Docente (ligado ao módulo académico) activo sem contrato em vigor: é
/// sinalizado.
bool isTeacherWithoutContract(EmployeeModel e) =>
    e.teacherId != null && e.isActive && !e.hasActiveContract;
