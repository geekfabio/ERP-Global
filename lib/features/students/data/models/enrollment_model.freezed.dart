// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrollmentModel {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; String get academicYearId; String get gradeId; String? get classroomId; String? get shiftId;/// N.º de chamada na turma.
 int? get rollNumber; EnrollmentType get type; EnrollmentStatus get status;@DateOnlyConverter() DateTime get enrolledOn;/// Taxa de matrícula na menor unidade (cêntimos); nunca `double`.
 int get feeMinor; bool get feePaid; String? get notes;
/// Create a copy of EnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrollmentModelCopyWith<EnrollmentModel> get copyWith => _$EnrollmentModelCopyWithImpl<EnrollmentModel>(this as EnrollmentModel, _$identity);

  /// Serializes this EnrollmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.rollNumber, rollNumber) || other.rollNumber == rollNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrolledOn, enrolledOn) || other.enrolledOn == enrolledOn)&&(identical(other.feeMinor, feeMinor) || other.feeMinor == feeMinor)&&(identical(other.feePaid, feePaid) || other.feePaid == feePaid)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,academicYearId,gradeId,classroomId,shiftId,rollNumber,type,status,enrolledOn,feeMinor,feePaid,notes]);

@override
String toString() {
  return 'EnrollmentModel(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, academicYearId: $academicYearId, gradeId: $gradeId, classroomId: $classroomId, shiftId: $shiftId, rollNumber: $rollNumber, type: $type, status: $status, enrolledOn: $enrolledOn, feeMinor: $feeMinor, feePaid: $feePaid, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $EnrollmentModelCopyWith<$Res>  {
  factory $EnrollmentModelCopyWith(EnrollmentModel value, $Res Function(EnrollmentModel) _then) = _$EnrollmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String academicYearId, String gradeId, String? classroomId, String? shiftId, int? rollNumber, EnrollmentType type, EnrollmentStatus status,@DateOnlyConverter() DateTime enrolledOn, int feeMinor, bool feePaid, String? notes
});




}
/// @nodoc
class _$EnrollmentModelCopyWithImpl<$Res>
    implements $EnrollmentModelCopyWith<$Res> {
  _$EnrollmentModelCopyWithImpl(this._self, this._then);

  final EnrollmentModel _self;
  final $Res Function(EnrollmentModel) _then;

/// Create a copy of EnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? academicYearId = null,Object? gradeId = null,Object? classroomId = freezed,Object? shiftId = freezed,Object? rollNumber = freezed,Object? type = null,Object? status = null,Object? enrolledOn = null,Object? feeMinor = null,Object? feePaid = null,Object? notes = freezed,}) {
  return _then(EnrollmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,rollNumber: freezed == rollNumber ? _self.rollNumber : rollNumber // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EnrollmentType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EnrollmentStatus,enrolledOn: null == enrolledOn ? _self.enrolledOn : enrolledOn // ignore: cast_nullable_to_non_nullable
as DateTime,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,feePaid: null == feePaid ? _self.feePaid : feePaid // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrollmentModel].
extension EnrollmentModelPatterns on EnrollmentModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrollmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrollmentModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrollmentModel value)  $default,){
final _that = this;
switch (_that) {
case _EnrollmentModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrollmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _EnrollmentModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String academicYearId,  String gradeId,  String? classroomId,  String? shiftId,  int? rollNumber,  EnrollmentType type,  EnrollmentStatus status, @DateOnlyConverter()  DateTime enrolledOn,  int feeMinor,  bool feePaid,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrollmentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.academicYearId,_that.gradeId,_that.classroomId,_that.shiftId,_that.rollNumber,_that.type,_that.status,_that.enrolledOn,_that.feeMinor,_that.feePaid,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String academicYearId,  String gradeId,  String? classroomId,  String? shiftId,  int? rollNumber,  EnrollmentType type,  EnrollmentStatus status, @DateOnlyConverter()  DateTime enrolledOn,  int feeMinor,  bool feePaid,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _EnrollmentModel():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.academicYearId,_that.gradeId,_that.classroomId,_that.shiftId,_that.rollNumber,_that.type,_that.status,_that.enrolledOn,_that.feeMinor,_that.feePaid,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String academicYearId,  String gradeId,  String? classroomId,  String? shiftId,  int? rollNumber,  EnrollmentType type,  EnrollmentStatus status, @DateOnlyConverter()  DateTime enrolledOn,  int feeMinor,  bool feePaid,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _EnrollmentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.academicYearId,_that.gradeId,_that.classroomId,_that.shiftId,_that.rollNumber,_that.type,_that.status,_that.enrolledOn,_that.feeMinor,_that.feePaid,_that.notes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EnrollmentModel implements EnrollmentModel {
  const _EnrollmentModel({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.academicYearId, required this.gradeId, this.classroomId, this.shiftId, this.rollNumber, required this.type, this.status = EnrollmentStatus.pending, @DateOnlyConverter() required this.enrolledOn, this.feeMinor = 0, this.feePaid = false, this.notes});
  factory _EnrollmentModel.fromJson(Map<String, dynamic> json) => _$EnrollmentModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  String academicYearId;
@override final  String gradeId;
@override final  String? classroomId;
@override final  String? shiftId;
/// N.º de chamada na turma.
@override final  int? rollNumber;
@override final  EnrollmentType type;
@override@JsonKey() final  EnrollmentStatus status;
@override@DateOnlyConverter() final  DateTime enrolledOn;
/// Taxa de matrícula na menor unidade (cêntimos); nunca `double`.
@override@JsonKey() final  int feeMinor;
@override@JsonKey() final  bool feePaid;
@override final  String? notes;

/// Create a copy of EnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrollmentModelCopyWith<_EnrollmentModel> get copyWith => __$EnrollmentModelCopyWithImpl<_EnrollmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrollmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.rollNumber, rollNumber) || other.rollNumber == rollNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrolledOn, enrolledOn) || other.enrolledOn == enrolledOn)&&(identical(other.feeMinor, feeMinor) || other.feeMinor == feeMinor)&&(identical(other.feePaid, feePaid) || other.feePaid == feePaid)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,academicYearId,gradeId,classroomId,shiftId,rollNumber,type,status,enrolledOn,feeMinor,feePaid,notes]);

@override
String toString() {
  return 'EnrollmentModel(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, academicYearId: $academicYearId, gradeId: $gradeId, classroomId: $classroomId, shiftId: $shiftId, rollNumber: $rollNumber, type: $type, status: $status, enrolledOn: $enrolledOn, feeMinor: $feeMinor, feePaid: $feePaid, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$EnrollmentModelCopyWith<$Res> implements $EnrollmentModelCopyWith<$Res> {
  factory _$EnrollmentModelCopyWith(_EnrollmentModel value, $Res Function(_EnrollmentModel) _then) = __$EnrollmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String academicYearId, String gradeId, String? classroomId, String? shiftId, int? rollNumber, EnrollmentType type, EnrollmentStatus status,@DateOnlyConverter() DateTime enrolledOn, int feeMinor, bool feePaid, String? notes
});




}
/// @nodoc
class __$EnrollmentModelCopyWithImpl<$Res>
    implements _$EnrollmentModelCopyWith<$Res> {
  __$EnrollmentModelCopyWithImpl(this._self, this._then);

  final _EnrollmentModel _self;
  final $Res Function(_EnrollmentModel) _then;

/// Create a copy of EnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? academicYearId = null,Object? gradeId = null,Object? classroomId = freezed,Object? shiftId = freezed,Object? rollNumber = freezed,Object? type = null,Object? status = null,Object? enrolledOn = null,Object? feeMinor = null,Object? feePaid = null,Object? notes = freezed,}) {
  return _then(_EnrollmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,rollNumber: freezed == rollNumber ? _self.rollNumber : rollNumber // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EnrollmentType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EnrollmentStatus,enrolledOn: null == enrolledOn ? _self.enrolledOn : enrolledOn // ignore: cast_nullable_to_non_nullable
as DateTime,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,feePaid: null == feePaid ? _self.feePaid : feePaid // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
