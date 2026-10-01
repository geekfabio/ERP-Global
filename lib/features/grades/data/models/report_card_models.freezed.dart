// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_card_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportCardStateModel {

 String get studentId; String get termId;/// Observações do director de turma (texto livre).
 String get remarks;@UtcDateTimeConverter() DateTime? get sentAt; List<String> get sentToGuardianIds;
/// Create a copy of ReportCardStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCardStateModelCopyWith<ReportCardStateModel> get copyWith => _$ReportCardStateModelCopyWithImpl<ReportCardStateModel>(this as ReportCardStateModel, _$identity);

  /// Serializes this ReportCardStateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCardStateModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&const DeepCollectionEquality().equals(other.sentToGuardianIds, sentToGuardianIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,termId,remarks,sentAt,const DeepCollectionEquality().hash(sentToGuardianIds));

@override
String toString() {
  return 'ReportCardStateModel(studentId: $studentId, termId: $termId, remarks: $remarks, sentAt: $sentAt, sentToGuardianIds: $sentToGuardianIds)';
}


}

/// @nodoc
abstract mixin class $ReportCardStateModelCopyWith<$Res>  {
  factory $ReportCardStateModelCopyWith(ReportCardStateModel value, $Res Function(ReportCardStateModel) _then) = _$ReportCardStateModelCopyWithImpl;
@useResult
$Res call({
 String studentId, String termId, String remarks,@UtcDateTimeConverter() DateTime? sentAt, List<String> sentToGuardianIds
});




}
/// @nodoc
class _$ReportCardStateModelCopyWithImpl<$Res>
    implements $ReportCardStateModelCopyWith<$Res> {
  _$ReportCardStateModelCopyWithImpl(this._self, this._then);

  final ReportCardStateModel _self;
  final $Res Function(ReportCardStateModel) _then;

/// Create a copy of ReportCardStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? termId = null,Object? remarks = null,Object? sentAt = freezed,Object? sentToGuardianIds = null,}) {
  return _then(ReportCardStateModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sentToGuardianIds: null == sentToGuardianIds ? _self.sentToGuardianIds : sentToGuardianIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportCardStateModel].
extension ReportCardStateModelPatterns on ReportCardStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportCardStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportCardStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportCardStateModel value)  $default,){
final _that = this;
switch (_that) {
case _ReportCardStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportCardStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReportCardStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String termId,  String remarks, @UtcDateTimeConverter()  DateTime? sentAt,  List<String> sentToGuardianIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportCardStateModel() when $default != null:
return $default(_that.studentId,_that.termId,_that.remarks,_that.sentAt,_that.sentToGuardianIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String termId,  String remarks, @UtcDateTimeConverter()  DateTime? sentAt,  List<String> sentToGuardianIds)  $default,) {final _that = this;
switch (_that) {
case _ReportCardStateModel():
return $default(_that.studentId,_that.termId,_that.remarks,_that.sentAt,_that.sentToGuardianIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String termId,  String remarks, @UtcDateTimeConverter()  DateTime? sentAt,  List<String> sentToGuardianIds)?  $default,) {final _that = this;
switch (_that) {
case _ReportCardStateModel() when $default != null:
return $default(_that.studentId,_that.termId,_that.remarks,_that.sentAt,_that.sentToGuardianIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportCardStateModel implements ReportCardStateModel {
  const _ReportCardStateModel({required this.studentId, required this.termId, this.remarks = '', @UtcDateTimeConverter() this.sentAt,  List<String> sentToGuardianIds = const <String>[]}): _sentToGuardianIds = sentToGuardianIds;
  factory _ReportCardStateModel.fromJson(Map<String, dynamic> json) => _$ReportCardStateModelFromJson(json);

@override final  String studentId;
@override final  String termId;
/// Observações do director de turma (texto livre).
@override@JsonKey() final  String remarks;
@override@UtcDateTimeConverter() final  DateTime? sentAt;
 final  List<String> _sentToGuardianIds;
@override@JsonKey() List<String> get sentToGuardianIds {
  if (_sentToGuardianIds is EqualUnmodifiableListView) return _sentToGuardianIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sentToGuardianIds);
}


/// Create a copy of ReportCardStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCardStateModelCopyWith<_ReportCardStateModel> get copyWith => __$ReportCardStateModelCopyWithImpl<_ReportCardStateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportCardStateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportCardStateModel&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&const DeepCollectionEquality().equals(other._sentToGuardianIds, _sentToGuardianIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,termId,remarks,sentAt,const DeepCollectionEquality().hash(_sentToGuardianIds));

@override
String toString() {
  return 'ReportCardStateModel(studentId: $studentId, termId: $termId, remarks: $remarks, sentAt: $sentAt, sentToGuardianIds: $sentToGuardianIds)';
}


}

/// @nodoc
abstract mixin class _$ReportCardStateModelCopyWith<$Res> implements $ReportCardStateModelCopyWith<$Res> {
  factory _$ReportCardStateModelCopyWith(_ReportCardStateModel value, $Res Function(_ReportCardStateModel) _then) = __$ReportCardStateModelCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String termId, String remarks,@UtcDateTimeConverter() DateTime? sentAt, List<String> sentToGuardianIds
});




}
/// @nodoc
class __$ReportCardStateModelCopyWithImpl<$Res>
    implements _$ReportCardStateModelCopyWith<$Res> {
  __$ReportCardStateModelCopyWithImpl(this._self, this._then);

  final _ReportCardStateModel _self;
  final $Res Function(_ReportCardStateModel) _then;

/// Create a copy of ReportCardStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? termId = null,Object? remarks = null,Object? sentAt = freezed,Object? sentToGuardianIds = null,}) {
  return _then(_ReportCardStateModel(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,termId: null == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sentToGuardianIds: null == sentToGuardianIds ? _self._sentToGuardianIds : sentToGuardianIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
