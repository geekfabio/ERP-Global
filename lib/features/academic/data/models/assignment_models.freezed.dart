// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeachingAssignmentModel {

 String get id;/// Derivado da turma pelo servidor.
 String get academicYearId; String get teacherId; String get classroomId; String get subjectId;/// Carga horária semanal em horas.
 int get weeklyHours; AssignmentRole get role;/// Início da validade (`AAAA-MM-DD`); obrigatório no substituto.
 String? get validFrom;/// Fim da validade (`AAAA-MM-DD`); obrigatório no substituto.
 String? get validUntil;
/// Create a copy of TeachingAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeachingAssignmentModelCopyWith<TeachingAssignmentModel> get copyWith => _$TeachingAssignmentModelCopyWithImpl<TeachingAssignmentModel>(this as TeachingAssignmentModel, _$identity);

  /// Serializes this TeachingAssignmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeachingAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.weeklyHours, weeklyHours) || other.weeklyHours == weeklyHours)&&(identical(other.role, role) || other.role == role)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,teacherId,classroomId,subjectId,weeklyHours,role,validFrom,validUntil);

@override
String toString() {
  return 'TeachingAssignmentModel(id: $id, academicYearId: $academicYearId, teacherId: $teacherId, classroomId: $classroomId, subjectId: $subjectId, weeklyHours: $weeklyHours, role: $role, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class $TeachingAssignmentModelCopyWith<$Res>  {
  factory $TeachingAssignmentModelCopyWith(TeachingAssignmentModel value, $Res Function(TeachingAssignmentModel) _then) = _$TeachingAssignmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String academicYearId, String teacherId, String classroomId, String subjectId, int weeklyHours, AssignmentRole role, String? validFrom, String? validUntil
});




}
/// @nodoc
class _$TeachingAssignmentModelCopyWithImpl<$Res>
    implements $TeachingAssignmentModelCopyWith<$Res> {
  _$TeachingAssignmentModelCopyWithImpl(this._self, this._then);

  final TeachingAssignmentModel _self;
  final $Res Function(TeachingAssignmentModel) _then;

/// Create a copy of TeachingAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? academicYearId = null,Object? teacherId = null,Object? classroomId = null,Object? subjectId = null,Object? weeklyHours = null,Object? role = null,Object? validFrom = freezed,Object? validUntil = freezed,}) {
  return _then(TeachingAssignmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,weeklyHours: null == weeklyHours ? _self.weeklyHours : weeklyHours // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AssignmentRole,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeachingAssignmentModel].
extension TeachingAssignmentModelPatterns on TeachingAssignmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeachingAssignmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeachingAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeachingAssignmentModel value)  $default,){
final _that = this;
switch (_that) {
case _TeachingAssignmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeachingAssignmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeachingAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String teacherId,  String classroomId,  String subjectId,  int weeklyHours,  AssignmentRole role,  String? validFrom,  String? validUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeachingAssignmentModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.teacherId,_that.classroomId,_that.subjectId,_that.weeklyHours,_that.role,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String teacherId,  String classroomId,  String subjectId,  int weeklyHours,  AssignmentRole role,  String? validFrom,  String? validUntil)  $default,) {final _that = this;
switch (_that) {
case _TeachingAssignmentModel():
return $default(_that.id,_that.academicYearId,_that.teacherId,_that.classroomId,_that.subjectId,_that.weeklyHours,_that.role,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String academicYearId,  String teacherId,  String classroomId,  String subjectId,  int weeklyHours,  AssignmentRole role,  String? validFrom,  String? validUntil)?  $default,) {final _that = this;
switch (_that) {
case _TeachingAssignmentModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.teacherId,_that.classroomId,_that.subjectId,_that.weeklyHours,_that.role,_that.validFrom,_that.validUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeachingAssignmentModel implements TeachingAssignmentModel {
  const _TeachingAssignmentModel({required this.id, this.academicYearId = '', required this.teacherId, required this.classroomId, required this.subjectId, required this.weeklyHours, this.role = AssignmentRole.titular, this.validFrom, this.validUntil});
  factory _TeachingAssignmentModel.fromJson(Map<String, dynamic> json) => _$TeachingAssignmentModelFromJson(json);

@override final  String id;
/// Derivado da turma pelo servidor.
@override@JsonKey() final  String academicYearId;
@override final  String teacherId;
@override final  String classroomId;
@override final  String subjectId;
/// Carga horária semanal em horas.
@override final  int weeklyHours;
@override@JsonKey() final  AssignmentRole role;
/// Início da validade (`AAAA-MM-DD`); obrigatório no substituto.
@override final  String? validFrom;
/// Fim da validade (`AAAA-MM-DD`); obrigatório no substituto.
@override final  String? validUntil;

/// Create a copy of TeachingAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeachingAssignmentModelCopyWith<_TeachingAssignmentModel> get copyWith => __$TeachingAssignmentModelCopyWithImpl<_TeachingAssignmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeachingAssignmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeachingAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.weeklyHours, weeklyHours) || other.weeklyHours == weeklyHours)&&(identical(other.role, role) || other.role == role)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,teacherId,classroomId,subjectId,weeklyHours,role,validFrom,validUntil);

@override
String toString() {
  return 'TeachingAssignmentModel(id: $id, academicYearId: $academicYearId, teacherId: $teacherId, classroomId: $classroomId, subjectId: $subjectId, weeklyHours: $weeklyHours, role: $role, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class _$TeachingAssignmentModelCopyWith<$Res> implements $TeachingAssignmentModelCopyWith<$Res> {
  factory _$TeachingAssignmentModelCopyWith(_TeachingAssignmentModel value, $Res Function(_TeachingAssignmentModel) _then) = __$TeachingAssignmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String academicYearId, String teacherId, String classroomId, String subjectId, int weeklyHours, AssignmentRole role, String? validFrom, String? validUntil
});




}
/// @nodoc
class __$TeachingAssignmentModelCopyWithImpl<$Res>
    implements _$TeachingAssignmentModelCopyWith<$Res> {
  __$TeachingAssignmentModelCopyWithImpl(this._self, this._then);

  final _TeachingAssignmentModel _self;
  final $Res Function(_TeachingAssignmentModel) _then;

/// Create a copy of TeachingAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? academicYearId = null,Object? teacherId = null,Object? classroomId = null,Object? subjectId = null,Object? weeklyHours = null,Object? role = null,Object? validFrom = freezed,Object? validUntil = freezed,}) {
  return _then(_TeachingAssignmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,weeklyHours: null == weeklyHours ? _self.weeklyHours : weeklyHours // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AssignmentRole,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HomeroomModel {

 String get id; String get classroomId; String get teacherId;
/// Create a copy of HomeroomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeroomModelCopyWith<HomeroomModel> get copyWith => _$HomeroomModelCopyWithImpl<HomeroomModel>(this as HomeroomModel, _$identity);

  /// Serializes this HomeroomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeroomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,teacherId);

@override
String toString() {
  return 'HomeroomModel(id: $id, classroomId: $classroomId, teacherId: $teacherId)';
}


}

/// @nodoc
abstract mixin class $HomeroomModelCopyWith<$Res>  {
  factory $HomeroomModelCopyWith(HomeroomModel value, $Res Function(HomeroomModel) _then) = _$HomeroomModelCopyWithImpl;
@useResult
$Res call({
 String id, String classroomId, String teacherId
});




}
/// @nodoc
class _$HomeroomModelCopyWithImpl<$Res>
    implements $HomeroomModelCopyWith<$Res> {
  _$HomeroomModelCopyWithImpl(this._self, this._then);

  final HomeroomModel _self;
  final $Res Function(HomeroomModel) _then;

/// Create a copy of HomeroomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? classroomId = null,Object? teacherId = null,}) {
  return _then(HomeroomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeroomModel].
extension HomeroomModelPatterns on HomeroomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeroomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeroomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeroomModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeroomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeroomModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeroomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String classroomId,  String teacherId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeroomModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.teacherId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String classroomId,  String teacherId)  $default,) {final _that = this;
switch (_that) {
case _HomeroomModel():
return $default(_that.id,_that.classroomId,_that.teacherId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String classroomId,  String teacherId)?  $default,) {final _that = this;
switch (_that) {
case _HomeroomModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.teacherId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeroomModel implements HomeroomModel {
  const _HomeroomModel({required this.id, required this.classroomId, required this.teacherId});
  factory _HomeroomModel.fromJson(Map<String, dynamic> json) => _$HomeroomModelFromJson(json);

@override final  String id;
@override final  String classroomId;
@override final  String teacherId;

/// Create a copy of HomeroomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeroomModelCopyWith<_HomeroomModel> get copyWith => __$HomeroomModelCopyWithImpl<_HomeroomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeroomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeroomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,teacherId);

@override
String toString() {
  return 'HomeroomModel(id: $id, classroomId: $classroomId, teacherId: $teacherId)';
}


}

/// @nodoc
abstract mixin class _$HomeroomModelCopyWith<$Res> implements $HomeroomModelCopyWith<$Res> {
  factory _$HomeroomModelCopyWith(_HomeroomModel value, $Res Function(_HomeroomModel) _then) = __$HomeroomModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String classroomId, String teacherId
});




}
/// @nodoc
class __$HomeroomModelCopyWithImpl<$Res>
    implements _$HomeroomModelCopyWith<$Res> {
  __$HomeroomModelCopyWithImpl(this._self, this._then);

  final _HomeroomModel _self;
  final $Res Function(_HomeroomModel) _then;

/// Create a copy of HomeroomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? classroomId = null,Object? teacherId = null,}) {
  return _then(_HomeroomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
