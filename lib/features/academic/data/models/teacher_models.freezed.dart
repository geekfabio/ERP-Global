// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherModel {

 String get id;/// Número de funcionário; atribuído pelo servidor na criação.
 String get employeeNumber; String get fullName; String get email; String get phone;/// Área de formação (ex.: `Licenciatura em Matemática`).
 String get specialty;/// Disciplinas que lecciona.
 List<String> get subjectIds;/// Turmas atribuídas (Professor ↔ Turma).
 List<String> get classroomIds; bool get isActive;
/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherModelCopyWith<TeacherModel> get copyWith => _$TeacherModelCopyWithImpl<TeacherModel>(this as TeacherModel, _$identity);

  /// Serializes this TeacherModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.specialty, specialty) || other.specialty == specialty)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds)&&const DeepCollectionEquality().equals(other.classroomIds, classroomIds)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeNumber,fullName,email,phone,specialty,const DeepCollectionEquality().hash(subjectIds),const DeepCollectionEquality().hash(classroomIds),isActive);

@override
String toString() {
  return 'TeacherModel(id: $id, employeeNumber: $employeeNumber, fullName: $fullName, email: $email, phone: $phone, specialty: $specialty, subjectIds: $subjectIds, classroomIds: $classroomIds, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $TeacherModelCopyWith<$Res>  {
  factory $TeacherModelCopyWith(TeacherModel value, $Res Function(TeacherModel) _then) = _$TeacherModelCopyWithImpl;
@useResult
$Res call({
 String id, String employeeNumber, String fullName, String email, String phone, String specialty, List<String> subjectIds, List<String> classroomIds, bool isActive
});




}
/// @nodoc
class _$TeacherModelCopyWithImpl<$Res>
    implements $TeacherModelCopyWith<$Res> {
  _$TeacherModelCopyWithImpl(this._self, this._then);

  final TeacherModel _self;
  final $Res Function(TeacherModel) _then;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeNumber = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? specialty = null,Object? subjectIds = null,Object? classroomIds = null,Object? isActive = null,}) {
  return _then(TeacherModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,subjectIds: null == subjectIds ? _self.subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,classroomIds: null == classroomIds ? _self.classroomIds : classroomIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherModel].
extension TeacherModelPatterns on TeacherModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String specialty,  List<String> subjectIds,  List<String> classroomIds,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.specialty,_that.subjectIds,_that.classroomIds,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String specialty,  List<String> subjectIds,  List<String> classroomIds,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _TeacherModel():
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.specialty,_that.subjectIds,_that.classroomIds,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String specialty,  List<String> subjectIds,  List<String> classroomIds,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.specialty,_that.subjectIds,_that.classroomIds,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherModel implements TeacherModel {
  const _TeacherModel({required this.id, this.employeeNumber = '', required this.fullName, required this.email, this.phone = '', this.specialty = '',  List<String> subjectIds = const <String>[],  List<String> classroomIds = const <String>[], this.isActive = true}): _subjectIds = subjectIds,_classroomIds = classroomIds;
  factory _TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);

@override final  String id;
/// Número de funcionário; atribuído pelo servidor na criação.
@override@JsonKey() final  String employeeNumber;
@override final  String fullName;
@override final  String email;
@override@JsonKey() final  String phone;
/// Área de formação (ex.: `Licenciatura em Matemática`).
@override@JsonKey() final  String specialty;
/// Disciplinas que lecciona.
 final  List<String> _subjectIds;
/// Disciplinas que lecciona.
@override@JsonKey() List<String> get subjectIds {
  if (_subjectIds is EqualUnmodifiableListView) return _subjectIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjectIds);
}

/// Turmas atribuídas (Professor ↔ Turma).
 final  List<String> _classroomIds;
/// Turmas atribuídas (Professor ↔ Turma).
@override@JsonKey() List<String> get classroomIds {
  if (_classroomIds is EqualUnmodifiableListView) return _classroomIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classroomIds);
}

@override@JsonKey() final  bool isActive;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherModelCopyWith<_TeacherModel> get copyWith => __$TeacherModelCopyWithImpl<_TeacherModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.specialty, specialty) || other.specialty == specialty)&&const DeepCollectionEquality().equals(other._subjectIds, _subjectIds)&&const DeepCollectionEquality().equals(other._classroomIds, _classroomIds)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeNumber,fullName,email,phone,specialty,const DeepCollectionEquality().hash(_subjectIds),const DeepCollectionEquality().hash(_classroomIds),isActive);

@override
String toString() {
  return 'TeacherModel(id: $id, employeeNumber: $employeeNumber, fullName: $fullName, email: $email, phone: $phone, specialty: $specialty, subjectIds: $subjectIds, classroomIds: $classroomIds, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TeacherModelCopyWith<$Res> implements $TeacherModelCopyWith<$Res> {
  factory _$TeacherModelCopyWith(_TeacherModel value, $Res Function(_TeacherModel) _then) = __$TeacherModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeNumber, String fullName, String email, String phone, String specialty, List<String> subjectIds, List<String> classroomIds, bool isActive
});




}
/// @nodoc
class __$TeacherModelCopyWithImpl<$Res>
    implements _$TeacherModelCopyWith<$Res> {
  __$TeacherModelCopyWithImpl(this._self, this._then);

  final _TeacherModel _self;
  final $Res Function(_TeacherModel) _then;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeNumber = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? specialty = null,Object? subjectIds = null,Object? classroomIds = null,Object? isActive = null,}) {
  return _then(_TeacherModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,subjectIds: null == subjectIds ? _self._subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,classroomIds: null == classroomIds ? _self._classroomIds : classroomIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
