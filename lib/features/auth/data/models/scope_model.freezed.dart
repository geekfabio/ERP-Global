// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scope_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScopeModel {

 String? get campusId; String? get courseId; String? get gradeId; String? get classroomId; String? get subjectId;
/// Create a copy of ScopeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScopeModelCopyWith<ScopeModel> get copyWith => _$ScopeModelCopyWithImpl<ScopeModel>(this as ScopeModel, _$identity);

  /// Serializes this ScopeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScopeModel&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,campusId,courseId,gradeId,classroomId,subjectId);

@override
String toString() {
  return 'ScopeModel(campusId: $campusId, courseId: $courseId, gradeId: $gradeId, classroomId: $classroomId, subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class $ScopeModelCopyWith<$Res>  {
  factory $ScopeModelCopyWith(ScopeModel value, $Res Function(ScopeModel) _then) = _$ScopeModelCopyWithImpl;
@useResult
$Res call({
 String? campusId, String? courseId, String? gradeId, String? classroomId, String? subjectId
});




}
/// @nodoc
class _$ScopeModelCopyWithImpl<$Res>
    implements $ScopeModelCopyWith<$Res> {
  _$ScopeModelCopyWithImpl(this._self, this._then);

  final ScopeModel _self;
  final $Res Function(ScopeModel) _then;

/// Create a copy of ScopeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? campusId = freezed,Object? courseId = freezed,Object? gradeId = freezed,Object? classroomId = freezed,Object? subjectId = freezed,}) {
  return _then(ScopeModel(
campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String?,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScopeModel].
extension ScopeModelPatterns on ScopeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScopeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScopeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScopeModel value)  $default,){
final _that = this;
switch (_that) {
case _ScopeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScopeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScopeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? campusId,  String? courseId,  String? gradeId,  String? classroomId,  String? subjectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScopeModel() when $default != null:
return $default(_that.campusId,_that.courseId,_that.gradeId,_that.classroomId,_that.subjectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? campusId,  String? courseId,  String? gradeId,  String? classroomId,  String? subjectId)  $default,) {final _that = this;
switch (_that) {
case _ScopeModel():
return $default(_that.campusId,_that.courseId,_that.gradeId,_that.classroomId,_that.subjectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? campusId,  String? courseId,  String? gradeId,  String? classroomId,  String? subjectId)?  $default,) {final _that = this;
switch (_that) {
case _ScopeModel() when $default != null:
return $default(_that.campusId,_that.courseId,_that.gradeId,_that.classroomId,_that.subjectId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ScopeModel implements ScopeModel {
  const _ScopeModel({this.campusId, this.courseId, this.gradeId, this.classroomId, this.subjectId});
  factory _ScopeModel.fromJson(Map<String, dynamic> json) => _$ScopeModelFromJson(json);

@override final  String? campusId;
@override final  String? courseId;
@override final  String? gradeId;
@override final  String? classroomId;
@override final  String? subjectId;

/// Create a copy of ScopeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScopeModelCopyWith<_ScopeModel> get copyWith => __$ScopeModelCopyWithImpl<_ScopeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScopeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScopeModel&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,campusId,courseId,gradeId,classroomId,subjectId);

@override
String toString() {
  return 'ScopeModel(campusId: $campusId, courseId: $courseId, gradeId: $gradeId, classroomId: $classroomId, subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class _$ScopeModelCopyWith<$Res> implements $ScopeModelCopyWith<$Res> {
  factory _$ScopeModelCopyWith(_ScopeModel value, $Res Function(_ScopeModel) _then) = __$ScopeModelCopyWithImpl;
@override @useResult
$Res call({
 String? campusId, String? courseId, String? gradeId, String? classroomId, String? subjectId
});




}
/// @nodoc
class __$ScopeModelCopyWithImpl<$Res>
    implements _$ScopeModelCopyWith<$Res> {
  __$ScopeModelCopyWithImpl(this._self, this._then);

  final _ScopeModel _self;
  final $Res Function(_ScopeModel) _then;

/// Create a copy of ScopeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? campusId = freezed,Object? courseId = freezed,Object? gradeId = freezed,Object? classroomId = freezed,Object? subjectId = freezed,}) {
  return _then(_ScopeModel(
campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String?,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
