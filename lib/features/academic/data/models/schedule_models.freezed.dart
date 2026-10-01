// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleSlotModel {

 String get id;/// Derivado da turma pelo servidor.
 String get academicYearId; String get classroomId; String get subjectId; String get teacherId; String get roomId;/// Dia da semana ISO: 1 = segunda ... 6 = sábado.
 int get weekday; String get startTime; String get endTime;
/// Create a copy of ScheduleSlotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleSlotModelCopyWith<ScheduleSlotModel> get copyWith => _$ScheduleSlotModelCopyWithImpl<ScheduleSlotModel>(this as ScheduleSlotModel, _$identity);

  /// Serializes this ScheduleSlotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,classroomId,subjectId,teacherId,roomId,weekday,startTime,endTime);

@override
String toString() {
  return 'ScheduleSlotModel(id: $id, academicYearId: $academicYearId, classroomId: $classroomId, subjectId: $subjectId, teacherId: $teacherId, roomId: $roomId, weekday: $weekday, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $ScheduleSlotModelCopyWith<$Res>  {
  factory $ScheduleSlotModelCopyWith(ScheduleSlotModel value, $Res Function(ScheduleSlotModel) _then) = _$ScheduleSlotModelCopyWithImpl;
@useResult
$Res call({
 String id, String academicYearId, String classroomId, String subjectId, String teacherId, String roomId, int weekday, String startTime, String endTime
});




}
/// @nodoc
class _$ScheduleSlotModelCopyWithImpl<$Res>
    implements $ScheduleSlotModelCopyWith<$Res> {
  _$ScheduleSlotModelCopyWithImpl(this._self, this._then);

  final ScheduleSlotModel _self;
  final $Res Function(ScheduleSlotModel) _then;

/// Create a copy of ScheduleSlotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? academicYearId = null,Object? classroomId = null,Object? subjectId = null,Object? teacherId = null,Object? roomId = null,Object? weekday = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(ScheduleSlotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleSlotModel].
extension ScheduleSlotModelPatterns on ScheduleSlotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleSlotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleSlotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleSlotModel value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleSlotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleSlotModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleSlotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String classroomId,  String subjectId,  String teacherId,  String roomId,  int weekday,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleSlotModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.classroomId,_that.subjectId,_that.teacherId,_that.roomId,_that.weekday,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String classroomId,  String subjectId,  String teacherId,  String roomId,  int weekday,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _ScheduleSlotModel():
return $default(_that.id,_that.academicYearId,_that.classroomId,_that.subjectId,_that.teacherId,_that.roomId,_that.weekday,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String academicYearId,  String classroomId,  String subjectId,  String teacherId,  String roomId,  int weekday,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleSlotModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.classroomId,_that.subjectId,_that.teacherId,_that.roomId,_that.weekday,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleSlotModel implements ScheduleSlotModel {
  const _ScheduleSlotModel({required this.id, this.academicYearId = '', required this.classroomId, required this.subjectId, required this.teacherId, required this.roomId, required this.weekday, required this.startTime, required this.endTime});
  factory _ScheduleSlotModel.fromJson(Map<String, dynamic> json) => _$ScheduleSlotModelFromJson(json);

@override final  String id;
/// Derivado da turma pelo servidor.
@override@JsonKey() final  String academicYearId;
@override final  String classroomId;
@override final  String subjectId;
@override final  String teacherId;
@override final  String roomId;
/// Dia da semana ISO: 1 = segunda ... 6 = sábado.
@override final  int weekday;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of ScheduleSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleSlotModelCopyWith<_ScheduleSlotModel> get copyWith => __$ScheduleSlotModelCopyWithImpl<_ScheduleSlotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleSlotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,classroomId,subjectId,teacherId,roomId,weekday,startTime,endTime);

@override
String toString() {
  return 'ScheduleSlotModel(id: $id, academicYearId: $academicYearId, classroomId: $classroomId, subjectId: $subjectId, teacherId: $teacherId, roomId: $roomId, weekday: $weekday, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ScheduleSlotModelCopyWith<$Res> implements $ScheduleSlotModelCopyWith<$Res> {
  factory _$ScheduleSlotModelCopyWith(_ScheduleSlotModel value, $Res Function(_ScheduleSlotModel) _then) = __$ScheduleSlotModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String academicYearId, String classroomId, String subjectId, String teacherId, String roomId, int weekday, String startTime, String endTime
});




}
/// @nodoc
class __$ScheduleSlotModelCopyWithImpl<$Res>
    implements _$ScheduleSlotModelCopyWith<$Res> {
  __$ScheduleSlotModelCopyWithImpl(this._self, this._then);

  final _ScheduleSlotModel _self;
  final $Res Function(_ScheduleSlotModel) _then;

/// Create a copy of ScheduleSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? academicYearId = null,Object? classroomId = null,Object? subjectId = null,Object? teacherId = null,Object? roomId = null,Object? weekday = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_ScheduleSlotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
