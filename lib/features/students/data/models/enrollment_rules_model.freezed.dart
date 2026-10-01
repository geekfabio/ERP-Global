// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_rules_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrollmentRulesModel {

/// Idade mínima (anos completos à data da matrícula); não se aplica a
/// renovações. `0` desactiva.
 int get minAgeYears;/// Vagas por turma; `0` = sem limite.
 int get capacityPerClassroom;/// Só documentos verificados contam como entregues.
 bool get requireVerifiedDocuments;/// Documentos obrigatórios por tipo de matrícula (chave = valor JSON do
/// [EnrollmentType]: `new_enrollment`, `renewal`, `transfer`, `reentry`).
 Map<String, List<StudentDocumentType>> get requiredDocuments;
/// Create a copy of EnrollmentRulesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrollmentRulesModelCopyWith<EnrollmentRulesModel> get copyWith => _$EnrollmentRulesModelCopyWithImpl<EnrollmentRulesModel>(this as EnrollmentRulesModel, _$identity);

  /// Serializes this EnrollmentRulesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrollmentRulesModel&&(identical(other.minAgeYears, minAgeYears) || other.minAgeYears == minAgeYears)&&(identical(other.capacityPerClassroom, capacityPerClassroom) || other.capacityPerClassroom == capacityPerClassroom)&&(identical(other.requireVerifiedDocuments, requireVerifiedDocuments) || other.requireVerifiedDocuments == requireVerifiedDocuments)&&const DeepCollectionEquality().equals(other.requiredDocuments, requiredDocuments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minAgeYears,capacityPerClassroom,requireVerifiedDocuments,const DeepCollectionEquality().hash(requiredDocuments));

@override
String toString() {
  return 'EnrollmentRulesModel(minAgeYears: $minAgeYears, capacityPerClassroom: $capacityPerClassroom, requireVerifiedDocuments: $requireVerifiedDocuments, requiredDocuments: $requiredDocuments)';
}


}

/// @nodoc
abstract mixin class $EnrollmentRulesModelCopyWith<$Res>  {
  factory $EnrollmentRulesModelCopyWith(EnrollmentRulesModel value, $Res Function(EnrollmentRulesModel) _then) = _$EnrollmentRulesModelCopyWithImpl;
@useResult
$Res call({
 int minAgeYears, int capacityPerClassroom, bool requireVerifiedDocuments, Map<String, List<StudentDocumentType>> requiredDocuments
});




}
/// @nodoc
class _$EnrollmentRulesModelCopyWithImpl<$Res>
    implements $EnrollmentRulesModelCopyWith<$Res> {
  _$EnrollmentRulesModelCopyWithImpl(this._self, this._then);

  final EnrollmentRulesModel _self;
  final $Res Function(EnrollmentRulesModel) _then;

/// Create a copy of EnrollmentRulesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minAgeYears = null,Object? capacityPerClassroom = null,Object? requireVerifiedDocuments = null,Object? requiredDocuments = null,}) {
  return _then(EnrollmentRulesModel(
minAgeYears: null == minAgeYears ? _self.minAgeYears : minAgeYears // ignore: cast_nullable_to_non_nullable
as int,capacityPerClassroom: null == capacityPerClassroom ? _self.capacityPerClassroom : capacityPerClassroom // ignore: cast_nullable_to_non_nullable
as int,requireVerifiedDocuments: null == requireVerifiedDocuments ? _self.requireVerifiedDocuments : requireVerifiedDocuments // ignore: cast_nullable_to_non_nullable
as bool,requiredDocuments: null == requiredDocuments ? _self.requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as Map<String, List<StudentDocumentType>>,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrollmentRulesModel].
extension EnrollmentRulesModelPatterns on EnrollmentRulesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrollmentRulesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrollmentRulesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrollmentRulesModel value)  $default,){
final _that = this;
switch (_that) {
case _EnrollmentRulesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrollmentRulesModel value)?  $default,){
final _that = this;
switch (_that) {
case _EnrollmentRulesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minAgeYears,  int capacityPerClassroom,  bool requireVerifiedDocuments,  Map<String, List<StudentDocumentType>> requiredDocuments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrollmentRulesModel() when $default != null:
return $default(_that.minAgeYears,_that.capacityPerClassroom,_that.requireVerifiedDocuments,_that.requiredDocuments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minAgeYears,  int capacityPerClassroom,  bool requireVerifiedDocuments,  Map<String, List<StudentDocumentType>> requiredDocuments)  $default,) {final _that = this;
switch (_that) {
case _EnrollmentRulesModel():
return $default(_that.minAgeYears,_that.capacityPerClassroom,_that.requireVerifiedDocuments,_that.requiredDocuments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minAgeYears,  int capacityPerClassroom,  bool requireVerifiedDocuments,  Map<String, List<StudentDocumentType>> requiredDocuments)?  $default,) {final _that = this;
switch (_that) {
case _EnrollmentRulesModel() when $default != null:
return $default(_that.minAgeYears,_that.capacityPerClassroom,_that.requireVerifiedDocuments,_that.requiredDocuments);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EnrollmentRulesModel implements EnrollmentRulesModel {
  const _EnrollmentRulesModel({this.minAgeYears = 0, this.capacityPerClassroom = 0, this.requireVerifiedDocuments = true,  Map<String, List<StudentDocumentType>> requiredDocuments = const <String, List<StudentDocumentType>>{}}): _requiredDocuments = requiredDocuments;
  factory _EnrollmentRulesModel.fromJson(Map<String, dynamic> json) => _$EnrollmentRulesModelFromJson(json);

/// Idade mínima (anos completos à data da matrícula); não se aplica a
/// renovações. `0` desactiva.
@override@JsonKey() final  int minAgeYears;
/// Vagas por turma; `0` = sem limite.
@override@JsonKey() final  int capacityPerClassroom;
/// Só documentos verificados contam como entregues.
@override@JsonKey() final  bool requireVerifiedDocuments;
/// Documentos obrigatórios por tipo de matrícula (chave = valor JSON do
/// [EnrollmentType]: `new_enrollment`, `renewal`, `transfer`, `reentry`).
 final  Map<String, List<StudentDocumentType>> _requiredDocuments;
/// Documentos obrigatórios por tipo de matrícula (chave = valor JSON do
/// [EnrollmentType]: `new_enrollment`, `renewal`, `transfer`, `reentry`).
@override@JsonKey() Map<String, List<StudentDocumentType>> get requiredDocuments {
  if (_requiredDocuments is EqualUnmodifiableMapView) return _requiredDocuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_requiredDocuments);
}


/// Create a copy of EnrollmentRulesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrollmentRulesModelCopyWith<_EnrollmentRulesModel> get copyWith => __$EnrollmentRulesModelCopyWithImpl<_EnrollmentRulesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrollmentRulesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrollmentRulesModel&&(identical(other.minAgeYears, minAgeYears) || other.minAgeYears == minAgeYears)&&(identical(other.capacityPerClassroom, capacityPerClassroom) || other.capacityPerClassroom == capacityPerClassroom)&&(identical(other.requireVerifiedDocuments, requireVerifiedDocuments) || other.requireVerifiedDocuments == requireVerifiedDocuments)&&const DeepCollectionEquality().equals(other._requiredDocuments, _requiredDocuments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minAgeYears,capacityPerClassroom,requireVerifiedDocuments,const DeepCollectionEquality().hash(_requiredDocuments));

@override
String toString() {
  return 'EnrollmentRulesModel(minAgeYears: $minAgeYears, capacityPerClassroom: $capacityPerClassroom, requireVerifiedDocuments: $requireVerifiedDocuments, requiredDocuments: $requiredDocuments)';
}


}

/// @nodoc
abstract mixin class _$EnrollmentRulesModelCopyWith<$Res> implements $EnrollmentRulesModelCopyWith<$Res> {
  factory _$EnrollmentRulesModelCopyWith(_EnrollmentRulesModel value, $Res Function(_EnrollmentRulesModel) _then) = __$EnrollmentRulesModelCopyWithImpl;
@override @useResult
$Res call({
 int minAgeYears, int capacityPerClassroom, bool requireVerifiedDocuments, Map<String, List<StudentDocumentType>> requiredDocuments
});




}
/// @nodoc
class __$EnrollmentRulesModelCopyWithImpl<$Res>
    implements _$EnrollmentRulesModelCopyWith<$Res> {
  __$EnrollmentRulesModelCopyWithImpl(this._self, this._then);

  final _EnrollmentRulesModel _self;
  final $Res Function(_EnrollmentRulesModel) _then;

/// Create a copy of EnrollmentRulesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minAgeYears = null,Object? capacityPerClassroom = null,Object? requireVerifiedDocuments = null,Object? requiredDocuments = null,}) {
  return _then(_EnrollmentRulesModel(
minAgeYears: null == minAgeYears ? _self.minAgeYears : minAgeYears // ignore: cast_nullable_to_non_nullable
as int,capacityPerClassroom: null == capacityPerClassroom ? _self.capacityPerClassroom : capacityPerClassroom // ignore: cast_nullable_to_non_nullable
as int,requireVerifiedDocuments: null == requireVerifiedDocuments ? _self.requireVerifiedDocuments : requireVerifiedDocuments // ignore: cast_nullable_to_non_nullable
as bool,requiredDocuments: null == requiredDocuments ? _self._requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as Map<String, List<StudentDocumentType>>,
  ));
}


}


/// @nodoc
mixin _$ClassroomVacancy {

 String get classroomId;/// `0` = sem limite.
 int get capacity; int get occupied;
/// Create a copy of ClassroomVacancy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomVacancyCopyWith<ClassroomVacancy> get copyWith => _$ClassroomVacancyCopyWithImpl<ClassroomVacancy>(this as ClassroomVacancy, _$identity);

  /// Serializes this ClassroomVacancy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomVacancy&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.occupied, occupied) || other.occupied == occupied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,capacity,occupied);

@override
String toString() {
  return 'ClassroomVacancy(classroomId: $classroomId, capacity: $capacity, occupied: $occupied)';
}


}

/// @nodoc
abstract mixin class $ClassroomVacancyCopyWith<$Res>  {
  factory $ClassroomVacancyCopyWith(ClassroomVacancy value, $Res Function(ClassroomVacancy) _then) = _$ClassroomVacancyCopyWithImpl;
@useResult
$Res call({
 String classroomId, int capacity, int occupied
});




}
/// @nodoc
class _$ClassroomVacancyCopyWithImpl<$Res>
    implements $ClassroomVacancyCopyWith<$Res> {
  _$ClassroomVacancyCopyWithImpl(this._self, this._then);

  final ClassroomVacancy _self;
  final $Res Function(ClassroomVacancy) _then;

/// Create a copy of ClassroomVacancy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroomId = null,Object? capacity = null,Object? occupied = null,}) {
  return _then(ClassroomVacancy(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,occupied: null == occupied ? _self.occupied : occupied // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomVacancy].
extension ClassroomVacancyPatterns on ClassroomVacancy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomVacancy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomVacancy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomVacancy value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomVacancy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomVacancy value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomVacancy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroomId,  int capacity,  int occupied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomVacancy() when $default != null:
return $default(_that.classroomId,_that.capacity,_that.occupied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroomId,  int capacity,  int occupied)  $default,) {final _that = this;
switch (_that) {
case _ClassroomVacancy():
return $default(_that.classroomId,_that.capacity,_that.occupied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroomId,  int capacity,  int occupied)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomVacancy() when $default != null:
return $default(_that.classroomId,_that.capacity,_that.occupied);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassroomVacancy implements ClassroomVacancy {
  const _ClassroomVacancy({required this.classroomId, required this.capacity, required this.occupied});
  factory _ClassroomVacancy.fromJson(Map<String, dynamic> json) => _$ClassroomVacancyFromJson(json);

@override final  String classroomId;
/// `0` = sem limite.
@override final  int capacity;
@override final  int occupied;

/// Create a copy of ClassroomVacancy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomVacancyCopyWith<_ClassroomVacancy> get copyWith => __$ClassroomVacancyCopyWithImpl<_ClassroomVacancy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassroomVacancyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomVacancy&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.occupied, occupied) || other.occupied == occupied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,classroomId,capacity,occupied);

@override
String toString() {
  return 'ClassroomVacancy(classroomId: $classroomId, capacity: $capacity, occupied: $occupied)';
}


}

/// @nodoc
abstract mixin class _$ClassroomVacancyCopyWith<$Res> implements $ClassroomVacancyCopyWith<$Res> {
  factory _$ClassroomVacancyCopyWith(_ClassroomVacancy value, $Res Function(_ClassroomVacancy) _then) = __$ClassroomVacancyCopyWithImpl;
@override @useResult
$Res call({
 String classroomId, int capacity, int occupied
});




}
/// @nodoc
class __$ClassroomVacancyCopyWithImpl<$Res>
    implements _$ClassroomVacancyCopyWith<$Res> {
  __$ClassroomVacancyCopyWithImpl(this._self, this._then);

  final _ClassroomVacancy _self;
  final $Res Function(_ClassroomVacancy) _then;

/// Create a copy of ClassroomVacancy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroomId = null,Object? capacity = null,Object? occupied = null,}) {
  return _then(_ClassroomVacancy(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,occupied: null == occupied ? _self.occupied : occupied // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
