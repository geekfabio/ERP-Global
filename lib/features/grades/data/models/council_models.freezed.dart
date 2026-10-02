// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'council_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CouncilDecisionModel {

 String get studentId; FinalResult get result; String get justification;@UtcDateTimeConverter() DateTime get decidedAt;
/// Create a copy of CouncilDecisionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouncilDecisionModelCopyWith<CouncilDecisionModel> get copyWith => _$CouncilDecisionModelCopyWithImpl<CouncilDecisionModel>(this as CouncilDecisionModel, _$identity);

  /// Serializes this CouncilDecisionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouncilDecisionModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.result, result) || other.result == result)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,result,justification,decidedAt);

@override
String toString() {
  return 'CouncilDecisionModel(studentId: $studentId, result: $result, justification: $justification, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class $CouncilDecisionModelCopyWith<$Res>  {
  factory $CouncilDecisionModelCopyWith(CouncilDecisionModel value, $Res Function(CouncilDecisionModel) _then) = _$CouncilDecisionModelCopyWithImpl;
@useResult
$Res call({
 String studentId, FinalResult result, String justification,@UtcDateTimeConverter() DateTime decidedAt
});




}
/// @nodoc
class _$CouncilDecisionModelCopyWithImpl<$Res>
    implements $CouncilDecisionModelCopyWith<$Res> {
  _$CouncilDecisionModelCopyWithImpl(this._self, this._then);

  final CouncilDecisionModel _self;
  final $Res Function(CouncilDecisionModel) _then;

/// Create a copy of CouncilDecisionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? result = null,Object? justification = null,Object? decidedAt = null,}) {
  return _then(CouncilDecisionModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as FinalResult,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,decidedAt: null == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CouncilDecisionModel].
extension CouncilDecisionModelPatterns on CouncilDecisionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouncilDecisionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouncilDecisionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouncilDecisionModel value)  $default,){
final _that = this;
switch (_that) {
case _CouncilDecisionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouncilDecisionModel value)?  $default,){
final _that = this;
switch (_that) {
case _CouncilDecisionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  FinalResult result,  String justification, @UtcDateTimeConverter()  DateTime decidedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouncilDecisionModel() when $default != null:
return $default(_that.studentId,_that.result,_that.justification,_that.decidedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  FinalResult result,  String justification, @UtcDateTimeConverter()  DateTime decidedAt)  $default,) {final _that = this;
switch (_that) {
case _CouncilDecisionModel():
return $default(_that.studentId,_that.result,_that.justification,_that.decidedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  FinalResult result,  String justification, @UtcDateTimeConverter()  DateTime decidedAt)?  $default,) {final _that = this;
switch (_that) {
case _CouncilDecisionModel() when $default != null:
return $default(_that.studentId,_that.result,_that.justification,_that.decidedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CouncilDecisionModel implements CouncilDecisionModel {
  const _CouncilDecisionModel({required this.studentId, required this.result, required this.justification, @UtcDateTimeConverter() required this.decidedAt});
  factory _CouncilDecisionModel.fromJson(Map<String, dynamic> json) => _$CouncilDecisionModelFromJson(json);

@override final  String studentId;
@override final  FinalResult result;
@override final  String justification;
@override@UtcDateTimeConverter() final  DateTime decidedAt;

/// Create a copy of CouncilDecisionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouncilDecisionModelCopyWith<_CouncilDecisionModel> get copyWith => __$CouncilDecisionModelCopyWithImpl<_CouncilDecisionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouncilDecisionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouncilDecisionModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.result, result) || other.result == result)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,result,justification,decidedAt);

@override
String toString() {
  return 'CouncilDecisionModel(studentId: $studentId, result: $result, justification: $justification, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class _$CouncilDecisionModelCopyWith<$Res> implements $CouncilDecisionModelCopyWith<$Res> {
  factory _$CouncilDecisionModelCopyWith(_CouncilDecisionModel value, $Res Function(_CouncilDecisionModel) _then) = __$CouncilDecisionModelCopyWithImpl;
@override @useResult
$Res call({
 String studentId, FinalResult result, String justification,@UtcDateTimeConverter() DateTime decidedAt
});




}
/// @nodoc
class __$CouncilDecisionModelCopyWithImpl<$Res>
    implements _$CouncilDecisionModelCopyWith<$Res> {
  __$CouncilDecisionModelCopyWithImpl(this._self, this._then);

  final _CouncilDecisionModel _self;
  final $Res Function(_CouncilDecisionModel) _then;

/// Create a copy of CouncilDecisionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? result = null,Object? justification = null,Object? decidedAt = null,}) {
  return _then(_CouncilDecisionModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as FinalResult,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,decidedAt: null == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CouncilModel {

 String get classroomId; String get yearId; List<CouncilDecisionModel> get decisions;@UtcDateTimeConverter() DateTime? get approvedAt;/// `alunoId → resultado` no momento da aprovação.
 Map<String, FinalResult> get results;
/// Create a copy of CouncilModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouncilModelCopyWith<CouncilModel> get copyWith => _$CouncilModelCopyWithImpl<CouncilModel>(this as CouncilModel, _$identity);

  /// Serializes this CouncilModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouncilModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.yearId, yearId) || other.yearId == yearId)&&const DeepCollectionEquality().equals(other.decisions, decisions)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,yearId,const DeepCollectionEquality().hash(decisions),approvedAt,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'CouncilModel(classroomId: $classroomId, yearId: $yearId, decisions: $decisions, approvedAt: $approvedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class $CouncilModelCopyWith<$Res>  {
  factory $CouncilModelCopyWith(CouncilModel value, $Res Function(CouncilModel) _then) = _$CouncilModelCopyWithImpl;
@useResult
$Res call({
 String classroomId, String yearId, List<CouncilDecisionModel> decisions,@UtcDateTimeConverter() DateTime? approvedAt, Map<String, FinalResult> results
});




}
/// @nodoc
class _$CouncilModelCopyWithImpl<$Res>
    implements $CouncilModelCopyWith<$Res> {
  _$CouncilModelCopyWithImpl(this._self, this._then);

  final CouncilModel _self;
  final $Res Function(CouncilModel) _then;

/// Create a copy of CouncilModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroomId = null,Object? yearId = null,Object? decisions = null,Object? approvedAt = freezed,Object? results = null,}) {
  return _then(CouncilModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,yearId: null == yearId ? _self.yearId : yearId // ignore: cast_nullable_to_non_nullable
as String,decisions: null == decisions ? _self.decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<CouncilDecisionModel>,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as Map<String, FinalResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [CouncilModel].
extension CouncilModelPatterns on CouncilModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouncilModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouncilModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouncilModel value)  $default,){
final _that = this;
switch (_that) {
case _CouncilModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouncilModel value)?  $default,){
final _that = this;
switch (_that) {
case _CouncilModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroomId,  String yearId,  List<CouncilDecisionModel> decisions, @UtcDateTimeConverter()  DateTime? approvedAt,  Map<String, FinalResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouncilModel() when $default != null:
return $default(_that.classroomId,_that.yearId,_that.decisions,_that.approvedAt,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroomId,  String yearId,  List<CouncilDecisionModel> decisions, @UtcDateTimeConverter()  DateTime? approvedAt,  Map<String, FinalResult> results)  $default,) {final _that = this;
switch (_that) {
case _CouncilModel():
return $default(_that.classroomId,_that.yearId,_that.decisions,_that.approvedAt,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroomId,  String yearId,  List<CouncilDecisionModel> decisions, @UtcDateTimeConverter()  DateTime? approvedAt,  Map<String, FinalResult> results)?  $default,) {final _that = this;
switch (_that) {
case _CouncilModel() when $default != null:
return $default(_that.classroomId,_that.yearId,_that.decisions,_that.approvedAt,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CouncilModel implements CouncilModel {
  const _CouncilModel({required this.classroomId, required this.yearId,  List<CouncilDecisionModel> decisions = const <CouncilDecisionModel>[], @UtcDateTimeConverter() this.approvedAt,  Map<String, FinalResult> results = const <String, FinalResult>{}}): _decisions = decisions,_results = results;
  factory _CouncilModel.fromJson(Map<String, dynamic> json) => _$CouncilModelFromJson(json);

@override final  String classroomId;
@override final  String yearId;
 final  List<CouncilDecisionModel> _decisions;
@override@JsonKey() List<CouncilDecisionModel> get decisions {
  if (_decisions is EqualUnmodifiableListView) return _decisions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_decisions);
}

@override@UtcDateTimeConverter() final  DateTime? approvedAt;
/// `alunoId → resultado` no momento da aprovação.
 final  Map<String, FinalResult> _results;
/// `alunoId → resultado` no momento da aprovação.
@override@JsonKey() Map<String, FinalResult> get results {
  if (_results is EqualUnmodifiableMapView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_results);
}


/// Create a copy of CouncilModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouncilModelCopyWith<_CouncilModel> get copyWith => __$CouncilModelCopyWithImpl<_CouncilModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouncilModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouncilModel&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.yearId, yearId) || other.yearId == yearId)&&const DeepCollectionEquality().equals(other._decisions, _decisions)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,yearId,const DeepCollectionEquality().hash(_decisions),approvedAt,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'CouncilModel(classroomId: $classroomId, yearId: $yearId, decisions: $decisions, approvedAt: $approvedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class _$CouncilModelCopyWith<$Res> implements $CouncilModelCopyWith<$Res> {
  factory _$CouncilModelCopyWith(_CouncilModel value, $Res Function(_CouncilModel) _then) = __$CouncilModelCopyWithImpl;
@override @useResult
$Res call({
 String classroomId, String yearId, List<CouncilDecisionModel> decisions,@UtcDateTimeConverter() DateTime? approvedAt, Map<String, FinalResult> results
});




}
/// @nodoc
class __$CouncilModelCopyWithImpl<$Res>
    implements _$CouncilModelCopyWith<$Res> {
  __$CouncilModelCopyWithImpl(this._self, this._then);

  final _CouncilModel _self;
  final $Res Function(_CouncilModel) _then;

/// Create a copy of CouncilModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroomId = null,Object? yearId = null,Object? decisions = null,Object? approvedAt = freezed,Object? results = null,}) {
  return _then(_CouncilModel(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,yearId: null == yearId ? _self.yearId : yearId // ignore: cast_nullable_to_non_nullable
as String,decisions: null == decisions ? _self._decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<CouncilDecisionModel>,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as Map<String, FinalResult>,
  ));
}


}

// dart format on
