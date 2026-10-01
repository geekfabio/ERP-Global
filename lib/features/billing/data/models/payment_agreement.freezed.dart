// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_agreement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgreementInstallment {

 int get number;@DateOnlyConverter() DateTime get dueDate;@MinorUnitConverter() int get amountMinor; bool get paid;
/// Create a copy of AgreementInstallment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgreementInstallmentCopyWith<AgreementInstallment> get copyWith => _$AgreementInstallmentCopyWithImpl<AgreementInstallment>(this as AgreementInstallment, _$identity);

  /// Serializes this AgreementInstallment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgreementInstallment&&(identical(other.number, number) || other.number == number)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paid, paid) || other.paid == paid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,dueDate,amountMinor,paid);

@override
String toString() {
  return 'AgreementInstallment(number: $number, dueDate: $dueDate, amountMinor: $amountMinor, paid: $paid)';
}


}

/// @nodoc
abstract mixin class $AgreementInstallmentCopyWith<$Res>  {
  factory $AgreementInstallmentCopyWith(AgreementInstallment value, $Res Function(AgreementInstallment) _then) = _$AgreementInstallmentCopyWithImpl;
@useResult
$Res call({
 int number,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor, bool paid
});




}
/// @nodoc
class _$AgreementInstallmentCopyWithImpl<$Res>
    implements $AgreementInstallmentCopyWith<$Res> {
  _$AgreementInstallmentCopyWithImpl(this._self, this._then);

  final AgreementInstallment _self;
  final $Res Function(AgreementInstallment) _then;

/// Create a copy of AgreementInstallment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? dueDate = null,Object? amountMinor = null,Object? paid = null,}) {
  return _then(AgreementInstallment(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AgreementInstallment].
extension AgreementInstallmentPatterns on AgreementInstallment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgreementInstallment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgreementInstallment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgreementInstallment value)  $default,){
final _that = this;
switch (_that) {
case _AgreementInstallment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgreementInstallment value)?  $default,){
final _that = this;
switch (_that) {
case _AgreementInstallment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  bool paid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgreementInstallment() when $default != null:
return $default(_that.number,_that.dueDate,_that.amountMinor,_that.paid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  bool paid)  $default,) {final _that = this;
switch (_that) {
case _AgreementInstallment():
return $default(_that.number,_that.dueDate,_that.amountMinor,_that.paid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  bool paid)?  $default,) {final _that = this;
switch (_that) {
case _AgreementInstallment() when $default != null:
return $default(_that.number,_that.dueDate,_that.amountMinor,_that.paid);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AgreementInstallment implements AgreementInstallment {
  const _AgreementInstallment({required this.number, @DateOnlyConverter() required this.dueDate, @MinorUnitConverter() required this.amountMinor, this.paid = false});
  factory _AgreementInstallment.fromJson(Map<String, dynamic> json) => _$AgreementInstallmentFromJson(json);

@override final  int number;
@override@DateOnlyConverter() final  DateTime dueDate;
@override@MinorUnitConverter() final  int amountMinor;
@override@JsonKey() final  bool paid;

/// Create a copy of AgreementInstallment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgreementInstallmentCopyWith<_AgreementInstallment> get copyWith => __$AgreementInstallmentCopyWithImpl<_AgreementInstallment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgreementInstallmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgreementInstallment&&(identical(other.number, number) || other.number == number)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paid, paid) || other.paid == paid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,dueDate,amountMinor,paid);

@override
String toString() {
  return 'AgreementInstallment(number: $number, dueDate: $dueDate, amountMinor: $amountMinor, paid: $paid)';
}


}

/// @nodoc
abstract mixin class _$AgreementInstallmentCopyWith<$Res> implements $AgreementInstallmentCopyWith<$Res> {
  factory _$AgreementInstallmentCopyWith(_AgreementInstallment value, $Res Function(_AgreementInstallment) _then) = __$AgreementInstallmentCopyWithImpl;
@override @useResult
$Res call({
 int number,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor, bool paid
});




}
/// @nodoc
class __$AgreementInstallmentCopyWithImpl<$Res>
    implements _$AgreementInstallmentCopyWith<$Res> {
  __$AgreementInstallmentCopyWithImpl(this._self, this._then);

  final _AgreementInstallment _self;
  final $Res Function(_AgreementInstallment) _then;

/// Create a copy of AgreementInstallment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? dueDate = null,Object? amountMinor = null,Object? paid = null,}) {
  return _then(_AgreementInstallment(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PaymentAgreement {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; List<String> get chargeIds;@MinorUnitConverter() int get totalMinor;@MinorUnitConverter() int get paidMinor; List<AgreementInstallment> get installments; AgreementStatus get status;
/// Create a copy of PaymentAgreement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentAgreementCopyWith<PaymentAgreement> get copyWith => _$PaymentAgreementCopyWithImpl<PaymentAgreement>(this as PaymentAgreement, _$identity);

  /// Serializes this PaymentAgreement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentAgreement&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other.chargeIds, chargeIds)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&const DeepCollectionEquality().equals(other.installments, installments)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,const DeepCollectionEquality().hash(chargeIds),totalMinor,paidMinor,const DeepCollectionEquality().hash(installments),status);

@override
String toString() {
  return 'PaymentAgreement(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, chargeIds: $chargeIds, totalMinor: $totalMinor, paidMinor: $paidMinor, installments: $installments, status: $status)';
}


}

/// @nodoc
abstract mixin class $PaymentAgreementCopyWith<$Res>  {
  factory $PaymentAgreementCopyWith(PaymentAgreement value, $Res Function(PaymentAgreement) _then) = _$PaymentAgreementCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, List<String> chargeIds,@MinorUnitConverter() int totalMinor,@MinorUnitConverter() int paidMinor, List<AgreementInstallment> installments, AgreementStatus status
});




}
/// @nodoc
class _$PaymentAgreementCopyWithImpl<$Res>
    implements $PaymentAgreementCopyWith<$Res> {
  _$PaymentAgreementCopyWithImpl(this._self, this._then);

  final PaymentAgreement _self;
  final $Res Function(PaymentAgreement) _then;

/// Create a copy of PaymentAgreement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? chargeIds = null,Object? totalMinor = null,Object? paidMinor = null,Object? installments = null,Object? status = null,}) {
  return _then(PaymentAgreement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,chargeIds: null == chargeIds ? _self.chargeIds : chargeIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,installments: null == installments ? _self.installments : installments // ignore: cast_nullable_to_non_nullable
as List<AgreementInstallment>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgreementStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentAgreement].
extension PaymentAgreementPatterns on PaymentAgreement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentAgreement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentAgreement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentAgreement value)  $default,){
final _that = this;
switch (_that) {
case _PaymentAgreement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentAgreement value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentAgreement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  List<String> chargeIds, @MinorUnitConverter()  int totalMinor, @MinorUnitConverter()  int paidMinor,  List<AgreementInstallment> installments,  AgreementStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentAgreement() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeIds,_that.totalMinor,_that.paidMinor,_that.installments,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  List<String> chargeIds, @MinorUnitConverter()  int totalMinor, @MinorUnitConverter()  int paidMinor,  List<AgreementInstallment> installments,  AgreementStatus status)  $default,) {final _that = this;
switch (_that) {
case _PaymentAgreement():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeIds,_that.totalMinor,_that.paidMinor,_that.installments,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  List<String> chargeIds, @MinorUnitConverter()  int totalMinor, @MinorUnitConverter()  int paidMinor,  List<AgreementInstallment> installments,  AgreementStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PaymentAgreement() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeIds,_that.totalMinor,_that.paidMinor,_that.installments,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PaymentAgreement implements PaymentAgreement {
  const _PaymentAgreement({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required  List<String> chargeIds, @MinorUnitConverter() required this.totalMinor, @MinorUnitConverter() this.paidMinor = 0, required  List<AgreementInstallment> installments, this.status = AgreementStatus.active}): _chargeIds = chargeIds,_installments = installments;
  factory _PaymentAgreement.fromJson(Map<String, dynamic> json) => _$PaymentAgreementFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
 final  List<String> _chargeIds;
@override List<String> get chargeIds {
  if (_chargeIds is EqualUnmodifiableListView) return _chargeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chargeIds);
}

@override@MinorUnitConverter() final  int totalMinor;
@override@JsonKey()@MinorUnitConverter() final  int paidMinor;
 final  List<AgreementInstallment> _installments;
@override List<AgreementInstallment> get installments {
  if (_installments is EqualUnmodifiableListView) return _installments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_installments);
}

@override@JsonKey() final  AgreementStatus status;

/// Create a copy of PaymentAgreement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentAgreementCopyWith<_PaymentAgreement> get copyWith => __$PaymentAgreementCopyWithImpl<_PaymentAgreement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentAgreementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentAgreement&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other._chargeIds, _chargeIds)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&const DeepCollectionEquality().equals(other._installments, _installments)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,const DeepCollectionEquality().hash(_chargeIds),totalMinor,paidMinor,const DeepCollectionEquality().hash(_installments),status);

@override
String toString() {
  return 'PaymentAgreement(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, chargeIds: $chargeIds, totalMinor: $totalMinor, paidMinor: $paidMinor, installments: $installments, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PaymentAgreementCopyWith<$Res> implements $PaymentAgreementCopyWith<$Res> {
  factory _$PaymentAgreementCopyWith(_PaymentAgreement value, $Res Function(_PaymentAgreement) _then) = __$PaymentAgreementCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, List<String> chargeIds,@MinorUnitConverter() int totalMinor,@MinorUnitConverter() int paidMinor, List<AgreementInstallment> installments, AgreementStatus status
});




}
/// @nodoc
class __$PaymentAgreementCopyWithImpl<$Res>
    implements _$PaymentAgreementCopyWith<$Res> {
  __$PaymentAgreementCopyWithImpl(this._self, this._then);

  final _PaymentAgreement _self;
  final $Res Function(_PaymentAgreement) _then;

/// Create a copy of PaymentAgreement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? chargeIds = null,Object? totalMinor = null,Object? paidMinor = null,Object? installments = null,Object? status = null,}) {
  return _then(_PaymentAgreement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,chargeIds: null == chargeIds ? _self._chargeIds : chargeIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,installments: null == installments ? _self._installments : installments // ignore: cast_nullable_to_non_nullable
as List<AgreementInstallment>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgreementStatus,
  ));
}


}

// dart format on
