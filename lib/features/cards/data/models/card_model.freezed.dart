// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardModel {

 String get id;/// Identificador lido pelo cartão (único).
 String get uid; String get holderId; String get holderName; CardHolderType get holderType; CardStatus get status;@UtcDateTimeConverter() DateTime get issuedAt;/// Cartão que esta 2.ª via substitui.
 String? get replacesId;
/// Create a copy of CardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardModelCopyWith<CardModel> get copyWith => _$CardModelCopyWithImpl<CardModel>(this as CardModel, _$identity);

  /// Serializes this CardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.holderType, holderType) || other.holderType == holderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.replacesId, replacesId) || other.replacesId == replacesId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,holderId,holderName,holderType,status,issuedAt,replacesId);

@override
String toString() {
  return 'CardModel(id: $id, uid: $uid, holderId: $holderId, holderName: $holderName, holderType: $holderType, status: $status, issuedAt: $issuedAt, replacesId: $replacesId)';
}


}

/// @nodoc
abstract mixin class $CardModelCopyWith<$Res>  {
  factory $CardModelCopyWith(CardModel value, $Res Function(CardModel) _then) = _$CardModelCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String holderId, String holderName, CardHolderType holderType, CardStatus status,@UtcDateTimeConverter() DateTime issuedAt, String? replacesId
});




}
/// @nodoc
class _$CardModelCopyWithImpl<$Res>
    implements $CardModelCopyWith<$Res> {
  _$CardModelCopyWithImpl(this._self, this._then);

  final CardModel _self;
  final $Res Function(CardModel) _then;

/// Create a copy of CardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? holderId = null,Object? holderName = null,Object? holderType = null,Object? status = null,Object? issuedAt = null,Object? replacesId = freezed,}) {
  return _then(CardModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,holderId: null == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String,holderName: null == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String,holderType: null == holderType ? _self.holderType : holderType // ignore: cast_nullable_to_non_nullable
as CardHolderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CardStatus,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,replacesId: freezed == replacesId ? _self.replacesId : replacesId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardModel].
extension CardModelPatterns on CardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardModel value)  $default,){
final _that = this;
switch (_that) {
case _CardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardModel value)?  $default,){
final _that = this;
switch (_that) {
case _CardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String holderId,  String holderName,  CardHolderType holderType,  CardStatus status, @UtcDateTimeConverter()  DateTime issuedAt,  String? replacesId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardModel() when $default != null:
return $default(_that.id,_that.uid,_that.holderId,_that.holderName,_that.holderType,_that.status,_that.issuedAt,_that.replacesId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String holderId,  String holderName,  CardHolderType holderType,  CardStatus status, @UtcDateTimeConverter()  DateTime issuedAt,  String? replacesId)  $default,) {final _that = this;
switch (_that) {
case _CardModel():
return $default(_that.id,_that.uid,_that.holderId,_that.holderName,_that.holderType,_that.status,_that.issuedAt,_that.replacesId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String holderId,  String holderName,  CardHolderType holderType,  CardStatus status, @UtcDateTimeConverter()  DateTime issuedAt,  String? replacesId)?  $default,) {final _that = this;
switch (_that) {
case _CardModel() when $default != null:
return $default(_that.id,_that.uid,_that.holderId,_that.holderName,_that.holderType,_that.status,_that.issuedAt,_that.replacesId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardModel implements CardModel {
  const _CardModel({required this.id, required this.uid, required this.holderId, required this.holderName, required this.holderType, this.status = CardStatus.active, @UtcDateTimeConverter() required this.issuedAt, this.replacesId});
  factory _CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

@override final  String id;
/// Identificador lido pelo cartão (único).
@override final  String uid;
@override final  String holderId;
@override final  String holderName;
@override final  CardHolderType holderType;
@override@JsonKey() final  CardStatus status;
@override@UtcDateTimeConverter() final  DateTime issuedAt;
/// Cartão que esta 2.ª via substitui.
@override final  String? replacesId;

/// Create a copy of CardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardModelCopyWith<_CardModel> get copyWith => __$CardModelCopyWithImpl<_CardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.holderType, holderType) || other.holderType == holderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.replacesId, replacesId) || other.replacesId == replacesId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,holderId,holderName,holderType,status,issuedAt,replacesId);

@override
String toString() {
  return 'CardModel(id: $id, uid: $uid, holderId: $holderId, holderName: $holderName, holderType: $holderType, status: $status, issuedAt: $issuedAt, replacesId: $replacesId)';
}


}

/// @nodoc
abstract mixin class _$CardModelCopyWith<$Res> implements $CardModelCopyWith<$Res> {
  factory _$CardModelCopyWith(_CardModel value, $Res Function(_CardModel) _then) = __$CardModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String holderId, String holderName, CardHolderType holderType, CardStatus status,@UtcDateTimeConverter() DateTime issuedAt, String? replacesId
});




}
/// @nodoc
class __$CardModelCopyWithImpl<$Res>
    implements _$CardModelCopyWith<$Res> {
  __$CardModelCopyWithImpl(this._self, this._then);

  final _CardModel _self;
  final $Res Function(_CardModel) _then;

/// Create a copy of CardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? holderId = null,Object? holderName = null,Object? holderType = null,Object? status = null,Object? issuedAt = null,Object? replacesId = freezed,}) {
  return _then(_CardModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,holderId: null == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String,holderName: null == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String,holderType: null == holderType ? _self.holderType : holderType // ignore: cast_nullable_to_non_nullable
as CardHolderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CardStatus,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,replacesId: freezed == replacesId ? _self.replacesId : replacesId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
