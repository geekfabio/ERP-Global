// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRecordModel {

/// Atribuído pelo servidor.
 String get id; String get classroomId; String get studentId;/// Dia (`AAAA-MM-DD`).
 String get date;/// Aula do horário; nulo = registo do dia.
 String? get lessonSlotId; AttendanceStatus get status;/// Motivo da justificação (só faltas).
 String? get justification;
/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordModelCopyWith<AttendanceRecordModel> get copyWith => _$AttendanceRecordModelCopyWithImpl<AttendanceRecordModel>(this as AttendanceRecordModel, _$identity);

  /// Serializes this AttendanceRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonSlotId, lessonSlotId) || other.lessonSlotId == lessonSlotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.justification, justification) || other.justification == justification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,studentId,date,lessonSlotId,status,justification);

@override
String toString() {
  return 'AttendanceRecordModel(id: $id, classroomId: $classroomId, studentId: $studentId, date: $date, lessonSlotId: $lessonSlotId, status: $status, justification: $justification)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordModelCopyWith<$Res>  {
  factory $AttendanceRecordModelCopyWith(AttendanceRecordModel value, $Res Function(AttendanceRecordModel) _then) = _$AttendanceRecordModelCopyWithImpl;
@useResult
$Res call({
 String id, String classroomId, String studentId, String date, String? lessonSlotId, AttendanceStatus status, String? justification
});




}
/// @nodoc
class _$AttendanceRecordModelCopyWithImpl<$Res>
    implements $AttendanceRecordModelCopyWith<$Res> {
  _$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final AttendanceRecordModel _self;
  final $Res Function(AttendanceRecordModel) _then;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? classroomId = null,Object? studentId = null,Object? date = null,Object? lessonSlotId = freezed,Object? status = null,Object? justification = freezed,}) {
  return _then(AttendanceRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonSlotId: freezed == lessonSlotId ? _self.lessonSlotId : lessonSlotId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecordModel].
extension AttendanceRecordModelPatterns on AttendanceRecordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String classroomId,  String studentId,  String date,  String? lessonSlotId,  AttendanceStatus status,  String? justification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.studentId,_that.date,_that.lessonSlotId,_that.status,_that.justification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String classroomId,  String studentId,  String date,  String? lessonSlotId,  AttendanceStatus status,  String? justification)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecordModel():
return $default(_that.id,_that.classroomId,_that.studentId,_that.date,_that.lessonSlotId,_that.status,_that.justification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String classroomId,  String studentId,  String date,  String? lessonSlotId,  AttendanceStatus status,  String? justification)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecordModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.studentId,_that.date,_that.lessonSlotId,_that.status,_that.justification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRecordModel implements AttendanceRecordModel {
  const _AttendanceRecordModel({this.id = '', required this.classroomId, required this.studentId, required this.date, this.lessonSlotId, required this.status, this.justification});
  factory _AttendanceRecordModel.fromJson(Map<String, dynamic> json) => _$AttendanceRecordModelFromJson(json);

/// Atribuído pelo servidor.
@override@JsonKey() final  String id;
@override final  String classroomId;
@override final  String studentId;
/// Dia (`AAAA-MM-DD`).
@override final  String date;
/// Aula do horário; nulo = registo do dia.
@override final  String? lessonSlotId;
@override final  AttendanceStatus status;
/// Motivo da justificação (só faltas).
@override final  String? justification;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordModelCopyWith<_AttendanceRecordModel> get copyWith => __$AttendanceRecordModelCopyWithImpl<_AttendanceRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonSlotId, lessonSlotId) || other.lessonSlotId == lessonSlotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.justification, justification) || other.justification == justification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,studentId,date,lessonSlotId,status,justification);

@override
String toString() {
  return 'AttendanceRecordModel(id: $id, classroomId: $classroomId, studentId: $studentId, date: $date, lessonSlotId: $lessonSlotId, status: $status, justification: $justification)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordModelCopyWith<$Res> implements $AttendanceRecordModelCopyWith<$Res> {
  factory _$AttendanceRecordModelCopyWith(_AttendanceRecordModel value, $Res Function(_AttendanceRecordModel) _then) = __$AttendanceRecordModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String classroomId, String studentId, String date, String? lessonSlotId, AttendanceStatus status, String? justification
});




}
/// @nodoc
class __$AttendanceRecordModelCopyWithImpl<$Res>
    implements _$AttendanceRecordModelCopyWith<$Res> {
  __$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final _AttendanceRecordModel _self;
  final $Res Function(_AttendanceRecordModel) _then;

/// Create a copy of AttendanceRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? classroomId = null,Object? studentId = null,Object? date = null,Object? lessonSlotId = freezed,Object? status = null,Object? justification = freezed,}) {
  return _then(_AttendanceRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonSlotId: freezed == lessonSlotId ? _self.lessonSlotId : lessonSlotId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AttendanceSheetModel {

 String get classroomId; String get date; String? get lessonSlotId; List<AttendanceRecordModel> get rows;
/// Create a copy of AttendanceSheetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSheetModelCopyWith<AttendanceSheetModel> get copyWith => _$AttendanceSheetModelCopyWithImpl<AttendanceSheetModel>(this as AttendanceSheetModel, _$identity);

  /// Serializes this AttendanceSheetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSheetModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonSlotId, lessonSlotId) || other.lessonSlotId == lessonSlotId)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,date,lessonSlotId,const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'AttendanceSheetModel(classroomId: $classroomId, date: $date, lessonSlotId: $lessonSlotId, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $AttendanceSheetModelCopyWith<$Res>  {
  factory $AttendanceSheetModelCopyWith(AttendanceSheetModel value, $Res Function(AttendanceSheetModel) _then) = _$AttendanceSheetModelCopyWithImpl;
@useResult
$Res call({
 String classroomId, String date, String? lessonSlotId, List<AttendanceRecordModel> rows
});




}
/// @nodoc
class _$AttendanceSheetModelCopyWithImpl<$Res>
    implements $AttendanceSheetModelCopyWith<$Res> {
  _$AttendanceSheetModelCopyWithImpl(this._self, this._then);

  final AttendanceSheetModel _self;
  final $Res Function(AttendanceSheetModel) _then;

/// Create a copy of AttendanceSheetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroomId = null,Object? date = null,Object? lessonSlotId = freezed,Object? rows = null,}) {
  return _then(AttendanceSheetModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonSlotId: freezed == lessonSlotId ? _self.lessonSlotId : lessonSlotId // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecordModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSheetModel].
extension AttendanceSheetModelPatterns on AttendanceSheetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSheetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSheetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSheetModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSheetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSheetModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSheetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroomId,  String date,  String? lessonSlotId,  List<AttendanceRecordModel> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSheetModel() when $default != null:
return $default(_that.classroomId,_that.date,_that.lessonSlotId,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroomId,  String date,  String? lessonSlotId,  List<AttendanceRecordModel> rows)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSheetModel():
return $default(_that.classroomId,_that.date,_that.lessonSlotId,_that.rows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroomId,  String date,  String? lessonSlotId,  List<AttendanceRecordModel> rows)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSheetModel() when $default != null:
return $default(_that.classroomId,_that.date,_that.lessonSlotId,_that.rows);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AttendanceSheetModel implements AttendanceSheetModel {
  const _AttendanceSheetModel({required this.classroomId, required this.date, this.lessonSlotId,  List<AttendanceRecordModel> rows = const <AttendanceRecordModel>[]}): _rows = rows;
  factory _AttendanceSheetModel.fromJson(Map<String, dynamic> json) => _$AttendanceSheetModelFromJson(json);

@override final  String classroomId;
@override final  String date;
@override final  String? lessonSlotId;
 final  List<AttendanceRecordModel> _rows;
@override@JsonKey() List<AttendanceRecordModel> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of AttendanceSheetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSheetModelCopyWith<_AttendanceSheetModel> get copyWith => __$AttendanceSheetModelCopyWithImpl<_AttendanceSheetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceSheetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSheetModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonSlotId, lessonSlotId) || other.lessonSlotId == lessonSlotId)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,date,lessonSlotId,const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'AttendanceSheetModel(classroomId: $classroomId, date: $date, lessonSlotId: $lessonSlotId, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSheetModelCopyWith<$Res> implements $AttendanceSheetModelCopyWith<$Res> {
  factory _$AttendanceSheetModelCopyWith(_AttendanceSheetModel value, $Res Function(_AttendanceSheetModel) _then) = __$AttendanceSheetModelCopyWithImpl;
@override @useResult
$Res call({
 String classroomId, String date, String? lessonSlotId, List<AttendanceRecordModel> rows
});




}
/// @nodoc
class __$AttendanceSheetModelCopyWithImpl<$Res>
    implements _$AttendanceSheetModelCopyWith<$Res> {
  __$AttendanceSheetModelCopyWithImpl(this._self, this._then);

  final _AttendanceSheetModel _self;
  final $Res Function(_AttendanceSheetModel) _then;

/// Create a copy of AttendanceSheetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroomId = null,Object? date = null,Object? lessonSlotId = freezed,Object? rows = null,}) {
  return _then(_AttendanceSheetModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonSlotId: freezed == lessonSlotId ? _self.lessonSlotId : lessonSlotId // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecordModel>,
  ));
}


}


/// @nodoc
mixin _$AttendanceSettingsModel {

 int get absenceLimit;
/// Create a copy of AttendanceSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSettingsModelCopyWith<AttendanceSettingsModel> get copyWith => _$AttendanceSettingsModelCopyWithImpl<AttendanceSettingsModel>(this as AttendanceSettingsModel, _$identity);

  /// Serializes this AttendanceSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSettingsModel&&(identical(other.absenceLimit, absenceLimit) || other.absenceLimit == absenceLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,absenceLimit);

@override
String toString() {
  return 'AttendanceSettingsModel(absenceLimit: $absenceLimit)';
}


}

/// @nodoc
abstract mixin class $AttendanceSettingsModelCopyWith<$Res>  {
  factory $AttendanceSettingsModelCopyWith(AttendanceSettingsModel value, $Res Function(AttendanceSettingsModel) _then) = _$AttendanceSettingsModelCopyWithImpl;
@useResult
$Res call({
 int absenceLimit
});




}
/// @nodoc
class _$AttendanceSettingsModelCopyWithImpl<$Res>
    implements $AttendanceSettingsModelCopyWith<$Res> {
  _$AttendanceSettingsModelCopyWithImpl(this._self, this._then);

  final AttendanceSettingsModel _self;
  final $Res Function(AttendanceSettingsModel) _then;

/// Create a copy of AttendanceSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? absenceLimit = null,}) {
  return _then(AttendanceSettingsModel(
absenceLimit: null == absenceLimit ? _self.absenceLimit : absenceLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSettingsModel].
extension AttendanceSettingsModelPatterns on AttendanceSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int absenceLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSettingsModel() when $default != null:
return $default(_that.absenceLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int absenceLimit)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSettingsModel():
return $default(_that.absenceLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int absenceLimit)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSettingsModel() when $default != null:
return $default(_that.absenceLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceSettingsModel implements AttendanceSettingsModel {
  const _AttendanceSettingsModel({this.absenceLimit = 10});
  factory _AttendanceSettingsModel.fromJson(Map<String, dynamic> json) => _$AttendanceSettingsModelFromJson(json);

@override@JsonKey() final  int absenceLimit;

/// Create a copy of AttendanceSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSettingsModelCopyWith<_AttendanceSettingsModel> get copyWith => __$AttendanceSettingsModelCopyWithImpl<_AttendanceSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSettingsModel&&(identical(other.absenceLimit, absenceLimit) || other.absenceLimit == absenceLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,absenceLimit);

@override
String toString() {
  return 'AttendanceSettingsModel(absenceLimit: $absenceLimit)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSettingsModelCopyWith<$Res> implements $AttendanceSettingsModelCopyWith<$Res> {
  factory _$AttendanceSettingsModelCopyWith(_AttendanceSettingsModel value, $Res Function(_AttendanceSettingsModel) _then) = __$AttendanceSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 int absenceLimit
});




}
/// @nodoc
class __$AttendanceSettingsModelCopyWithImpl<$Res>
    implements _$AttendanceSettingsModelCopyWith<$Res> {
  __$AttendanceSettingsModelCopyWithImpl(this._self, this._then);

  final _AttendanceSettingsModel _self;
  final $Res Function(_AttendanceSettingsModel) _then;

/// Create a copy of AttendanceSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? absenceLimit = null,}) {
  return _then(_AttendanceSettingsModel(
absenceLimit: null == absenceLimit ? _self.absenceLimit : absenceLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AttendanceAlertModel {

 String get studentId; String get classroomId; int get unjustified; int get limit;
/// Create a copy of AttendanceAlertModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceAlertModelCopyWith<AttendanceAlertModel> get copyWith => _$AttendanceAlertModelCopyWithImpl<AttendanceAlertModel>(this as AttendanceAlertModel, _$identity);

  /// Serializes this AttendanceAlertModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceAlertModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.unjustified, unjustified) || other.unjustified == unjustified)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,classroomId,unjustified,limit);

@override
String toString() {
  return 'AttendanceAlertModel(studentId: $studentId, classroomId: $classroomId, unjustified: $unjustified, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $AttendanceAlertModelCopyWith<$Res>  {
  factory $AttendanceAlertModelCopyWith(AttendanceAlertModel value, $Res Function(AttendanceAlertModel) _then) = _$AttendanceAlertModelCopyWithImpl;
@useResult
$Res call({
 String studentId, String classroomId, int unjustified, int limit
});




}
/// @nodoc
class _$AttendanceAlertModelCopyWithImpl<$Res>
    implements $AttendanceAlertModelCopyWith<$Res> {
  _$AttendanceAlertModelCopyWithImpl(this._self, this._then);

  final AttendanceAlertModel _self;
  final $Res Function(AttendanceAlertModel) _then;

/// Create a copy of AttendanceAlertModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? classroomId = null,Object? unjustified = null,Object? limit = null,}) {
  return _then(AttendanceAlertModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,unjustified: null == unjustified ? _self.unjustified : unjustified // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceAlertModel].
extension AttendanceAlertModelPatterns on AttendanceAlertModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceAlertModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceAlertModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceAlertModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceAlertModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceAlertModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceAlertModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String classroomId,  int unjustified,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceAlertModel() when $default != null:
return $default(_that.studentId,_that.classroomId,_that.unjustified,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String classroomId,  int unjustified,  int limit)  $default,) {final _that = this;
switch (_that) {
case _AttendanceAlertModel():
return $default(_that.studentId,_that.classroomId,_that.unjustified,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String classroomId,  int unjustified,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceAlertModel() when $default != null:
return $default(_that.studentId,_that.classroomId,_that.unjustified,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceAlertModel implements AttendanceAlertModel {
  const _AttendanceAlertModel({required this.studentId, required this.classroomId, required this.unjustified, required this.limit});
  factory _AttendanceAlertModel.fromJson(Map<String, dynamic> json) => _$AttendanceAlertModelFromJson(json);

@override final  String studentId;
@override final  String classroomId;
@override final  int unjustified;
@override final  int limit;

/// Create a copy of AttendanceAlertModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceAlertModelCopyWith<_AttendanceAlertModel> get copyWith => __$AttendanceAlertModelCopyWithImpl<_AttendanceAlertModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceAlertModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceAlertModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.unjustified, unjustified) || other.unjustified == unjustified)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,classroomId,unjustified,limit);

@override
String toString() {
  return 'AttendanceAlertModel(studentId: $studentId, classroomId: $classroomId, unjustified: $unjustified, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$AttendanceAlertModelCopyWith<$Res> implements $AttendanceAlertModelCopyWith<$Res> {
  factory _$AttendanceAlertModelCopyWith(_AttendanceAlertModel value, $Res Function(_AttendanceAlertModel) _then) = __$AttendanceAlertModelCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String classroomId, int unjustified, int limit
});




}
/// @nodoc
class __$AttendanceAlertModelCopyWithImpl<$Res>
    implements _$AttendanceAlertModelCopyWith<$Res> {
  __$AttendanceAlertModelCopyWithImpl(this._self, this._then);

  final _AttendanceAlertModel _self;
  final $Res Function(_AttendanceAlertModel) _then;

/// Create a copy of AttendanceAlertModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? classroomId = null,Object? unjustified = null,Object? limit = null,}) {
  return _then(_AttendanceAlertModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,unjustified: null == unjustified ? _self.unjustified : unjustified // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
