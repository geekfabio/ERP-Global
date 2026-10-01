// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_document_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentTemplateModel {

 String get id; DocumentKind get kind; String get name; String get body;
/// Create a copy of DocumentTemplateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentTemplateModelCopyWith<DocumentTemplateModel> get copyWith => _$DocumentTemplateModelCopyWithImpl<DocumentTemplateModel>(this as DocumentTemplateModel, _$identity);

  /// Serializes this DocumentTemplateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentTemplateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,body);

@override
String toString() {
  return 'DocumentTemplateModel(id: $id, kind: $kind, name: $name, body: $body)';
}


}

/// @nodoc
abstract mixin class $DocumentTemplateModelCopyWith<$Res>  {
  factory $DocumentTemplateModelCopyWith(DocumentTemplateModel value, $Res Function(DocumentTemplateModel) _then) = _$DocumentTemplateModelCopyWithImpl;
@useResult
$Res call({
 String id, DocumentKind kind, String name, String body
});




}
/// @nodoc
class _$DocumentTemplateModelCopyWithImpl<$Res>
    implements $DocumentTemplateModelCopyWith<$Res> {
  _$DocumentTemplateModelCopyWithImpl(this._self, this._then);

  final DocumentTemplateModel _self;
  final $Res Function(DocumentTemplateModel) _then;

/// Create a copy of DocumentTemplateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? body = null,}) {
  return _then(DocumentTemplateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentTemplateModel].
extension DocumentTemplateModelPatterns on DocumentTemplateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentTemplateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentTemplateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentTemplateModel value)  $default,){
final _that = this;
switch (_that) {
case _DocumentTemplateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentTemplateModel value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentTemplateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DocumentKind kind,  String name,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentTemplateModel() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DocumentKind kind,  String name,  String body)  $default,) {final _that = this;
switch (_that) {
case _DocumentTemplateModel():
return $default(_that.id,_that.kind,_that.name,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DocumentKind kind,  String name,  String body)?  $default,) {final _that = this;
switch (_that) {
case _DocumentTemplateModel() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentTemplateModel implements DocumentTemplateModel {
  const _DocumentTemplateModel({required this.id, required this.kind, required this.name, required this.body});
  factory _DocumentTemplateModel.fromJson(Map<String, dynamic> json) => _$DocumentTemplateModelFromJson(json);

@override final  String id;
@override final  DocumentKind kind;
@override final  String name;
@override final  String body;

/// Create a copy of DocumentTemplateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentTemplateModelCopyWith<_DocumentTemplateModel> get copyWith => __$DocumentTemplateModelCopyWithImpl<_DocumentTemplateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentTemplateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentTemplateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,body);

@override
String toString() {
  return 'DocumentTemplateModel(id: $id, kind: $kind, name: $name, body: $body)';
}


}

/// @nodoc
abstract mixin class _$DocumentTemplateModelCopyWith<$Res> implements $DocumentTemplateModelCopyWith<$Res> {
  factory _$DocumentTemplateModelCopyWith(_DocumentTemplateModel value, $Res Function(_DocumentTemplateModel) _then) = __$DocumentTemplateModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DocumentKind kind, String name, String body
});




}
/// @nodoc
class __$DocumentTemplateModelCopyWithImpl<$Res>
    implements _$DocumentTemplateModelCopyWith<$Res> {
  __$DocumentTemplateModelCopyWithImpl(this._self, this._then);

  final _DocumentTemplateModel _self;
  final $Res Function(_DocumentTemplateModel) _then;

/// Create a copy of DocumentTemplateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? body = null,}) {
  return _then(_DocumentTemplateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AcademicDocumentModel {

 String get id; DocumentKind get kind; DocumentStatus get status; String get studentId; String get studentName; String get processNumber; String get purpose; Map<String, String> get variables;@UtcDateTimeConverter() DateTime get requestedAt; String? get number; String? get content;@UtcDateTimeConverter() DateTime? get issuedAt;@UtcDateTimeConverter() DateTime? get cancelledAt;
/// Create a copy of AcademicDocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicDocumentModelCopyWith<AcademicDocumentModel> get copyWith => _$AcademicDocumentModelCopyWithImpl<AcademicDocumentModel>(this as AcademicDocumentModel, _$identity);

  /// Serializes this AcademicDocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.processNumber, processNumber) || other.processNumber == processNumber)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.number, number) || other.number == number)&&(identical(other.content, content) || other.content == content)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,status,studentId,studentName,processNumber,purpose,const DeepCollectionEquality().hash(variables),requestedAt,number,content,issuedAt,cancelledAt);

@override
String toString() {
  return 'AcademicDocumentModel(id: $id, kind: $kind, status: $status, studentId: $studentId, studentName: $studentName, processNumber: $processNumber, purpose: $purpose, variables: $variables, requestedAt: $requestedAt, number: $number, content: $content, issuedAt: $issuedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class $AcademicDocumentModelCopyWith<$Res>  {
  factory $AcademicDocumentModelCopyWith(AcademicDocumentModel value, $Res Function(AcademicDocumentModel) _then) = _$AcademicDocumentModelCopyWithImpl;
@useResult
$Res call({
 String id, DocumentKind kind, DocumentStatus status, String studentId, String studentName, String processNumber, String purpose, Map<String, String> variables,@UtcDateTimeConverter() DateTime requestedAt, String? number, String? content,@UtcDateTimeConverter() DateTime? issuedAt,@UtcDateTimeConverter() DateTime? cancelledAt
});




}
/// @nodoc
class _$AcademicDocumentModelCopyWithImpl<$Res>
    implements $AcademicDocumentModelCopyWith<$Res> {
  _$AcademicDocumentModelCopyWithImpl(this._self, this._then);

  final AcademicDocumentModel _self;
  final $Res Function(AcademicDocumentModel) _then;

/// Create a copy of AcademicDocumentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? status = null,Object? studentId = null,Object? studentName = null,Object? processNumber = null,Object? purpose = null,Object? variables = null,Object? requestedAt = null,Object? number = freezed,Object? content = freezed,Object? issuedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(AcademicDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,processNumber: null == processNumber ? _self.processNumber : processNumber // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicDocumentModel].
extension AcademicDocumentModelPatterns on AcademicDocumentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicDocumentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicDocumentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicDocumentModel value)  $default,){
final _that = this;
switch (_that) {
case _AcademicDocumentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicDocumentModel value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicDocumentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DocumentKind kind,  DocumentStatus status,  String studentId,  String studentName,  String processNumber,  String purpose,  Map<String, String> variables, @UtcDateTimeConverter()  DateTime requestedAt,  String? number,  String? content, @UtcDateTimeConverter()  DateTime? issuedAt, @UtcDateTimeConverter()  DateTime? cancelledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicDocumentModel() when $default != null:
return $default(_that.id,_that.kind,_that.status,_that.studentId,_that.studentName,_that.processNumber,_that.purpose,_that.variables,_that.requestedAt,_that.number,_that.content,_that.issuedAt,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DocumentKind kind,  DocumentStatus status,  String studentId,  String studentName,  String processNumber,  String purpose,  Map<String, String> variables, @UtcDateTimeConverter()  DateTime requestedAt,  String? number,  String? content, @UtcDateTimeConverter()  DateTime? issuedAt, @UtcDateTimeConverter()  DateTime? cancelledAt)  $default,) {final _that = this;
switch (_that) {
case _AcademicDocumentModel():
return $default(_that.id,_that.kind,_that.status,_that.studentId,_that.studentName,_that.processNumber,_that.purpose,_that.variables,_that.requestedAt,_that.number,_that.content,_that.issuedAt,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DocumentKind kind,  DocumentStatus status,  String studentId,  String studentName,  String processNumber,  String purpose,  Map<String, String> variables, @UtcDateTimeConverter()  DateTime requestedAt,  String? number,  String? content, @UtcDateTimeConverter()  DateTime? issuedAt, @UtcDateTimeConverter()  DateTime? cancelledAt)?  $default,) {final _that = this;
switch (_that) {
case _AcademicDocumentModel() when $default != null:
return $default(_that.id,_that.kind,_that.status,_that.studentId,_that.studentName,_that.processNumber,_that.purpose,_that.variables,_that.requestedAt,_that.number,_that.content,_that.issuedAt,_that.cancelledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicDocumentModel implements AcademicDocumentModel {
  const _AcademicDocumentModel({required this.id, required this.kind, required this.status, required this.studentId, required this.studentName, required this.processNumber, this.purpose = '',  Map<String, String> variables = const <String, String>{}, @UtcDateTimeConverter() required this.requestedAt, this.number, this.content, @UtcDateTimeConverter() this.issuedAt, @UtcDateTimeConverter() this.cancelledAt}): _variables = variables;
  factory _AcademicDocumentModel.fromJson(Map<String, dynamic> json) => _$AcademicDocumentModelFromJson(json);

@override final  String id;
@override final  DocumentKind kind;
@override final  DocumentStatus status;
@override final  String studentId;
@override final  String studentName;
@override final  String processNumber;
@override@JsonKey() final  String purpose;
 final  Map<String, String> _variables;
@override@JsonKey() Map<String, String> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

@override@UtcDateTimeConverter() final  DateTime requestedAt;
@override final  String? number;
@override final  String? content;
@override@UtcDateTimeConverter() final  DateTime? issuedAt;
@override@UtcDateTimeConverter() final  DateTime? cancelledAt;

/// Create a copy of AcademicDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicDocumentModelCopyWith<_AcademicDocumentModel> get copyWith => __$AcademicDocumentModelCopyWithImpl<_AcademicDocumentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicDocumentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.processNumber, processNumber) || other.processNumber == processNumber)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.number, number) || other.number == number)&&(identical(other.content, content) || other.content == content)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,status,studentId,studentName,processNumber,purpose,const DeepCollectionEquality().hash(_variables),requestedAt,number,content,issuedAt,cancelledAt);

@override
String toString() {
  return 'AcademicDocumentModel(id: $id, kind: $kind, status: $status, studentId: $studentId, studentName: $studentName, processNumber: $processNumber, purpose: $purpose, variables: $variables, requestedAt: $requestedAt, number: $number, content: $content, issuedAt: $issuedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class _$AcademicDocumentModelCopyWith<$Res> implements $AcademicDocumentModelCopyWith<$Res> {
  factory _$AcademicDocumentModelCopyWith(_AcademicDocumentModel value, $Res Function(_AcademicDocumentModel) _then) = __$AcademicDocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DocumentKind kind, DocumentStatus status, String studentId, String studentName, String processNumber, String purpose, Map<String, String> variables,@UtcDateTimeConverter() DateTime requestedAt, String? number, String? content,@UtcDateTimeConverter() DateTime? issuedAt,@UtcDateTimeConverter() DateTime? cancelledAt
});




}
/// @nodoc
class __$AcademicDocumentModelCopyWithImpl<$Res>
    implements _$AcademicDocumentModelCopyWith<$Res> {
  __$AcademicDocumentModelCopyWithImpl(this._self, this._then);

  final _AcademicDocumentModel _self;
  final $Res Function(_AcademicDocumentModel) _then;

/// Create a copy of AcademicDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? status = null,Object? studentId = null,Object? studentName = null,Object? processNumber = null,Object? purpose = null,Object? variables = null,Object? requestedAt = null,Object? number = freezed,Object? content = freezed,Object? issuedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(_AcademicDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,processNumber: null == processNumber ? _self.processNumber : processNumber // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DocumentVerificationModel {

 String get number; DocumentKind get kind; DocumentStatus get status; String get studentName;@UtcDateTimeConverter() DateTime? get issuedAt;
/// Create a copy of DocumentVerificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentVerificationModelCopyWith<DocumentVerificationModel> get copyWith => _$DocumentVerificationModelCopyWithImpl<DocumentVerificationModel>(this as DocumentVerificationModel, _$identity);

  /// Serializes this DocumentVerificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentVerificationModel&&(identical(other.number, number) || other.number == number)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,kind,status,studentName,issuedAt);

@override
String toString() {
  return 'DocumentVerificationModel(number: $number, kind: $kind, status: $status, studentName: $studentName, issuedAt: $issuedAt)';
}


}

/// @nodoc
abstract mixin class $DocumentVerificationModelCopyWith<$Res>  {
  factory $DocumentVerificationModelCopyWith(DocumentVerificationModel value, $Res Function(DocumentVerificationModel) _then) = _$DocumentVerificationModelCopyWithImpl;
@useResult
$Res call({
 String number, DocumentKind kind, DocumentStatus status, String studentName,@UtcDateTimeConverter() DateTime? issuedAt
});




}
/// @nodoc
class _$DocumentVerificationModelCopyWithImpl<$Res>
    implements $DocumentVerificationModelCopyWith<$Res> {
  _$DocumentVerificationModelCopyWithImpl(this._self, this._then);

  final DocumentVerificationModel _self;
  final $Res Function(DocumentVerificationModel) _then;

/// Create a copy of DocumentVerificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? kind = null,Object? status = null,Object? studentName = null,Object? issuedAt = freezed,}) {
  return _then(DocumentVerificationModel(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentVerificationModel].
extension DocumentVerificationModelPatterns on DocumentVerificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentVerificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentVerificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentVerificationModel value)  $default,){
final _that = this;
switch (_that) {
case _DocumentVerificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentVerificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentVerificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  DocumentKind kind,  DocumentStatus status,  String studentName, @UtcDateTimeConverter()  DateTime? issuedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentVerificationModel() when $default != null:
return $default(_that.number,_that.kind,_that.status,_that.studentName,_that.issuedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  DocumentKind kind,  DocumentStatus status,  String studentName, @UtcDateTimeConverter()  DateTime? issuedAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentVerificationModel():
return $default(_that.number,_that.kind,_that.status,_that.studentName,_that.issuedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  DocumentKind kind,  DocumentStatus status,  String studentName, @UtcDateTimeConverter()  DateTime? issuedAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentVerificationModel() when $default != null:
return $default(_that.number,_that.kind,_that.status,_that.studentName,_that.issuedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentVerificationModel implements DocumentVerificationModel {
  const _DocumentVerificationModel({required this.number, required this.kind, required this.status, required this.studentName, @UtcDateTimeConverter() this.issuedAt});
  factory _DocumentVerificationModel.fromJson(Map<String, dynamic> json) => _$DocumentVerificationModelFromJson(json);

@override final  String number;
@override final  DocumentKind kind;
@override final  DocumentStatus status;
@override final  String studentName;
@override@UtcDateTimeConverter() final  DateTime? issuedAt;

/// Create a copy of DocumentVerificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentVerificationModelCopyWith<_DocumentVerificationModel> get copyWith => __$DocumentVerificationModelCopyWithImpl<_DocumentVerificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentVerificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentVerificationModel&&(identical(other.number, number) || other.number == number)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,kind,status,studentName,issuedAt);

@override
String toString() {
  return 'DocumentVerificationModel(number: $number, kind: $kind, status: $status, studentName: $studentName, issuedAt: $issuedAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentVerificationModelCopyWith<$Res> implements $DocumentVerificationModelCopyWith<$Res> {
  factory _$DocumentVerificationModelCopyWith(_DocumentVerificationModel value, $Res Function(_DocumentVerificationModel) _then) = __$DocumentVerificationModelCopyWithImpl;
@override @useResult
$Res call({
 String number, DocumentKind kind, DocumentStatus status, String studentName,@UtcDateTimeConverter() DateTime? issuedAt
});




}
/// @nodoc
class __$DocumentVerificationModelCopyWithImpl<$Res>
    implements _$DocumentVerificationModelCopyWith<$Res> {
  __$DocumentVerificationModelCopyWithImpl(this._self, this._then);

  final _DocumentVerificationModel _self;
  final $Res Function(_DocumentVerificationModel) _then;

/// Create a copy of DocumentVerificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? kind = null,Object? status = null,Object? studentName = null,Object? issuedAt = freezed,}) {
  return _then(_DocumentVerificationModel(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocumentKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
