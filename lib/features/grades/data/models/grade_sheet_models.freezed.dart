// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_sheet_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GradeRowModel {

 String get studentId; Map<String, double> get scores;
/// Create a copy of GradeRowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeRowModelCopyWith<GradeRowModel> get copyWith => _$GradeRowModelCopyWithImpl<GradeRowModel>(this as GradeRowModel, _$identity);

  /// Serializes this GradeRowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeRowModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other.scores, scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,const DeepCollectionEquality().hash(scores));

@override
String toString() {
  return 'GradeRowModel(studentId: $studentId, scores: $scores)';
}


}

/// @nodoc
abstract mixin class $GradeRowModelCopyWith<$Res>  {
  factory $GradeRowModelCopyWith(GradeRowModel value, $Res Function(GradeRowModel) _then) = _$GradeRowModelCopyWithImpl;
@useResult
$Res call({
 String studentId, Map<String, double> scores
});




}
/// @nodoc
class _$GradeRowModelCopyWithImpl<$Res>
    implements $GradeRowModelCopyWith<$Res> {
  _$GradeRowModelCopyWithImpl(this._self, this._then);

  final GradeRowModel _self;
  final $Res Function(GradeRowModel) _then;

/// Create a copy of GradeRowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? scores = null,}) {
  return _then(GradeRowModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeRowModel].
extension GradeRowModelPatterns on GradeRowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeRowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeRowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeRowModel value)  $default,){
final _that = this;
switch (_that) {
case _GradeRowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeRowModel value)?  $default,){
final _that = this;
switch (_that) {
case _GradeRowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  Map<String, double> scores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeRowModel() when $default != null:
return $default(_that.studentId,_that.scores);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  Map<String, double> scores)  $default,) {final _that = this;
switch (_that) {
case _GradeRowModel():
return $default(_that.studentId,_that.scores);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  Map<String, double> scores)?  $default,) {final _that = this;
switch (_that) {
case _GradeRowModel() when $default != null:
return $default(_that.studentId,_that.scores);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradeRowModel implements GradeRowModel {
  const _GradeRowModel({required this.studentId,  Map<String, double> scores = const <String, double>{}}): _scores = scores;
  factory _GradeRowModel.fromJson(Map<String, dynamic> json) => _$GradeRowModelFromJson(json);

@override final  String studentId;
 final  Map<String, double> _scores;
@override@JsonKey() Map<String, double> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scores);
}


/// Create a copy of GradeRowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeRowModelCopyWith<_GradeRowModel> get copyWith => __$GradeRowModelCopyWithImpl<_GradeRowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeRowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeRowModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other._scores, _scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,const DeepCollectionEquality().hash(_scores));

@override
String toString() {
  return 'GradeRowModel(studentId: $studentId, scores: $scores)';
}


}

/// @nodoc
abstract mixin class _$GradeRowModelCopyWith<$Res> implements $GradeRowModelCopyWith<$Res> {
  factory _$GradeRowModelCopyWith(_GradeRowModel value, $Res Function(_GradeRowModel) _then) = __$GradeRowModelCopyWithImpl;
@override @useResult
$Res call({
 String studentId, Map<String, double> scores
});




}
/// @nodoc
class __$GradeRowModelCopyWithImpl<$Res>
    implements _$GradeRowModelCopyWith<$Res> {
  __$GradeRowModelCopyWithImpl(this._self, this._then);

  final _GradeRowModel _self;
  final $Res Function(_GradeRowModel) _then;

/// Create a copy of GradeRowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? scores = null,}) {
  return _then(_GradeRowModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}


/// @nodoc
mixin _$GradeSheetModel {

 String get classroomId; String get subjectId; String get termId; AssessmentSchemeModel get scheme; bool get termClosed;/// Prazo de lançamento (`AAAA-MM-DD`), se o trimestre tiver um.
 String? get deadline; bool get deadlinePassed; List<GradeRowModel> get rows;
/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeSheetModelCopyWith<GradeSheetModel> get copyWith => _$GradeSheetModelCopyWithImpl<GradeSheetModel>(this as GradeSheetModel, _$identity);

  /// Serializes this GradeSheetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeSheetModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.scheme, scheme) || other.scheme == scheme)&&(identical(other.termClosed, termClosed) || other.termClosed == termClosed)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.deadlinePassed, deadlinePassed) || other.deadlinePassed == deadlinePassed)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,subjectId,termId,scheme,termClosed,deadline,deadlinePassed,const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'GradeSheetModel(classroomId: $classroomId, subjectId: $subjectId, termId: $termId, scheme: $scheme, termClosed: $termClosed, deadline: $deadline, deadlinePassed: $deadlinePassed, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $GradeSheetModelCopyWith<$Res>  {
  factory $GradeSheetModelCopyWith(GradeSheetModel value, $Res Function(GradeSheetModel) _then) = _$GradeSheetModelCopyWithImpl;
@useResult
$Res call({
 String classroomId, String subjectId, String termId, AssessmentSchemeModel scheme, bool termClosed, String? deadline, bool deadlinePassed, List<GradeRowModel> rows
});


$AssessmentSchemeModelCopyWith<$Res> get scheme;

}
/// @nodoc
class _$GradeSheetModelCopyWithImpl<$Res>
    implements $GradeSheetModelCopyWith<$Res> {
  _$GradeSheetModelCopyWithImpl(this._self, this._then);

  final GradeSheetModel _self;
  final $Res Function(GradeSheetModel) _then;

/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroomId = null,Object? subjectId = null,Object? termId = null,Object? scheme = null,Object? termClosed = null,Object? deadline = freezed,Object? deadlinePassed = null,Object? rows = null,}) {
  return _then(GradeSheetModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,scheme: null == scheme ? _self.scheme : scheme // ignore: cast_nullable_to_non_nullable
as AssessmentSchemeModel,termClosed: null == termClosed ? _self.termClosed : termClosed // ignore: cast_nullable_to_non_nullable
as bool,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,deadlinePassed: null == deadlinePassed ? _self.deadlinePassed : deadlinePassed // ignore: cast_nullable_to_non_nullable
as bool,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<GradeRowModel>,
  ));
}
/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentSchemeModelCopyWith<$Res> get scheme {
  
  return $AssessmentSchemeModelCopyWith<$Res>(_self.scheme, (value) {
    return _then(_self.copyWith(scheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [GradeSheetModel].
extension GradeSheetModelPatterns on GradeSheetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeSheetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeSheetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeSheetModel value)  $default,){
final _that = this;
switch (_that) {
case _GradeSheetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeSheetModel value)?  $default,){
final _that = this;
switch (_that) {
case _GradeSheetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroomId,  String subjectId,  String termId,  AssessmentSchemeModel scheme,  bool termClosed,  String? deadline,  bool deadlinePassed,  List<GradeRowModel> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeSheetModel() when $default != null:
return $default(_that.classroomId,_that.subjectId,_that.termId,_that.scheme,_that.termClosed,_that.deadline,_that.deadlinePassed,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroomId,  String subjectId,  String termId,  AssessmentSchemeModel scheme,  bool termClosed,  String? deadline,  bool deadlinePassed,  List<GradeRowModel> rows)  $default,) {final _that = this;
switch (_that) {
case _GradeSheetModel():
return $default(_that.classroomId,_that.subjectId,_that.termId,_that.scheme,_that.termClosed,_that.deadline,_that.deadlinePassed,_that.rows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroomId,  String subjectId,  String termId,  AssessmentSchemeModel scheme,  bool termClosed,  String? deadline,  bool deadlinePassed,  List<GradeRowModel> rows)?  $default,) {final _that = this;
switch (_that) {
case _GradeSheetModel() when $default != null:
return $default(_that.classroomId,_that.subjectId,_that.termId,_that.scheme,_that.termClosed,_that.deadline,_that.deadlinePassed,_that.rows);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GradeSheetModel implements GradeSheetModel {
  const _GradeSheetModel({required this.classroomId, required this.subjectId, required this.termId, required this.scheme, this.termClosed = false, this.deadline, this.deadlinePassed = false,  List<GradeRowModel> rows = const <GradeRowModel>[]}): _rows = rows;
  factory _GradeSheetModel.fromJson(Map<String, dynamic> json) => _$GradeSheetModelFromJson(json);

@override final  String classroomId;
@override final  String subjectId;
@override final  String termId;
@override final  AssessmentSchemeModel scheme;
@override@JsonKey() final  bool termClosed;
/// Prazo de lançamento (`AAAA-MM-DD`), se o trimestre tiver um.
@override final  String? deadline;
@override@JsonKey() final  bool deadlinePassed;
 final  List<GradeRowModel> _rows;
@override@JsonKey() List<GradeRowModel> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeSheetModelCopyWith<_GradeSheetModel> get copyWith => __$GradeSheetModelCopyWithImpl<_GradeSheetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeSheetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeSheetModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.scheme, scheme) || other.scheme == scheme)&&(identical(other.termClosed, termClosed) || other.termClosed == termClosed)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.deadlinePassed, deadlinePassed) || other.deadlinePassed == deadlinePassed)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,subjectId,termId,scheme,termClosed,deadline,deadlinePassed,const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'GradeSheetModel(classroomId: $classroomId, subjectId: $subjectId, termId: $termId, scheme: $scheme, termClosed: $termClosed, deadline: $deadline, deadlinePassed: $deadlinePassed, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$GradeSheetModelCopyWith<$Res> implements $GradeSheetModelCopyWith<$Res> {
  factory _$GradeSheetModelCopyWith(_GradeSheetModel value, $Res Function(_GradeSheetModel) _then) = __$GradeSheetModelCopyWithImpl;
@override @useResult
$Res call({
 String classroomId, String subjectId, String termId, AssessmentSchemeModel scheme, bool termClosed, String? deadline, bool deadlinePassed, List<GradeRowModel> rows
});


@override $AssessmentSchemeModelCopyWith<$Res> get scheme;

}
/// @nodoc
class __$GradeSheetModelCopyWithImpl<$Res>
    implements _$GradeSheetModelCopyWith<$Res> {
  __$GradeSheetModelCopyWithImpl(this._self, this._then);

  final _GradeSheetModel _self;
  final $Res Function(_GradeSheetModel) _then;

/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroomId = null,Object? subjectId = null,Object? termId = null,Object? scheme = null,Object? termClosed = null,Object? deadline = freezed,Object? deadlinePassed = null,Object? rows = null,}) {
  return _then(_GradeSheetModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,scheme: null == scheme ? _self.scheme : scheme // ignore: cast_nullable_to_non_nullable
as AssessmentSchemeModel,termClosed: null == termClosed ? _self.termClosed : termClosed // ignore: cast_nullable_to_non_nullable
as bool,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,deadlinePassed: null == deadlinePassed ? _self.deadlinePassed : deadlinePassed // ignore: cast_nullable_to_non_nullable
as bool,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<GradeRowModel>,
  ));
}

/// Create a copy of GradeSheetModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentSchemeModelCopyWith<$Res> get scheme {
  
  return $AssessmentSchemeModelCopyWith<$Res>(_self.scheme, (value) {
    return _then(_self.copyWith(scheme: value));
  });
}
}


/// @nodoc
mixin _$GradeChangeModel {

 String get id; String get classroomId; String get subjectId; String get termId; String get studentId; String get componentCode; double? get before; double? get after;/// Alteração feita com a folha bloqueada (pós-fecho/prazo).
 bool get afterLock; String? get justification;@UtcDateTimeConverter() DateTime get changedAt;
/// Create a copy of GradeChangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeChangeModelCopyWith<GradeChangeModel> get copyWith => _$GradeChangeModelCopyWithImpl<GradeChangeModel>(this as GradeChangeModel, _$identity);

  /// Serializes this GradeChangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeChangeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.componentCode, componentCode) || other.componentCode == componentCode)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.afterLock, afterLock) || other.afterLock == afterLock)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,subjectId,termId,studentId,componentCode,before,after,afterLock,justification,changedAt);

@override
String toString() {
  return 'GradeChangeModel(id: $id, classroomId: $classroomId, subjectId: $subjectId, termId: $termId, studentId: $studentId, componentCode: $componentCode, before: $before, after: $after, afterLock: $afterLock, justification: $justification, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class $GradeChangeModelCopyWith<$Res>  {
  factory $GradeChangeModelCopyWith(GradeChangeModel value, $Res Function(GradeChangeModel) _then) = _$GradeChangeModelCopyWithImpl;
@useResult
$Res call({
 String id, String classroomId, String subjectId, String termId, String studentId, String componentCode, double? before, double? after, bool afterLock, String? justification,@UtcDateTimeConverter() DateTime changedAt
});




}
/// @nodoc
class _$GradeChangeModelCopyWithImpl<$Res>
    implements $GradeChangeModelCopyWith<$Res> {
  _$GradeChangeModelCopyWithImpl(this._self, this._then);

  final GradeChangeModel _self;
  final $Res Function(GradeChangeModel) _then;

/// Create a copy of GradeChangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? classroomId = null,Object? subjectId = null,Object? termId = null,Object? studentId = null,Object? componentCode = null,Object? before = freezed,Object? after = freezed,Object? afterLock = null,Object? justification = freezed,Object? changedAt = null,}) {
  return _then(GradeChangeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,componentCode: null == componentCode ? _self.componentCode : componentCode // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as double?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as double?,afterLock: null == afterLock ? _self.afterLock : afterLock // ignore: cast_nullable_to_non_nullable
as bool,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeChangeModel].
extension GradeChangeModelPatterns on GradeChangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeChangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeChangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeChangeModel value)  $default,){
final _that = this;
switch (_that) {
case _GradeChangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeChangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _GradeChangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String classroomId,  String subjectId,  String termId,  String studentId,  String componentCode,  double? before,  double? after,  bool afterLock,  String? justification, @UtcDateTimeConverter()  DateTime changedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeChangeModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.subjectId,_that.termId,_that.studentId,_that.componentCode,_that.before,_that.after,_that.afterLock,_that.justification,_that.changedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String classroomId,  String subjectId,  String termId,  String studentId,  String componentCode,  double? before,  double? after,  bool afterLock,  String? justification, @UtcDateTimeConverter()  DateTime changedAt)  $default,) {final _that = this;
switch (_that) {
case _GradeChangeModel():
return $default(_that.id,_that.classroomId,_that.subjectId,_that.termId,_that.studentId,_that.componentCode,_that.before,_that.after,_that.afterLock,_that.justification,_that.changedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String classroomId,  String subjectId,  String termId,  String studentId,  String componentCode,  double? before,  double? after,  bool afterLock,  String? justification, @UtcDateTimeConverter()  DateTime changedAt)?  $default,) {final _that = this;
switch (_that) {
case _GradeChangeModel() when $default != null:
return $default(_that.id,_that.classroomId,_that.subjectId,_that.termId,_that.studentId,_that.componentCode,_that.before,_that.after,_that.afterLock,_that.justification,_that.changedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradeChangeModel implements GradeChangeModel {
  const _GradeChangeModel({required this.id, required this.classroomId, required this.subjectId, required this.termId, required this.studentId, required this.componentCode, this.before, this.after, this.afterLock = false, this.justification, @UtcDateTimeConverter() required this.changedAt});
  factory _GradeChangeModel.fromJson(Map<String, dynamic> json) => _$GradeChangeModelFromJson(json);

@override final  String id;
@override final  String classroomId;
@override final  String subjectId;
@override final  String termId;
@override final  String studentId;
@override final  String componentCode;
@override final  double? before;
@override final  double? after;
/// Alteração feita com a folha bloqueada (pós-fecho/prazo).
@override@JsonKey() final  bool afterLock;
@override final  String? justification;
@override@UtcDateTimeConverter() final  DateTime changedAt;

/// Create a copy of GradeChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeChangeModelCopyWith<_GradeChangeModel> get copyWith => __$GradeChangeModelCopyWithImpl<_GradeChangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeChangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeChangeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.componentCode, componentCode) || other.componentCode == componentCode)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.afterLock, afterLock) || other.afterLock == afterLock)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classroomId,subjectId,termId,studentId,componentCode,before,after,afterLock,justification,changedAt);

@override
String toString() {
  return 'GradeChangeModel(id: $id, classroomId: $classroomId, subjectId: $subjectId, termId: $termId, studentId: $studentId, componentCode: $componentCode, before: $before, after: $after, afterLock: $afterLock, justification: $justification, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class _$GradeChangeModelCopyWith<$Res> implements $GradeChangeModelCopyWith<$Res> {
  factory _$GradeChangeModelCopyWith(_GradeChangeModel value, $Res Function(_GradeChangeModel) _then) = __$GradeChangeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String classroomId, String subjectId, String termId, String studentId, String componentCode, double? before, double? after, bool afterLock, String? justification,@UtcDateTimeConverter() DateTime changedAt
});




}
/// @nodoc
class __$GradeChangeModelCopyWithImpl<$Res>
    implements _$GradeChangeModelCopyWith<$Res> {
  __$GradeChangeModelCopyWithImpl(this._self, this._then);

  final _GradeChangeModel _self;
  final $Res Function(_GradeChangeModel) _then;

/// Create a copy of GradeChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? classroomId = null,Object? subjectId = null,Object? termId = null,Object? studentId = null,Object? componentCode = null,Object? before = freezed,Object? after = freezed,Object? afterLock = null,Object? justification = freezed,Object? changedAt = null,}) {
  return _then(_GradeChangeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,componentCode: null == componentCode ? _self.componentCode : componentCode // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as double?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as double?,afterLock: null == afterLock ? _self.afterLock : afterLock // ignore: cast_nullable_to_non_nullable
as bool,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
