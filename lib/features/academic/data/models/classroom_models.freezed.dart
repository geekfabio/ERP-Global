// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomModel {

 String get id; String get code; String get name; int get capacity; bool get isActive;
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomModelCopyWith<RoomModel> get copyWith => _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,capacity,isActive);

@override
String toString() {
  return 'RoomModel(id: $id, code: $code, name: $name, capacity: $capacity, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res>  {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) = _$RoomModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, int capacity, bool isActive
});




}
/// @nodoc
class _$RoomModelCopyWithImpl<$Res>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._self, this._then);

  final RoomModel _self;
  final $Res Function(RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? capacity = null,Object? isActive = null,}) {
  return _then(RoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomModel].
extension RoomModelPatterns on RoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int capacity,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.capacity,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int capacity,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _RoomModel():
return $default(_that.id,_that.code,_that.name,_that.capacity,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  int capacity,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.capacity,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomModel implements RoomModel {
  const _RoomModel({required this.id, required this.code, required this.name, required this.capacity, this.isActive = true});
  factory _RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  int capacity;
@override@JsonKey() final  bool isActive;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomModelCopyWith<_RoomModel> get copyWith => __$RoomModelCopyWithImpl<_RoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,capacity,isActive);

@override
String toString() {
  return 'RoomModel(id: $id, code: $code, name: $name, capacity: $capacity, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res> implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(_RoomModel value, $Res Function(_RoomModel) _then) = __$RoomModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, int capacity, bool isActive
});




}
/// @nodoc
class __$RoomModelCopyWithImpl<$Res>
    implements _$RoomModelCopyWith<$Res> {
  __$RoomModelCopyWithImpl(this._self, this._then);

  final _RoomModel _self;
  final $Res Function(_RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? capacity = null,Object? isActive = null,}) {
  return _then(_RoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ShiftModel {

 String get id; String get name; String get startTime; String get endTime; bool get isActive;
/// Create a copy of ShiftModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftModelCopyWith<ShiftModel> get copyWith => _$ShiftModelCopyWithImpl<ShiftModel>(this as ShiftModel, _$identity);

  /// Serializes this ShiftModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,endTime,isActive);

@override
String toString() {
  return 'ShiftModel(id: $id, name: $name, startTime: $startTime, endTime: $endTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ShiftModelCopyWith<$Res>  {
  factory $ShiftModelCopyWith(ShiftModel value, $Res Function(ShiftModel) _then) = _$ShiftModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String startTime, String endTime, bool isActive
});




}
/// @nodoc
class _$ShiftModelCopyWithImpl<$Res>
    implements $ShiftModelCopyWith<$Res> {
  _$ShiftModelCopyWithImpl(this._self, this._then);

  final ShiftModel _self;
  final $Res Function(ShiftModel) _then;

/// Create a copy of ShiftModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? endTime = null,Object? isActive = null,}) {
  return _then(ShiftModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftModel].
extension ShiftModelPatterns on ShiftModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftModel value)  $default,){
final _that = this;
switch (_that) {
case _ShiftModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String startTime,  String endTime,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftModel() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String startTime,  String endTime,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ShiftModel():
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String startTime,  String endTime,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ShiftModel() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShiftModel implements ShiftModel {
  const _ShiftModel({required this.id, required this.name, required this.startTime, required this.endTime, this.isActive = true});
  factory _ShiftModel.fromJson(Map<String, dynamic> json) => _$ShiftModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  bool isActive;

/// Create a copy of ShiftModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftModelCopyWith<_ShiftModel> get copyWith => __$ShiftModelCopyWithImpl<_ShiftModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShiftModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,endTime,isActive);

@override
String toString() {
  return 'ShiftModel(id: $id, name: $name, startTime: $startTime, endTime: $endTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ShiftModelCopyWith<$Res> implements $ShiftModelCopyWith<$Res> {
  factory _$ShiftModelCopyWith(_ShiftModel value, $Res Function(_ShiftModel) _then) = __$ShiftModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String startTime, String endTime, bool isActive
});




}
/// @nodoc
class __$ShiftModelCopyWithImpl<$Res>
    implements _$ShiftModelCopyWith<$Res> {
  __$ShiftModelCopyWithImpl(this._self, this._then);

  final _ShiftModel _self;
  final $Res Function(_ShiftModel) _then;

/// Create a copy of ShiftModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? endTime = null,Object? isActive = null,}) {
  return _then(_ShiftModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ClassroomModel {

 String get id; String get academicYearId; String get gradeId; String get courseId; String get shiftId; String get roomId;/// Designação da turma dentro da classe (ex.: `A`).
 String get name;/// Vagas (lotação máxima da turma).
 int get capacity;/// Alunos matriculados; gerido pelo servidor (só leitura para a UI).
 int get enrolledCount;
/// Create a copy of ClassroomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomModelCopyWith<ClassroomModel> get copyWith => _$ClassroomModelCopyWithImpl<ClassroomModel>(this as ClassroomModel, _$identity);

  /// Serializes this ClassroomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.name, name) || other.name == name)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,gradeId,courseId,shiftId,roomId,name,capacity,enrolledCount);

@override
String toString() {
  return 'ClassroomModel(id: $id, academicYearId: $academicYearId, gradeId: $gradeId, courseId: $courseId, shiftId: $shiftId, roomId: $roomId, name: $name, capacity: $capacity, enrolledCount: $enrolledCount)';
}


}

/// @nodoc
abstract mixin class $ClassroomModelCopyWith<$Res>  {
  factory $ClassroomModelCopyWith(ClassroomModel value, $Res Function(ClassroomModel) _then) = _$ClassroomModelCopyWithImpl;
@useResult
$Res call({
 String id, String academicYearId, String gradeId, String courseId, String shiftId, String roomId, String name, int capacity, int enrolledCount
});




}
/// @nodoc
class _$ClassroomModelCopyWithImpl<$Res>
    implements $ClassroomModelCopyWith<$Res> {
  _$ClassroomModelCopyWithImpl(this._self, this._then);

  final ClassroomModel _self;
  final $Res Function(ClassroomModel) _then;

/// Create a copy of ClassroomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? academicYearId = null,Object? gradeId = null,Object? courseId = null,Object? shiftId = null,Object? roomId = null,Object? name = null,Object? capacity = null,Object? enrolledCount = null,}) {
  return _then(ClassroomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,shiftId: null == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomModel].
extension ClassroomModelPatterns on ClassroomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomModel value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String gradeId,  String courseId,  String shiftId,  String roomId,  String name,  int capacity,  int enrolledCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.gradeId,_that.courseId,_that.shiftId,_that.roomId,_that.name,_that.capacity,_that.enrolledCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String gradeId,  String courseId,  String shiftId,  String roomId,  String name,  int capacity,  int enrolledCount)  $default,) {final _that = this;
switch (_that) {
case _ClassroomModel():
return $default(_that.id,_that.academicYearId,_that.gradeId,_that.courseId,_that.shiftId,_that.roomId,_that.name,_that.capacity,_that.enrolledCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String academicYearId,  String gradeId,  String courseId,  String shiftId,  String roomId,  String name,  int capacity,  int enrolledCount)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.gradeId,_that.courseId,_that.shiftId,_that.roomId,_that.name,_that.capacity,_that.enrolledCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassroomModel implements ClassroomModel {
  const _ClassroomModel({required this.id, required this.academicYearId, required this.gradeId, required this.courseId, required this.shiftId, required this.roomId, required this.name, required this.capacity, this.enrolledCount = 0});
  factory _ClassroomModel.fromJson(Map<String, dynamic> json) => _$ClassroomModelFromJson(json);

@override final  String id;
@override final  String academicYearId;
@override final  String gradeId;
@override final  String courseId;
@override final  String shiftId;
@override final  String roomId;
/// Designação da turma dentro da classe (ex.: `A`).
@override final  String name;
/// Vagas (lotação máxima da turma).
@override final  int capacity;
/// Alunos matriculados; gerido pelo servidor (só leitura para a UI).
@override@JsonKey() final  int enrolledCount;

/// Create a copy of ClassroomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomModelCopyWith<_ClassroomModel> get copyWith => __$ClassroomModelCopyWithImpl<_ClassroomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassroomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.name, name) || other.name == name)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,gradeId,courseId,shiftId,roomId,name,capacity,enrolledCount);

@override
String toString() {
  return 'ClassroomModel(id: $id, academicYearId: $academicYearId, gradeId: $gradeId, courseId: $courseId, shiftId: $shiftId, roomId: $roomId, name: $name, capacity: $capacity, enrolledCount: $enrolledCount)';
}


}

/// @nodoc
abstract mixin class _$ClassroomModelCopyWith<$Res> implements $ClassroomModelCopyWith<$Res> {
  factory _$ClassroomModelCopyWith(_ClassroomModel value, $Res Function(_ClassroomModel) _then) = __$ClassroomModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String academicYearId, String gradeId, String courseId, String shiftId, String roomId, String name, int capacity, int enrolledCount
});




}
/// @nodoc
class __$ClassroomModelCopyWithImpl<$Res>
    implements _$ClassroomModelCopyWith<$Res> {
  __$ClassroomModelCopyWithImpl(this._self, this._then);

  final _ClassroomModel _self;
  final $Res Function(_ClassroomModel) _then;

/// Create a copy of ClassroomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? academicYearId = null,Object? gradeId = null,Object? courseId = null,Object? shiftId = null,Object? roomId = null,Object? name = null,Object? capacity = null,Object? enrolledCount = null,}) {
  return _then(_ClassroomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,shiftId: null == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
