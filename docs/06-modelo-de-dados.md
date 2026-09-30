# 06 — Modelo de Dados (visão conceptual)

Serve de contrato entre o frontend (mocks/Drift) e a equipa de backend. IDs em **ULID** (gerados no cliente → offline first). Todas as entidades têm `id`, `createdAt`, `updatedAt`, `deletedAt?`, `syncState`, `institutionId` (e `campusId` quando aplicável).

## Núcleo

`Institution`, `Campus`, `User`, `Role`, `Permission`, `UserRole(scope)`, `License`, `AuditLog`, `Notification`, `Attachment`, `Setting`.

## Académico

```
AcademicYear 1─* Term(trimestre)
Level(ciclo) 1─* Grade(classe) 1─* Classroom(turma)
Course 1─* CurriculumItem(course, grade, subject, workload)
Subject
Room, Shift
TeachingAssignment(teacher, classroom, subject, academicYear)
ClassroomHomeroom(classroom, teacher)     -- director de turma
TimetableSlot(classroom, subject, teacher, room, weekday, start, end)
```

## Pessoas

```
Student 1─* Enrollment(academicYear, grade, classroom, status)
Student *─* Guardian via GuardianLink(relationship, isFinancialResponsible, isEmergency, canPickup)
Student 1─* StudentDocument | HealthRecord | DisciplineRecord | Transfer
Employee(user?) 1─* Contract
```

## Avaliação

```
AssessmentScheme(grade/course) 1─* AssessmentComponent(code, weight)
Assessment(classroom, subject, term, component, date)
Score(student, assessment, value, enteredBy)
TermResult(student, subject, term, average)
FinalResult(student, academicYear, status)
ReportCard(student, term, issuedAt, pdf)
Certificate(student, type, number, qr)
```

## Presenças e acessos

`AttendanceRecord(student, date, lessonSlot?, status, justification?)`, `Card(uid, holder, status)`, `AccessDevice`, `AccessRule`, `AccessLog`.

## Financeiro e contabilidade

```
FeeItem(academicYear, grade, type, amount)
BillingPlan(student, academicYear)
Charge(student, feeItem, dueDate, amount, discount, status)
Invoice 1─* InvoiceLine ; Receipt ; CreditNote
Payment(method, amount, allocations→Charge)
StudentAccount(ledger entries)
CashRegister 1─* CashSession 1─* CashMovement
Scholarship/Discount
ChartOfAccounts, JournalEntry 1─* JournalLine, CostCenter, FiscalYear
```

## Refeitório e serviços

`MealMenu`, `MealItem`, `Wallet(holder)`, `WalletTransaction(type: topup|purchase|refund)`, `PosSale`, `Book`, `BookCopy`, `Loan`, `Asset`, `StockItem`.

## Regras transversais

- **Soft delete** e **imutabilidade** de documentos fiscais/notas fechadas (correcção por novo documento/versão).
- **Outbox** de sincronização por entidade; resolução de conflitos: *last-write-wins* por campo para dados de baixo risco; *servidor decide* para financeiro/numeração fiscal.
- **Numeração fiscal** atribuída pelo servidor/série local reservada por dispositivo (definir com backend).
- **Moeda**: valores em inteiros na menor unidade (`int`, cêntimos) — nunca `double` para dinheiro.
