// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountModel {

 String get id;/// Código único; nas subcontas começa pelo código da conta-mãe.
 String get code; String get name; AccountType get type; String? get parentId;/// Só as contas movimentáveis aceitam lançamentos (folhas).
 bool get postable; bool get isActive;
/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountModelCopyWith<AccountModel> get copyWith => _$AccountModelCopyWithImpl<AccountModel>(this as AccountModel, _$identity);

  /// Serializes this AccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.postable, postable) || other.postable == postable)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,type,parentId,postable,isActive);

@override
String toString() {
  return 'AccountModel(id: $id, code: $code, name: $name, type: $type, parentId: $parentId, postable: $postable, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $AccountModelCopyWith<$Res>  {
  factory $AccountModelCopyWith(AccountModel value, $Res Function(AccountModel) _then) = _$AccountModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, AccountType type, String? parentId, bool postable, bool isActive
});




}
/// @nodoc
class _$AccountModelCopyWithImpl<$Res>
    implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._self, this._then);

  final AccountModel _self;
  final $Res Function(AccountModel) _then;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? type = null,Object? parentId = freezed,Object? postable = null,Object? isActive = null,}) {
  return _then(AccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,postable: null == postable ? _self.postable : postable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountModel].
extension AccountModelPatterns on AccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountModel value)  $default,){
final _that = this;
switch (_that) {
case _AccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  AccountType type,  String? parentId,  bool postable,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.type,_that.parentId,_that.postable,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  AccountType type,  String? parentId,  bool postable,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _AccountModel():
return $default(_that.id,_that.code,_that.name,_that.type,_that.parentId,_that.postable,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  AccountType type,  String? parentId,  bool postable,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.type,_that.parentId,_that.postable,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountModel implements AccountModel {
  const _AccountModel({required this.id, required this.code, required this.name, required this.type, this.parentId, this.postable = true, this.isActive = true});
  factory _AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

@override final  String id;
/// Código único; nas subcontas começa pelo código da conta-mãe.
@override final  String code;
@override final  String name;
@override final  AccountType type;
@override final  String? parentId;
/// Só as contas movimentáveis aceitam lançamentos (folhas).
@override@JsonKey() final  bool postable;
@override@JsonKey() final  bool isActive;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountModelCopyWith<_AccountModel> get copyWith => __$AccountModelCopyWithImpl<_AccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.postable, postable) || other.postable == postable)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,type,parentId,postable,isActive);

@override
String toString() {
  return 'AccountModel(id: $id, code: $code, name: $name, type: $type, parentId: $parentId, postable: $postable, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$AccountModelCopyWith<$Res> implements $AccountModelCopyWith<$Res> {
  factory _$AccountModelCopyWith(_AccountModel value, $Res Function(_AccountModel) _then) = __$AccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, AccountType type, String? parentId, bool postable, bool isActive
});




}
/// @nodoc
class __$AccountModelCopyWithImpl<$Res>
    implements _$AccountModelCopyWith<$Res> {
  __$AccountModelCopyWithImpl(this._self, this._then);

  final _AccountModel _self;
  final $Res Function(_AccountModel) _then;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? type = null,Object? parentId = freezed,Object? postable = null,Object? isActive = null,}) {
  return _then(_AccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,postable: null == postable ? _self.postable : postable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FiscalYearModel {

 String get id; String get name;@DateOnlyConverter() DateTime get startDate;@DateOnlyConverter() DateTime get endDate; FiscalYearStatus get status;@UtcDateTimeConverter() DateTime? get closedAt;
/// Create a copy of FiscalYearModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiscalYearModelCopyWith<FiscalYearModel> get copyWith => _$FiscalYearModelCopyWithImpl<FiscalYearModel>(this as FiscalYearModel, _$identity);

  /// Serializes this FiscalYearModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FiscalYearModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startDate,endDate,status,closedAt);

@override
String toString() {
  return 'FiscalYearModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, status: $status, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class $FiscalYearModelCopyWith<$Res>  {
  factory $FiscalYearModelCopyWith(FiscalYearModel value, $Res Function(FiscalYearModel) _then) = _$FiscalYearModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, FiscalYearStatus status,@UtcDateTimeConverter() DateTime? closedAt
});




}
/// @nodoc
class _$FiscalYearModelCopyWithImpl<$Res>
    implements $FiscalYearModelCopyWith<$Res> {
  _$FiscalYearModelCopyWithImpl(this._self, this._then);

  final FiscalYearModel _self;
  final $Res Function(FiscalYearModel) _then;

/// Create a copy of FiscalYearModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? closedAt = freezed,}) {
  return _then(FiscalYearModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FiscalYearStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FiscalYearModel].
extension FiscalYearModelPatterns on FiscalYearModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FiscalYearModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FiscalYearModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FiscalYearModel value)  $default,){
final _that = this;
switch (_that) {
case _FiscalYearModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FiscalYearModel value)?  $default,){
final _that = this;
switch (_that) {
case _FiscalYearModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  FiscalYearStatus status, @UtcDateTimeConverter()  DateTime? closedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FiscalYearModel() when $default != null:
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.status,_that.closedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  FiscalYearStatus status, @UtcDateTimeConverter()  DateTime? closedAt)  $default,) {final _that = this;
switch (_that) {
case _FiscalYearModel():
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.status,_that.closedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  FiscalYearStatus status, @UtcDateTimeConverter()  DateTime? closedAt)?  $default,) {final _that = this;
switch (_that) {
case _FiscalYearModel() when $default != null:
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.status,_that.closedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FiscalYearModel implements FiscalYearModel {
  const _FiscalYearModel({required this.id, required this.name, @DateOnlyConverter() required this.startDate, @DateOnlyConverter() required this.endDate, this.status = FiscalYearStatus.open, @UtcDateTimeConverter() this.closedAt});
  factory _FiscalYearModel.fromJson(Map<String, dynamic> json) => _$FiscalYearModelFromJson(json);

@override final  String id;
@override final  String name;
@override@DateOnlyConverter() final  DateTime startDate;
@override@DateOnlyConverter() final  DateTime endDate;
@override@JsonKey() final  FiscalYearStatus status;
@override@UtcDateTimeConverter() final  DateTime? closedAt;

/// Create a copy of FiscalYearModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiscalYearModelCopyWith<_FiscalYearModel> get copyWith => __$FiscalYearModelCopyWithImpl<_FiscalYearModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FiscalYearModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiscalYearModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startDate,endDate,status,closedAt);

@override
String toString() {
  return 'FiscalYearModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, status: $status, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class _$FiscalYearModelCopyWith<$Res> implements $FiscalYearModelCopyWith<$Res> {
  factory _$FiscalYearModelCopyWith(_FiscalYearModel value, $Res Function(_FiscalYearModel) _then) = __$FiscalYearModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, FiscalYearStatus status,@UtcDateTimeConverter() DateTime? closedAt
});




}
/// @nodoc
class __$FiscalYearModelCopyWithImpl<$Res>
    implements _$FiscalYearModelCopyWith<$Res> {
  __$FiscalYearModelCopyWithImpl(this._self, this._then);

  final _FiscalYearModel _self;
  final $Res Function(_FiscalYearModel) _then;

/// Create a copy of FiscalYearModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? closedAt = freezed,}) {
  return _then(_FiscalYearModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FiscalYearStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CostCenterModel {

 String get id; String get code; String get name; bool get isActive;
/// Create a copy of CostCenterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CostCenterModelCopyWith<CostCenterModel> get copyWith => _$CostCenterModelCopyWithImpl<CostCenterModel>(this as CostCenterModel, _$identity);

  /// Serializes this CostCenterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CostCenterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,isActive);

@override
String toString() {
  return 'CostCenterModel(id: $id, code: $code, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $CostCenterModelCopyWith<$Res>  {
  factory $CostCenterModelCopyWith(CostCenterModel value, $Res Function(CostCenterModel) _then) = _$CostCenterModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, bool isActive
});




}
/// @nodoc
class _$CostCenterModelCopyWithImpl<$Res>
    implements $CostCenterModelCopyWith<$Res> {
  _$CostCenterModelCopyWithImpl(this._self, this._then);

  final CostCenterModel _self;
  final $Res Function(CostCenterModel) _then;

/// Create a copy of CostCenterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(CostCenterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CostCenterModel].
extension CostCenterModelPatterns on CostCenterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CostCenterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CostCenterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CostCenterModel value)  $default,){
final _that = this;
switch (_that) {
case _CostCenterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CostCenterModel value)?  $default,){
final _that = this;
switch (_that) {
case _CostCenterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CostCenterModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _CostCenterModel():
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _CostCenterModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CostCenterModel implements CostCenterModel {
  const _CostCenterModel({required this.id, required this.code, required this.name, this.isActive = true});
  factory _CostCenterModel.fromJson(Map<String, dynamic> json) => _$CostCenterModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override@JsonKey() final  bool isActive;

/// Create a copy of CostCenterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CostCenterModelCopyWith<_CostCenterModel> get copyWith => __$CostCenterModelCopyWithImpl<_CostCenterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CostCenterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CostCenterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,isActive);

@override
String toString() {
  return 'CostCenterModel(id: $id, code: $code, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$CostCenterModelCopyWith<$Res> implements $CostCenterModelCopyWith<$Res> {
  factory _$CostCenterModelCopyWith(_CostCenterModel value, $Res Function(_CostCenterModel) _then) = __$CostCenterModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, bool isActive
});




}
/// @nodoc
class __$CostCenterModelCopyWithImpl<$Res>
    implements _$CostCenterModelCopyWith<$Res> {
  __$CostCenterModelCopyWithImpl(this._self, this._then);

  final _CostCenterModel _self;
  final $Res Function(_CostCenterModel) _then;

/// Create a copy of CostCenterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(_CostCenterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
