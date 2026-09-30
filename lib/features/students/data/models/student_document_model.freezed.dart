// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentDocumentModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; StudentDocumentType get type; String get fileName; String? get fileUrl;@DateOnlyConverter() DateTime? get expiresOn; bool get verified;/// Id do utilizador que verificou o documento.
 String? get verifiedBy;@UtcDateTimeConverter() DateTime? get verifiedAt;
/// Create a copy of StudentDocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentDocumentModelCopyWith<StudentDocumentModel> get copyWith => _$StudentDocumentModelCopyWithImpl<StudentDocumentModel>(this as StudentDocumentModel, _$identity);

  /// Serializes this StudentDocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,type,fileName,fileUrl,expiresOn,verified,verifiedBy,verifiedAt);

@override
String toString() {
  return 'StudentDocumentModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, type: $type, fileName: $fileName, fileUrl: $fileUrl, expiresOn: $expiresOn, verified: $verified, verifiedBy: $verifiedBy, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class $StudentDocumentModelCopyWith<$Res>  {
  factory $StudentDocumentModelCopyWith(StudentDocumentModel value, $Res Function(StudentDocumentModel) _then) = _$StudentDocumentModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, StudentDocumentType type, String fileName, String? fileUrl,@DateOnlyConverter() DateTime? expiresOn, bool verified, String? verifiedBy,@UtcDateTimeConverter() DateTime? verifiedAt
});




}
/// @nodoc
class _$StudentDocumentModelCopyWithImpl<$Res>
    implements $StudentDocumentModelCopyWith<$Res> {
  _$StudentDocumentModelCopyWithImpl(this._self, this._then);

  final StudentDocumentModel _self;
  final $Res Function(StudentDocumentModel) _then;

/// Create a copy of StudentDocumentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? type = null,Object? fileName = null,Object? fileUrl = freezed,Object? expiresOn = freezed,Object? verified = null,Object? verifiedBy = freezed,Object? verifiedAt = freezed,}) {
  return _then(StudentDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StudentDocumentType,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentDocumentModel].
extension StudentDocumentModelPatterns on StudentDocumentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentDocumentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentDocumentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentDocumentModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentDocumentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentDocumentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentDocumentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  StudentDocumentType type,  String fileName,  String? fileUrl, @DateOnlyConverter()  DateTime? expiresOn,  bool verified,  String? verifiedBy, @UtcDateTimeConverter()  DateTime? verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentDocumentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.fileName,_that.fileUrl,_that.expiresOn,_that.verified,_that.verifiedBy,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  StudentDocumentType type,  String fileName,  String? fileUrl, @DateOnlyConverter()  DateTime? expiresOn,  bool verified,  String? verifiedBy, @UtcDateTimeConverter()  DateTime? verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _StudentDocumentModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.fileName,_that.fileUrl,_that.expiresOn,_that.verified,_that.verifiedBy,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  StudentDocumentType type,  String fileName,  String? fileUrl, @DateOnlyConverter()  DateTime? expiresOn,  bool verified,  String? verifiedBy, @UtcDateTimeConverter()  DateTime? verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudentDocumentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.type,_that.fileName,_that.fileUrl,_that.expiresOn,_that.verified,_that.verifiedBy,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentDocumentModel implements StudentDocumentModel {
  const _StudentDocumentModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.type, required this.fileName, this.fileUrl, @DateOnlyConverter() this.expiresOn, this.verified = false, this.verifiedBy, @UtcDateTimeConverter() this.verifiedAt});
  factory _StudentDocumentModel.fromJson(Map<String, dynamic> json) => _$StudentDocumentModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  StudentDocumentType type;
@override final  String fileName;
@override final  String? fileUrl;
@override@DateOnlyConverter() final  DateTime? expiresOn;
@override@JsonKey() final  bool verified;
/// Id do utilizador que verificou o documento.
@override final  String? verifiedBy;
@override@UtcDateTimeConverter() final  DateTime? verifiedAt;

/// Create a copy of StudentDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentDocumentModelCopyWith<_StudentDocumentModel> get copyWith => __$StudentDocumentModelCopyWithImpl<_StudentDocumentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentDocumentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,type,fileName,fileUrl,expiresOn,verified,verifiedBy,verifiedAt);

@override
String toString() {
  return 'StudentDocumentModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, type: $type, fileName: $fileName, fileUrl: $fileUrl, expiresOn: $expiresOn, verified: $verified, verifiedBy: $verifiedBy, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$StudentDocumentModelCopyWith<$Res> implements $StudentDocumentModelCopyWith<$Res> {
  factory _$StudentDocumentModelCopyWith(_StudentDocumentModel value, $Res Function(_StudentDocumentModel) _then) = __$StudentDocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, StudentDocumentType type, String fileName, String? fileUrl,@DateOnlyConverter() DateTime? expiresOn, bool verified, String? verifiedBy,@UtcDateTimeConverter() DateTime? verifiedAt
});




}
/// @nodoc
class __$StudentDocumentModelCopyWithImpl<$Res>
    implements _$StudentDocumentModelCopyWith<$Res> {
  __$StudentDocumentModelCopyWithImpl(this._self, this._then);

  final _StudentDocumentModel _self;
  final $Res Function(_StudentDocumentModel) _then;

/// Create a copy of StudentDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? type = null,Object? fileName = null,Object? fileUrl = freezed,Object? expiresOn = freezed,Object? verified = null,Object? verifiedBy = freezed,Object? verifiedAt = freezed,}) {
  return _then(_StudentDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StudentDocumentType,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
