// Package schema defines the database-independent contract of the ERP.
package schema

import "time"

// All records belong to one institution; there is no institutional subdivision.
type Record struct {
 ID string `json:"id"`
 InstitutionID string `json:"institutionId"`
 CreatedAt time.Time `json:"createdAt"`
 UpdatedAt time.Time `json:"updatedAt"`
 DeletedAt *time.Time `json:"deletedAt,omitempty"`
 Version int64 `json:"version"`
}

type Institution struct { Record; Name string `json:"name"`; IsActive bool `json:"isActive"` }
type User struct { Record; Email string `json:"email"`; IsActive bool `json:"isActive"`; MustChangePassword bool `json:"mustChangePassword"` }
type Role struct { Record; Code string `json:"code"`; Name string `json:"name"` }
type Permission struct { Code string `json:"code"`; Description string `json:"description"` }
type UserRole struct { InstitutionID string `json:"institutionId"`; UserID string `json:"userId"`; RoleID string `json:"roleId"` }
type AcademicYear struct { Record; Name string `json:"name"`; StartsAt time.Time `json:"startsAt"`; EndsAt time.Time `json:"endsAt"`; Status string `json:"status"` }
type Term struct { Record; AcademicYearID string `json:"academicYearId"`; Name string `json:"name"`; StartsAt time.Time `json:"startsAt"`; EndsAt time.Time `json:"endsAt"` }
type Grade struct { Record; Name string `json:"name"`; LevelID string `json:"levelId"` }
type Classroom struct { Record; GradeID string `json:"gradeId"`; Name string `json:"name"`; AcademicYearID string `json:"academicYearId"` }
type Subject struct { Record; Name string `json:"name"`; Code string `json:"code"` }
type Student struct { Record; FullName string `json:"fullName"`; ProcessNumber string `json:"processNumber"`; Status string `json:"status"` }
type Guardian struct { Record; FullName string `json:"fullName"`; Phone string `json:"phone"` }
type GuardianLink struct { Record; StudentID string `json:"studentId"`; GuardianID string `json:"guardianId"`; Relationship string `json:"relationship"` }
type Enrollment struct { Record; StudentID string `json:"studentId"`; AcademicYearID string `json:"academicYearId"`; ClassroomID string `json:"classroomId"`; Status string `json:"status"` }
type Assessment struct { Record; SubjectID string `json:"subjectId"`; TermID string `json:"termId"`; ClassroomID string `json:"classroomId"` }
type Score struct { Record; AssessmentID string `json:"assessmentId"`; StudentID string `json:"studentId"`; Value int64 `json:"value"` }
type Attendance struct { Record; StudentID string `json:"studentId"`; Day string `json:"day"`; Status string `json:"status"` }
type Charge struct { Record; StudentID string `json:"studentId"`; AmountMinor int64 `json:"amountMinor"`; Currency string `json:"currency"`; Status string `json:"status"` }
type Payment struct { Record; ChargeID string `json:"chargeId"`; AmountMinor int64 `json:"amountMinor"`; Currency string `json:"currency"` }
type Invoice struct { Record; StudentID string `json:"studentId"`; TotalMinor int64 `json:"totalMinor"`; Currency string `json:"currency"`; Status string `json:"status"` }
type Card struct { Record; StudentID string `json:"studentId"`; TokenHash string `json:"tokenHash"`; IsActive bool `json:"isActive"` }
type AccessLog struct { Record; CardID string `json:"cardId"`; DeviceID string `json:"deviceId"`; OccurredAt time.Time `json:"occurredAt"` }
type WalletTransaction struct { Record; StudentID string `json:"studentId"`; AmountMinor int64 `json:"amountMinor"`; Type string `json:"type"` }
type License struct { Record; Modules []string `json:"modules"`; ExpiresAt time.Time `json:"expiresAt"`; Signature string `json:"signature"` }
type SyncOperation struct { Record; EntityType string `json:"entityType"`; EntityID string `json:"entityId"`; Operation string `json:"operation"`; IdempotencyKey string `json:"idempotencyKey"` }
type AuditEvent struct { Record; ActorID string `json:"actorId"`; Action string `json:"action"`; EntityType string `json:"entityType"`; EntityID string `json:"entityId"` }

func Catalog() []string {
 return []string{"institution","user","role","permission","academic_year","term","grade","classroom","subject","student","guardian","guardian_link","enrollment","assessment","score","attendance","charge","payment","invoice","card","access_log","wallet_transaction","license","sync_operation","audit_event"}
}
