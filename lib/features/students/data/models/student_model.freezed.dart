// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthInfo {

 BloodType? get bloodType; List<String> get allergies; String? get medication; String? get conditions; String? get insurance; bool get hasSpecialNeeds; String? get specialNeedsNotes; String? get medicalContact;
/// Create a copy of HealthInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthInfoCopyWith<HealthInfo> get copyWith => _$HealthInfoCopyWithImpl<HealthInfo>(this as HealthInfo, _$identity);

  /// Serializes this HealthInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthInfo&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.insurance, insurance) || other.insurance == insurance)&&(identical(other.hasSpecialNeeds, hasSpecialNeeds) || other.hasSpecialNeeds == hasSpecialNeeds)&&(identical(other.specialNeedsNotes, specialNeedsNotes) || other.specialNeedsNotes == specialNeedsNotes)&&(identical(other.medicalContact, medicalContact) || other.medicalContact == medicalContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bloodType,const DeepCollectionEquality().hash(allergies),medication,conditions,insurance,hasSpecialNeeds,specialNeedsNotes,medicalContact);

@override
String toString() {
  return 'HealthInfo(bloodType: $bloodType, allergies: $allergies, medication: $medication, conditions: $conditions, insurance: $insurance, hasSpecialNeeds: $hasSpecialNeeds, specialNeedsNotes: $specialNeedsNotes, medicalContact: $medicalContact)';
}


}

/// @nodoc
abstract mixin class $HealthInfoCopyWith<$Res>  {
  factory $HealthInfoCopyWith(HealthInfo value, $Res Function(HealthInfo) _then) = _$HealthInfoCopyWithImpl;
@useResult
$Res call({
 BloodType? bloodType, List<String> allergies, String? medication, String? conditions, String? insurance, bool hasSpecialNeeds, String? specialNeedsNotes, String? medicalContact
});




}
/// @nodoc
class _$HealthInfoCopyWithImpl<$Res>
    implements $HealthInfoCopyWith<$Res> {
  _$HealthInfoCopyWithImpl(this._self, this._then);

  final HealthInfo _self;
  final $Res Function(HealthInfo) _then;

/// Create a copy of HealthInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bloodType = freezed,Object? allergies = null,Object? medication = freezed,Object? conditions = freezed,Object? insurance = freezed,Object? hasSpecialNeeds = null,Object? specialNeedsNotes = freezed,Object? medicalContact = freezed,}) {
  return _then(HealthInfo(
bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as BloodType?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,insurance: freezed == insurance ? _self.insurance : insurance // ignore: cast_nullable_to_non_nullable
as String?,hasSpecialNeeds: null == hasSpecialNeeds ? _self.hasSpecialNeeds : hasSpecialNeeds // ignore: cast_nullable_to_non_nullable
as bool,specialNeedsNotes: freezed == specialNeedsNotes ? _self.specialNeedsNotes : specialNeedsNotes // ignore: cast_nullable_to_non_nullable
as String?,medicalContact: freezed == medicalContact ? _self.medicalContact : medicalContact // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthInfo].
extension HealthInfoPatterns on HealthInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthInfo value)  $default,){
final _that = this;
switch (_that) {
case _HealthInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthInfo value)?  $default,){
final _that = this;
switch (_that) {
case _HealthInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BloodType? bloodType,  List<String> allergies,  String? medication,  String? conditions,  String? insurance,  bool hasSpecialNeeds,  String? specialNeedsNotes,  String? medicalContact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthInfo() when $default != null:
return $default(_that.bloodType,_that.allergies,_that.medication,_that.conditions,_that.insurance,_that.hasSpecialNeeds,_that.specialNeedsNotes,_that.medicalContact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BloodType? bloodType,  List<String> allergies,  String? medication,  String? conditions,  String? insurance,  bool hasSpecialNeeds,  String? specialNeedsNotes,  String? medicalContact)  $default,) {final _that = this;
switch (_that) {
case _HealthInfo():
return $default(_that.bloodType,_that.allergies,_that.medication,_that.conditions,_that.insurance,_that.hasSpecialNeeds,_that.specialNeedsNotes,_that.medicalContact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BloodType? bloodType,  List<String> allergies,  String? medication,  String? conditions,  String? insurance,  bool hasSpecialNeeds,  String? specialNeedsNotes,  String? medicalContact)?  $default,) {final _that = this;
switch (_that) {
case _HealthInfo() when $default != null:
return $default(_that.bloodType,_that.allergies,_that.medication,_that.conditions,_that.insurance,_that.hasSpecialNeeds,_that.specialNeedsNotes,_that.medicalContact);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HealthInfo implements HealthInfo {
  const _HealthInfo({this.bloodType,  List<String> allergies = const <String>[], this.medication, this.conditions, this.insurance, this.hasSpecialNeeds = false, this.specialNeedsNotes, this.medicalContact}): _allergies = allergies;
  factory _HealthInfo.fromJson(Map<String, dynamic> json) => _$HealthInfoFromJson(json);

@override final  BloodType? bloodType;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

@override final  String? medication;
@override final  String? conditions;
@override final  String? insurance;
@override@JsonKey() final  bool hasSpecialNeeds;
@override final  String? specialNeedsNotes;
@override final  String? medicalContact;

/// Create a copy of HealthInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthInfoCopyWith<_HealthInfo> get copyWith => __$HealthInfoCopyWithImpl<_HealthInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthInfo&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.insurance, insurance) || other.insurance == insurance)&&(identical(other.hasSpecialNeeds, hasSpecialNeeds) || other.hasSpecialNeeds == hasSpecialNeeds)&&(identical(other.specialNeedsNotes, specialNeedsNotes) || other.specialNeedsNotes == specialNeedsNotes)&&(identical(other.medicalContact, medicalContact) || other.medicalContact == medicalContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bloodType,const DeepCollectionEquality().hash(_allergies),medication,conditions,insurance,hasSpecialNeeds,specialNeedsNotes,medicalContact);

@override
String toString() {
  return 'HealthInfo(bloodType: $bloodType, allergies: $allergies, medication: $medication, conditions: $conditions, insurance: $insurance, hasSpecialNeeds: $hasSpecialNeeds, specialNeedsNotes: $specialNeedsNotes, medicalContact: $medicalContact)';
}


}

/// @nodoc
abstract mixin class _$HealthInfoCopyWith<$Res> implements $HealthInfoCopyWith<$Res> {
  factory _$HealthInfoCopyWith(_HealthInfo value, $Res Function(_HealthInfo) _then) = __$HealthInfoCopyWithImpl;
@override @useResult
$Res call({
 BloodType? bloodType, List<String> allergies, String? medication, String? conditions, String? insurance, bool hasSpecialNeeds, String? specialNeedsNotes, String? medicalContact
});




}
/// @nodoc
class __$HealthInfoCopyWithImpl<$Res>
    implements _$HealthInfoCopyWith<$Res> {
  __$HealthInfoCopyWithImpl(this._self, this._then);

  final _HealthInfo _self;
  final $Res Function(_HealthInfo) _then;

/// Create a copy of HealthInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bloodType = freezed,Object? allergies = null,Object? medication = freezed,Object? conditions = freezed,Object? insurance = freezed,Object? hasSpecialNeeds = null,Object? specialNeedsNotes = freezed,Object? medicalContact = freezed,}) {
  return _then(_HealthInfo(
bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as BloodType?,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,insurance: freezed == insurance ? _self.insurance : insurance // ignore: cast_nullable_to_non_nullable
as String?,hasSpecialNeeds: null == hasSpecialNeeds ? _self.hasSpecialNeeds : hasSpecialNeeds // ignore: cast_nullable_to_non_nullable
as bool,specialNeedsNotes: freezed == specialNeedsNotes ? _self.specialNeedsNotes : specialNeedsNotes // ignore: cast_nullable_to_non_nullable
as String?,medicalContact: freezed == medicalContact ? _self.medicalContact : medicalContact // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StudentModel {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState;/// N.º de processo (gerado).
 String get processNumber; String get fullName; String? get photoUrl;@DateOnlyConverter() DateTime get birthDate; String? get birthPlace; Gender get gender; String get nationality;/// BI, cédula ou passaporte.
 String? get idNumber; String? get nif; String? get address; String? get phone; String? get email; String? get originSchool; StudentStatus get status; HealthInfo get health;
/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentModelCopyWith<StudentModel> get copyWith => _$StudentModelCopyWithImpl<StudentModel>(this as StudentModel, _$identity);

  /// Serializes this StudentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.processNumber, processNumber) || other.processNumber == processNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.originSchool, originSchool) || other.originSchool == originSchool)&&(identical(other.status, status) || other.status == status)&&(identical(other.health, health) || other.health == health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,processNumber,fullName,photoUrl,birthDate,birthPlace,gender,nationality,idNumber,nif,address,phone,email,originSchool,status,health]);

@override
String toString() {
  return 'StudentModel(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, processNumber: $processNumber, fullName: $fullName, photoUrl: $photoUrl, birthDate: $birthDate, birthPlace: $birthPlace, gender: $gender, nationality: $nationality, idNumber: $idNumber, nif: $nif, address: $address, phone: $phone, email: $email, originSchool: $originSchool, status: $status, health: $health)';
}


}

/// @nodoc
abstract mixin class $StudentModelCopyWith<$Res>  {
  factory $StudentModelCopyWith(StudentModel value, $Res Function(StudentModel) _then) = _$StudentModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String processNumber, String fullName, String? photoUrl,@DateOnlyConverter() DateTime birthDate, String? birthPlace, Gender gender, String nationality, String? idNumber, String? nif, String? address, String? phone, String? email, String? originSchool, StudentStatus status, HealthInfo health
});


$HealthInfoCopyWith<$Res> get health;

}
/// @nodoc
class _$StudentModelCopyWithImpl<$Res>
    implements $StudentModelCopyWith<$Res> {
  _$StudentModelCopyWithImpl(this._self, this._then);

  final StudentModel _self;
  final $Res Function(StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? processNumber = null,Object? fullName = null,Object? photoUrl = freezed,Object? birthDate = null,Object? birthPlace = freezed,Object? gender = null,Object? nationality = null,Object? idNumber = freezed,Object? nif = freezed,Object? address = freezed,Object? phone = freezed,Object? email = freezed,Object? originSchool = freezed,Object? status = null,Object? health = null,}) {
  return _then(StudentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,processNumber: null == processNumber ? _self.processNumber : processNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,nif: freezed == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,originSchool: freezed == originSchool ? _self.originSchool : originSchool // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentStatus,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthInfo,
  ));
}
/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthInfoCopyWith<$Res> get health {
  
  return $HealthInfoCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudentModel].
extension StudentModelPatterns on StudentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String processNumber,  String fullName,  String? photoUrl, @DateOnlyConverter()  DateTime birthDate,  String? birthPlace,  Gender gender,  String nationality,  String? idNumber,  String? nif,  String? address,  String? phone,  String? email,  String? originSchool,  StudentStatus status,  HealthInfo health)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.processNumber,_that.fullName,_that.photoUrl,_that.birthDate,_that.birthPlace,_that.gender,_that.nationality,_that.idNumber,_that.nif,_that.address,_that.phone,_that.email,_that.originSchool,_that.status,_that.health);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String processNumber,  String fullName,  String? photoUrl, @DateOnlyConverter()  DateTime birthDate,  String? birthPlace,  Gender gender,  String nationality,  String? idNumber,  String? nif,  String? address,  String? phone,  String? email,  String? originSchool,  StudentStatus status,  HealthInfo health)  $default,) {final _that = this;
switch (_that) {
case _StudentModel():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.processNumber,_that.fullName,_that.photoUrl,_that.birthDate,_that.birthPlace,_that.gender,_that.nationality,_that.idNumber,_that.nif,_that.address,_that.phone,_that.email,_that.originSchool,_that.status,_that.health);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String processNumber,  String fullName,  String? photoUrl, @DateOnlyConverter()  DateTime birthDate,  String? birthPlace,  Gender gender,  String nationality,  String? idNumber,  String? nif,  String? address,  String? phone,  String? email,  String? originSchool,  StudentStatus status,  HealthInfo health)?  $default,) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.processNumber,_that.fullName,_that.photoUrl,_that.birthDate,_that.birthPlace,_that.gender,_that.nationality,_that.idNumber,_that.nif,_that.address,_that.phone,_that.email,_that.originSchool,_that.status,_that.health);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentModel implements StudentModel {
  const _StudentModel({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.processNumber, required this.fullName, this.photoUrl, @DateOnlyConverter() required this.birthDate, this.birthPlace, required this.gender, this.nationality = 'Angolana', this.idNumber, this.nif, this.address, this.phone, this.email, this.originSchool, this.status = StudentStatus.active, this.health = const HealthInfo()});
  factory _StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
/// N.º de processo (gerado).
@override final  String processNumber;
@override final  String fullName;
@override final  String? photoUrl;
@override@DateOnlyConverter() final  DateTime birthDate;
@override final  String? birthPlace;
@override final  Gender gender;
@override@JsonKey() final  String nationality;
/// BI, cédula ou passaporte.
@override final  String? idNumber;
@override final  String? nif;
@override final  String? address;
@override final  String? phone;
@override final  String? email;
@override final  String? originSchool;
@override@JsonKey() final  StudentStatus status;
@override@JsonKey() final  HealthInfo health;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentModelCopyWith<_StudentModel> get copyWith => __$StudentModelCopyWithImpl<_StudentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.processNumber, processNumber) || other.processNumber == processNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.originSchool, originSchool) || other.originSchool == originSchool)&&(identical(other.status, status) || other.status == status)&&(identical(other.health, health) || other.health == health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,processNumber,fullName,photoUrl,birthDate,birthPlace,gender,nationality,idNumber,nif,address,phone,email,originSchool,status,health]);

@override
String toString() {
  return 'StudentModel(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, processNumber: $processNumber, fullName: $fullName, photoUrl: $photoUrl, birthDate: $birthDate, birthPlace: $birthPlace, gender: $gender, nationality: $nationality, idNumber: $idNumber, nif: $nif, address: $address, phone: $phone, email: $email, originSchool: $originSchool, status: $status, health: $health)';
}


}

/// @nodoc
abstract mixin class _$StudentModelCopyWith<$Res> implements $StudentModelCopyWith<$Res> {
  factory _$StudentModelCopyWith(_StudentModel value, $Res Function(_StudentModel) _then) = __$StudentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String processNumber, String fullName, String? photoUrl,@DateOnlyConverter() DateTime birthDate, String? birthPlace, Gender gender, String nationality, String? idNumber, String? nif, String? address, String? phone, String? email, String? originSchool, StudentStatus status, HealthInfo health
});


@override $HealthInfoCopyWith<$Res> get health;

}
/// @nodoc
class __$StudentModelCopyWithImpl<$Res>
    implements _$StudentModelCopyWith<$Res> {
  __$StudentModelCopyWithImpl(this._self, this._then);

  final _StudentModel _self;
  final $Res Function(_StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? processNumber = null,Object? fullName = null,Object? photoUrl = freezed,Object? birthDate = null,Object? birthPlace = freezed,Object? gender = null,Object? nationality = null,Object? idNumber = freezed,Object? nif = freezed,Object? address = freezed,Object? phone = freezed,Object? email = freezed,Object? originSchool = freezed,Object? status = null,Object? health = null,}) {
  return _then(_StudentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,processNumber: null == processNumber ? _self.processNumber : processNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,nif: freezed == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,originSchool: freezed == originSchool ? _self.originSchool : originSchool // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentStatus,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthInfo,
  ));
}

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthInfoCopyWith<$Res> get health {
  
  return $HealthInfoCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}
}

// dart format on
