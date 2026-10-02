// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guardian_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuardianModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get fullName; String? get idNumber; String? get nif; String get phone; String? get email; String? get address; String? get profession;/// Conta de utilizador do portal (perfil `encarregado`), se existir.
 String? get userId;
/// Create a copy of GuardianModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuardianModelCopyWith<GuardianModel> get copyWith => _$GuardianModelCopyWithImpl<GuardianModel>(this as GuardianModel, _$identity);

  /// Serializes this GuardianModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuardianModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,fullName,idNumber,nif,phone,email,address,profession,userId);

@override
String toString() {
  return 'GuardianModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, fullName: $fullName, idNumber: $idNumber, nif: $nif, phone: $phone, email: $email, address: $address, profession: $profession, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $GuardianModelCopyWith<$Res>  {
  factory $GuardianModelCopyWith(GuardianModel value, $Res Function(GuardianModel) _then) = _$GuardianModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String fullName, String? idNumber, String? nif, String phone, String? email, String? address, String? profession, String? userId
});




}
/// @nodoc
class _$GuardianModelCopyWithImpl<$Res>
    implements $GuardianModelCopyWith<$Res> {
  _$GuardianModelCopyWithImpl(this._self, this._then);

  final GuardianModel _self;
  final $Res Function(GuardianModel) _then;

/// Create a copy of GuardianModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? fullName = null,Object? idNumber = freezed,Object? nif = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? profession = freezed,Object? userId = freezed,}) {
  return _then(GuardianModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,nif: freezed == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuardianModel].
extension GuardianModelPatterns on GuardianModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuardianModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuardianModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuardianModel value)  $default,){
final _that = this;
switch (_that) {
case _GuardianModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuardianModel value)?  $default,){
final _that = this;
switch (_that) {
case _GuardianModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String fullName,  String? idNumber,  String? nif,  String phone,  String? email,  String? address,  String? profession,  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuardianModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.fullName,_that.idNumber,_that.nif,_that.phone,_that.email,_that.address,_that.profession,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String fullName,  String? idNumber,  String? nif,  String phone,  String? email,  String? address,  String? profession,  String? userId)  $default,) {final _that = this;
switch (_that) {
case _GuardianModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.fullName,_that.idNumber,_that.nif,_that.phone,_that.email,_that.address,_that.profession,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String fullName,  String? idNumber,  String? nif,  String phone,  String? email,  String? address,  String? profession,  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _GuardianModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.fullName,_that.idNumber,_that.nif,_that.phone,_that.email,_that.address,_that.profession,_that.userId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GuardianModel implements GuardianModel {
  const _GuardianModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.fullName, this.idNumber, this.nif, required this.phone, this.email, this.address, this.profession, this.userId});
  factory _GuardianModel.fromJson(Map<String, dynamic> json) => _$GuardianModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String fullName;
@override final  String? idNumber;
@override final  String? nif;
@override final  String phone;
@override final  String? email;
@override final  String? address;
@override final  String? profession;
/// Conta de utilizador do portal (perfil `encarregado`), se existir.
@override final  String? userId;

/// Create a copy of GuardianModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuardianModelCopyWith<_GuardianModel> get copyWith => __$GuardianModelCopyWithImpl<_GuardianModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuardianModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuardianModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,fullName,idNumber,nif,phone,email,address,profession,userId);

@override
String toString() {
  return 'GuardianModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, fullName: $fullName, idNumber: $idNumber, nif: $nif, phone: $phone, email: $email, address: $address, profession: $profession, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$GuardianModelCopyWith<$Res> implements $GuardianModelCopyWith<$Res> {
  factory _$GuardianModelCopyWith(_GuardianModel value, $Res Function(_GuardianModel) _then) = __$GuardianModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String fullName, String? idNumber, String? nif, String phone, String? email, String? address, String? profession, String? userId
});




}
/// @nodoc
class __$GuardianModelCopyWithImpl<$Res>
    implements _$GuardianModelCopyWith<$Res> {
  __$GuardianModelCopyWithImpl(this._self, this._then);

  final _GuardianModel _self;
  final $Res Function(_GuardianModel) _then;

/// Create a copy of GuardianModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? fullName = null,Object? idNumber = freezed,Object? nif = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? profession = freezed,Object? userId = freezed,}) {
  return _then(_GuardianModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,nif: freezed == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GuardianLinkModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; String get guardianId; GuardianRelationship get relationship; bool get isFinancialResponsible; bool get isEmergency; bool get canPickup;/// Fim da validade do vínculo (acesso ao portal); `null` = sem fim.
@UtcDateTimeConverter() DateTime? get validUntil; bool get verified;
/// Create a copy of GuardianLinkModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuardianLinkModelCopyWith<GuardianLinkModel> get copyWith => _$GuardianLinkModelCopyWithImpl<GuardianLinkModel>(this as GuardianLinkModel, _$identity);

  /// Serializes this GuardianLinkModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuardianLinkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.guardianId, guardianId) || other.guardianId == guardianId)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isFinancialResponsible, isFinancialResponsible) || other.isFinancialResponsible == isFinancialResponsible)&&(identical(other.isEmergency, isEmergency) || other.isEmergency == isEmergency)&&(identical(other.canPickup, canPickup) || other.canPickup == canPickup)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,guardianId,relationship,isFinancialResponsible,isEmergency,canPickup,validUntil,verified);

@override
String toString() {
  return 'GuardianLinkModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, guardianId: $guardianId, relationship: $relationship, isFinancialResponsible: $isFinancialResponsible, isEmergency: $isEmergency, canPickup: $canPickup, validUntil: $validUntil, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $GuardianLinkModelCopyWith<$Res>  {
  factory $GuardianLinkModelCopyWith(GuardianLinkModel value, $Res Function(GuardianLinkModel) _then) = _$GuardianLinkModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String guardianId, GuardianRelationship relationship, bool isFinancialResponsible, bool isEmergency, bool canPickup,@UtcDateTimeConverter() DateTime? validUntil, bool verified
});




}
/// @nodoc
class _$GuardianLinkModelCopyWithImpl<$Res>
    implements $GuardianLinkModelCopyWith<$Res> {
  _$GuardianLinkModelCopyWithImpl(this._self, this._then);

  final GuardianLinkModel _self;
  final $Res Function(GuardianLinkModel) _then;

/// Create a copy of GuardianLinkModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? guardianId = null,Object? relationship = null,Object? isFinancialResponsible = null,Object? isEmergency = null,Object? canPickup = null,Object? validUntil = freezed,Object? verified = null,}) {
  return _then(GuardianLinkModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,guardianId: null == guardianId ? _self.guardianId : guardianId // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship,isFinancialResponsible: null == isFinancialResponsible ? _self.isFinancialResponsible : isFinancialResponsible // ignore: cast_nullable_to_non_nullable
as bool,isEmergency: null == isEmergency ? _self.isEmergency : isEmergency // ignore: cast_nullable_to_non_nullable
as bool,canPickup: null == canPickup ? _self.canPickup : canPickup // ignore: cast_nullable_to_non_nullable
as bool,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GuardianLinkModel].
extension GuardianLinkModelPatterns on GuardianLinkModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuardianLinkModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuardianLinkModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuardianLinkModel value)  $default,){
final _that = this;
switch (_that) {
case _GuardianLinkModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuardianLinkModel value)?  $default,){
final _that = this;
switch (_that) {
case _GuardianLinkModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String guardianId,  GuardianRelationship relationship,  bool isFinancialResponsible,  bool isEmergency,  bool canPickup, @UtcDateTimeConverter()  DateTime? validUntil,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuardianLinkModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.guardianId,_that.relationship,_that.isFinancialResponsible,_that.isEmergency,_that.canPickup,_that.validUntil,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String guardianId,  GuardianRelationship relationship,  bool isFinancialResponsible,  bool isEmergency,  bool canPickup, @UtcDateTimeConverter()  DateTime? validUntil,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _GuardianLinkModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.guardianId,_that.relationship,_that.isFinancialResponsible,_that.isEmergency,_that.canPickup,_that.validUntil,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String guardianId,  GuardianRelationship relationship,  bool isFinancialResponsible,  bool isEmergency,  bool canPickup, @UtcDateTimeConverter()  DateTime? validUntil,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _GuardianLinkModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.guardianId,_that.relationship,_that.isFinancialResponsible,_that.isEmergency,_that.canPickup,_that.validUntil,_that.verified);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GuardianLinkModel implements GuardianLinkModel {
  const _GuardianLinkModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.guardianId, required this.relationship, this.isFinancialResponsible = false, this.isEmergency = false, this.canPickup = false, @UtcDateTimeConverter() this.validUntil, this.verified = false});
  factory _GuardianLinkModel.fromJson(Map<String, dynamic> json) => _$GuardianLinkModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  String guardianId;
@override final  GuardianRelationship relationship;
@override@JsonKey() final  bool isFinancialResponsible;
@override@JsonKey() final  bool isEmergency;
@override@JsonKey() final  bool canPickup;
/// Fim da validade do vínculo (acesso ao portal); `null` = sem fim.
@override@UtcDateTimeConverter() final  DateTime? validUntil;
@override@JsonKey() final  bool verified;

/// Create a copy of GuardianLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuardianLinkModelCopyWith<_GuardianLinkModel> get copyWith => __$GuardianLinkModelCopyWithImpl<_GuardianLinkModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuardianLinkModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuardianLinkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.guardianId, guardianId) || other.guardianId == guardianId)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isFinancialResponsible, isFinancialResponsible) || other.isFinancialResponsible == isFinancialResponsible)&&(identical(other.isEmergency, isEmergency) || other.isEmergency == isEmergency)&&(identical(other.canPickup, canPickup) || other.canPickup == canPickup)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,studentId,guardianId,relationship,isFinancialResponsible,isEmergency,canPickup,validUntil,verified);

@override
String toString() {
  return 'GuardianLinkModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, guardianId: $guardianId, relationship: $relationship, isFinancialResponsible: $isFinancialResponsible, isEmergency: $isEmergency, canPickup: $canPickup, validUntil: $validUntil, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$GuardianLinkModelCopyWith<$Res> implements $GuardianLinkModelCopyWith<$Res> {
  factory _$GuardianLinkModelCopyWith(_GuardianLinkModel value, $Res Function(_GuardianLinkModel) _then) = __$GuardianLinkModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String guardianId, GuardianRelationship relationship, bool isFinancialResponsible, bool isEmergency, bool canPickup,@UtcDateTimeConverter() DateTime? validUntil, bool verified
});




}
/// @nodoc
class __$GuardianLinkModelCopyWithImpl<$Res>
    implements _$GuardianLinkModelCopyWith<$Res> {
  __$GuardianLinkModelCopyWithImpl(this._self, this._then);

  final _GuardianLinkModel _self;
  final $Res Function(_GuardianLinkModel) _then;

/// Create a copy of GuardianLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? guardianId = null,Object? relationship = null,Object? isFinancialResponsible = null,Object? isEmergency = null,Object? canPickup = null,Object? validUntil = freezed,Object? verified = null,}) {
  return _then(_GuardianLinkModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,guardianId: null == guardianId ? _self.guardianId : guardianId // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship,isFinancialResponsible: null == isFinancialResponsible ? _self.isFinancialResponsible : isFinancialResponsible // ignore: cast_nullable_to_non_nullable
as bool,isEmergency: null == isEmergency ? _self.isEmergency : isEmergency // ignore: cast_nullable_to_non_nullable
as bool,canPickup: null == canPickup ? _self.canPickup : canPickup // ignore: cast_nullable_to_non_nullable
as bool,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
