// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wallet {

 String get id; String get holderId; String get holderName; int get balanceMinor;/// Limite de consumo por dia (UTC); `0` = sem limite.
 int get dailyLimitMinor; bool get blocked;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;
/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletCopyWith<Wallet> get copyWith => _$WalletCopyWithImpl<Wallet>(this as Wallet, _$identity);

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wallet&&(identical(other.id, id) || other.id == id)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor)&&(identical(other.dailyLimitMinor, dailyLimitMinor) || other.dailyLimitMinor == dailyLimitMinor)&&(identical(other.blocked, blocked) || other.blocked == blocked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,holderId,holderName,balanceMinor,dailyLimitMinor,blocked,createdAt,updatedAt);

@override
String toString() {
  return 'Wallet(id: $id, holderId: $holderId, holderName: $holderName, balanceMinor: $balanceMinor, dailyLimitMinor: $dailyLimitMinor, blocked: $blocked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WalletCopyWith<$Res>  {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) _then) = _$WalletCopyWithImpl;
@useResult
$Res call({
 String id, String holderId, String holderName, int balanceMinor, int dailyLimitMinor, bool blocked,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$WalletCopyWithImpl<$Res>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._self, this._then);

  final Wallet _self;
  final $Res Function(Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? holderId = null,Object? holderName = null,Object? balanceMinor = null,Object? dailyLimitMinor = null,Object? blocked = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Wallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,holderId: null == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String,holderName: null == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,dailyLimitMinor: null == dailyLimitMinor ? _self.dailyLimitMinor : dailyLimitMinor // ignore: cast_nullable_to_non_nullable
as int,blocked: null == blocked ? _self.blocked : blocked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Wallet].
extension WalletPatterns on Wallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wallet value)  $default,){
final _that = this;
switch (_that) {
case _Wallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wallet value)?  $default,){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String holderId,  String holderName,  int balanceMinor,  int dailyLimitMinor,  bool blocked, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.holderId,_that.holderName,_that.balanceMinor,_that.dailyLimitMinor,_that.blocked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String holderId,  String holderName,  int balanceMinor,  int dailyLimitMinor,  bool blocked, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Wallet():
return $default(_that.id,_that.holderId,_that.holderName,_that.balanceMinor,_that.dailyLimitMinor,_that.blocked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String holderId,  String holderName,  int balanceMinor,  int dailyLimitMinor,  bool blocked, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.holderId,_that.holderName,_that.balanceMinor,_that.dailyLimitMinor,_that.blocked,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wallet implements Wallet {
  const _Wallet({required this.id, required this.holderId, required this.holderName, this.balanceMinor = 0, this.dailyLimitMinor = 0, this.blocked = false, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt});
  factory _Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

@override final  String id;
@override final  String holderId;
@override final  String holderName;
@override@JsonKey() final  int balanceMinor;
/// Limite de consumo por dia (UTC); `0` = sem limite.
@override@JsonKey() final  int dailyLimitMinor;
@override@JsonKey() final  bool blocked;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletCopyWith<_Wallet> get copyWith => __$WalletCopyWithImpl<_Wallet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wallet&&(identical(other.id, id) || other.id == id)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor)&&(identical(other.dailyLimitMinor, dailyLimitMinor) || other.dailyLimitMinor == dailyLimitMinor)&&(identical(other.blocked, blocked) || other.blocked == blocked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,holderId,holderName,balanceMinor,dailyLimitMinor,blocked,createdAt,updatedAt);

@override
String toString() {
  return 'Wallet(id: $id, holderId: $holderId, holderName: $holderName, balanceMinor: $balanceMinor, dailyLimitMinor: $dailyLimitMinor, blocked: $blocked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) _then) = __$WalletCopyWithImpl;
@override @useResult
$Res call({
 String id, String holderId, String holderName, int balanceMinor, int dailyLimitMinor, bool blocked,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(this._self, this._then);

  final _Wallet _self;
  final $Res Function(_Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? holderId = null,Object? holderName = null,Object? balanceMinor = null,Object? dailyLimitMinor = null,Object? blocked = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Wallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,holderId: null == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String,holderName: null == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,dailyLimitMinor: null == dailyLimitMinor ? _self.dailyLimitMinor : dailyLimitMinor // ignore: cast_nullable_to_non_nullable
as int,blocked: null == blocked ? _self.blocked : blocked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WalletTransaction {

 String get id; String get walletId; WalletTransactionType get type; int get amountMinor;/// Saldo da carteira depois deste movimento.
 int get balanceAfterMinor;@UtcDateTimeConverter() DateTime get occurredAt;/// Carregamento: método de pagamento (contrato com billing).
 String? get method;/// Carregamento: referência do pagamento/recibo no billing.
 String? get reference;/// Consumo: descrição (ex.: prato). Estorno: motivo.
 String? get description;/// Estorno: movimento de consumo estornado.
 String? get refundOfId;/// Consumo: tipo de refeição servida (relatórios de consumo).
 String? get mealTypeId;/// Consumo: turma do aluno no momento da compra (relatórios de consumo).
 String? get className;
/// Create a copy of WalletTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTransactionCopyWith<WalletTransaction> get copyWith => _$WalletTransactionCopyWithImpl<WalletTransaction>(this as WalletTransaction, _$identity);

  /// Serializes this WalletTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.balanceAfterMinor, balanceAfterMinor) || other.balanceAfterMinor == balanceAfterMinor)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.description, description) || other.description == description)&&(identical(other.refundOfId, refundOfId) || other.refundOfId == refundOfId)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&(identical(other.className, className) || other.className == className));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,walletId,type,amountMinor,balanceAfterMinor,occurredAt,method,reference,description,refundOfId,mealTypeId,className);

@override
String toString() {
  return 'WalletTransaction(id: $id, walletId: $walletId, type: $type, amountMinor: $amountMinor, balanceAfterMinor: $balanceAfterMinor, occurredAt: $occurredAt, method: $method, reference: $reference, description: $description, refundOfId: $refundOfId, mealTypeId: $mealTypeId, className: $className)';
}


}

/// @nodoc
abstract mixin class $WalletTransactionCopyWith<$Res>  {
  factory $WalletTransactionCopyWith(WalletTransaction value, $Res Function(WalletTransaction) _then) = _$WalletTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String walletId, WalletTransactionType type, int amountMinor, int balanceAfterMinor,@UtcDateTimeConverter() DateTime occurredAt, String? method, String? reference, String? description, String? refundOfId, String? mealTypeId, String? className
});




}
/// @nodoc
class _$WalletTransactionCopyWithImpl<$Res>
    implements $WalletTransactionCopyWith<$Res> {
  _$WalletTransactionCopyWithImpl(this._self, this._then);

  final WalletTransaction _self;
  final $Res Function(WalletTransaction) _then;

/// Create a copy of WalletTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? walletId = null,Object? type = null,Object? amountMinor = null,Object? balanceAfterMinor = null,Object? occurredAt = null,Object? method = freezed,Object? reference = freezed,Object? description = freezed,Object? refundOfId = freezed,Object? mealTypeId = freezed,Object? className = freezed,}) {
  return _then(WalletTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,balanceAfterMinor: null == balanceAfterMinor ? _self.balanceAfterMinor : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,refundOfId: freezed == refundOfId ? _self.refundOfId : refundOfId // ignore: cast_nullable_to_non_nullable
as String?,mealTypeId: freezed == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTransaction].
extension WalletTransactionPatterns on WalletTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTransaction value)  $default,){
final _that = this;
switch (_that) {
case _WalletTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String walletId,  WalletTransactionType type,  int amountMinor,  int balanceAfterMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? method,  String? reference,  String? description,  String? refundOfId,  String? mealTypeId,  String? className)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTransaction() when $default != null:
return $default(_that.id,_that.walletId,_that.type,_that.amountMinor,_that.balanceAfterMinor,_that.occurredAt,_that.method,_that.reference,_that.description,_that.refundOfId,_that.mealTypeId,_that.className);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String walletId,  WalletTransactionType type,  int amountMinor,  int balanceAfterMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? method,  String? reference,  String? description,  String? refundOfId,  String? mealTypeId,  String? className)  $default,) {final _that = this;
switch (_that) {
case _WalletTransaction():
return $default(_that.id,_that.walletId,_that.type,_that.amountMinor,_that.balanceAfterMinor,_that.occurredAt,_that.method,_that.reference,_that.description,_that.refundOfId,_that.mealTypeId,_that.className);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String walletId,  WalletTransactionType type,  int amountMinor,  int balanceAfterMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? method,  String? reference,  String? description,  String? refundOfId,  String? mealTypeId,  String? className)?  $default,) {final _that = this;
switch (_that) {
case _WalletTransaction() when $default != null:
return $default(_that.id,_that.walletId,_that.type,_that.amountMinor,_that.balanceAfterMinor,_that.occurredAt,_that.method,_that.reference,_that.description,_that.refundOfId,_that.mealTypeId,_that.className);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTransaction implements WalletTransaction {
  const _WalletTransaction({required this.id, required this.walletId, required this.type, required this.amountMinor, required this.balanceAfterMinor, @UtcDateTimeConverter() required this.occurredAt, this.method, this.reference, this.description, this.refundOfId, this.mealTypeId, this.className});
  factory _WalletTransaction.fromJson(Map<String, dynamic> json) => _$WalletTransactionFromJson(json);

@override final  String id;
@override final  String walletId;
@override final  WalletTransactionType type;
@override final  int amountMinor;
/// Saldo da carteira depois deste movimento.
@override final  int balanceAfterMinor;
@override@UtcDateTimeConverter() final  DateTime occurredAt;
/// Carregamento: método de pagamento (contrato com billing).
@override final  String? method;
/// Carregamento: referência do pagamento/recibo no billing.
@override final  String? reference;
/// Consumo: descrição (ex.: prato). Estorno: motivo.
@override final  String? description;
/// Estorno: movimento de consumo estornado.
@override final  String? refundOfId;
/// Consumo: tipo de refeição servida (relatórios de consumo).
@override final  String? mealTypeId;
/// Consumo: turma do aluno no momento da compra (relatórios de consumo).
@override final  String? className;

/// Create a copy of WalletTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTransactionCopyWith<_WalletTransaction> get copyWith => __$WalletTransactionCopyWithImpl<_WalletTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.balanceAfterMinor, balanceAfterMinor) || other.balanceAfterMinor == balanceAfterMinor)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.description, description) || other.description == description)&&(identical(other.refundOfId, refundOfId) || other.refundOfId == refundOfId)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&(identical(other.className, className) || other.className == className));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,walletId,type,amountMinor,balanceAfterMinor,occurredAt,method,reference,description,refundOfId,mealTypeId,className);

@override
String toString() {
  return 'WalletTransaction(id: $id, walletId: $walletId, type: $type, amountMinor: $amountMinor, balanceAfterMinor: $balanceAfterMinor, occurredAt: $occurredAt, method: $method, reference: $reference, description: $description, refundOfId: $refundOfId, mealTypeId: $mealTypeId, className: $className)';
}


}

/// @nodoc
abstract mixin class _$WalletTransactionCopyWith<$Res> implements $WalletTransactionCopyWith<$Res> {
  factory _$WalletTransactionCopyWith(_WalletTransaction value, $Res Function(_WalletTransaction) _then) = __$WalletTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String walletId, WalletTransactionType type, int amountMinor, int balanceAfterMinor,@UtcDateTimeConverter() DateTime occurredAt, String? method, String? reference, String? description, String? refundOfId, String? mealTypeId, String? className
});




}
/// @nodoc
class __$WalletTransactionCopyWithImpl<$Res>
    implements _$WalletTransactionCopyWith<$Res> {
  __$WalletTransactionCopyWithImpl(this._self, this._then);

  final _WalletTransaction _self;
  final $Res Function(_WalletTransaction) _then;

/// Create a copy of WalletTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? walletId = null,Object? type = null,Object? amountMinor = null,Object? balanceAfterMinor = null,Object? occurredAt = null,Object? method = freezed,Object? reference = freezed,Object? description = freezed,Object? refundOfId = freezed,Object? mealTypeId = freezed,Object? className = freezed,}) {
  return _then(_WalletTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,balanceAfterMinor: null == balanceAfterMinor ? _self.balanceAfterMinor : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,refundOfId: freezed == refundOfId ? _self.refundOfId : refundOfId // ignore: cast_nullable_to_non_nullable
as String?,mealTypeId: freezed == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
