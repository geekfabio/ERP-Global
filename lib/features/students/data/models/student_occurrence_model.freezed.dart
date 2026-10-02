// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_occurrence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentOccurrenceModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; OccurrenceType get type;@DateOnlyConverter() DateTime get occurredOn; String get title; String? get description;/// Id do utilizador que registou a ocorrência.
 String? get reportedBy;
/// Create a copy of StudentOccurrenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentOccurrenceModelCopyWith<StudentOccurrenceModel> get copyWith => _$StudentOccurrenceModelCopyWithImpl<StudentOccurrenceModel>(this as StudentOccurrenceModel, _$identity);

  /// Serializes this StudentOccurrenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentOccurrenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,type,occurredOn,title,description,reportedBy);

@override
String toString() {
  return 'StudentOccurrenceModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, type: $type, occurredOn: $occurredOn, title: $title, description: $description, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class $StudentOccurrenceModelCopyWith<$Res>  {
  factory $StudentOccurrenceModelCopyWith(StudentOccurrenceModel value, $Res Function(StudentOccurrenceModel) _then) = _$StudentOccurrenceModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, OccurrenceType type,@DateOnlyConverter() DateTime occurredOn, String title, String? description, String? reportedBy
});




}
/// @nodoc
class _$StudentOccurrenceModelCopyWithImpl<$Res>
    implements $StudentOccurrenceModelCopyWith<$Res> {
  _$StudentOccurrenceModelCopyWithImpl(this._self, this._then);

  final StudentOccurrenceModel _self;
  final $Res Function(StudentOccurrenceModel) _then;

/// Create a copy of StudentOccurrenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? type = null,Object? occurredOn = null,Object? title = null,Object? description = freezed,Object? reportedBy = freezed,}) {
  return _then(StudentOccurrenceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OccurrenceType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentOccurrenceModel].
extension StudentOccurrenceModelPatterns on StudentOccurrenceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentOccurrenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentOccurrenceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentOccurrenceModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentOccurrenceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentOccurrenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentOccurrenceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  OccurrenceType type, @DateOnlyConverter()  DateTime occurredOn,  String title,  String? description,  String? reportedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentOccurrenceModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.occurredOn,_that.title,_that.description,_that.reportedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  OccurrenceType type, @DateOnlyConverter()  DateTime occurredOn,  String title,  String? description,  String? reportedBy)  $default,) {final _that = this;
switch (_that) {
case _StudentOccurrenceModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.occurredOn,_that.title,_that.description,_that.reportedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  OccurrenceType type, @DateOnlyConverter()  DateTime occurredOn,  String title,  String? description,  String? reportedBy)?  $default,) {final _that = this;
switch (_that) {
case _StudentOccurrenceModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.occurredOn,_that.title,_that.description,_that.reportedBy);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentOccurrenceModel implements StudentOccurrenceModel {
  const _StudentOccurrenceModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.type, @DateOnlyConverter() required this.occurredOn, required this.title, this.description, this.reportedBy});
  factory _StudentOccurrenceModel.fromJson(Map<String, dynamic> json) => _$StudentOccurrenceModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  OccurrenceType type;
@override@DateOnlyConverter() final  DateTime occurredOn;
@override final  String title;
@override final  String? description;
/// Id do utilizador que registou a ocorrência.
@override final  String? reportedBy;

/// Create a copy of StudentOccurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentOccurrenceModelCopyWith<_StudentOccurrenceModel> get copyWith => __$StudentOccurrenceModelCopyWithImpl<_StudentOccurrenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentOccurrenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentOccurrenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,type,occurredOn,title,description,reportedBy);

@override
String toString() {
  return 'StudentOccurrenceModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, type: $type, occurredOn: $occurredOn, title: $title, description: $description, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class _$StudentOccurrenceModelCopyWith<$Res> implements $StudentOccurrenceModelCopyWith<$Res> {
  factory _$StudentOccurrenceModelCopyWith(_StudentOccurrenceModel value, $Res Function(_StudentOccurrenceModel) _then) = __$StudentOccurrenceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, OccurrenceType type,@DateOnlyConverter() DateTime occurredOn, String title, String? description, String? reportedBy
});




}
/// @nodoc
class __$StudentOccurrenceModelCopyWithImpl<$Res>
    implements _$StudentOccurrenceModelCopyWith<$Res> {
  __$StudentOccurrenceModelCopyWithImpl(this._self, this._then);

  final _StudentOccurrenceModel _self;
  final $Res Function(_StudentOccurrenceModel) _then;

/// Create a copy of StudentOccurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? type = null,Object? occurredOn = null,Object? title = null,Object? description = freezed,Object? reportedBy = freezed,}) {
  return _then(_StudentOccurrenceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OccurrenceType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
