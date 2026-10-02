// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealType {

 String get id; String get name; String get startTime; String get endTime; int get priceMinor; bool get isActive;
/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealTypeCopyWith<MealType> get copyWith => _$MealTypeCopyWithImpl<MealType>(this as MealType, _$identity);

  /// Serializes this MealType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,endTime,priceMinor,isActive);

@override
String toString() {
  return 'MealType(id: $id, name: $name, startTime: $startTime, endTime: $endTime, priceMinor: $priceMinor, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $MealTypeCopyWith<$Res>  {
  factory $MealTypeCopyWith(MealType value, $Res Function(MealType) _then) = _$MealTypeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String startTime, String endTime, int priceMinor, bool isActive
});




}
/// @nodoc
class _$MealTypeCopyWithImpl<$Res>
    implements $MealTypeCopyWith<$Res> {
  _$MealTypeCopyWithImpl(this._self, this._then);

  final MealType _self;
  final $Res Function(MealType) _then;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? endTime = null,Object? priceMinor = null,Object? isActive = null,}) {
  return _then(MealType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MealType].
extension MealTypePatterns on MealType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealType value)  $default,){
final _that = this;
switch (_that) {
case _MealType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealType value)?  $default,){
final _that = this;
switch (_that) {
case _MealType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String startTime,  String endTime,  int priceMinor,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealType() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.priceMinor,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String startTime,  String endTime,  int priceMinor,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _MealType():
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.priceMinor,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String startTime,  String endTime,  int priceMinor,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _MealType() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.endTime,_that.priceMinor,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealType implements MealType {
  const _MealType({required this.id, required this.name, required this.startTime, required this.endTime, this.priceMinor = 0, this.isActive = true});
  factory _MealType.fromJson(Map<String, dynamic> json) => _$MealTypeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  int priceMinor;
@override@JsonKey() final  bool isActive;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealTypeCopyWith<_MealType> get copyWith => __$MealTypeCopyWithImpl<_MealType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,endTime,priceMinor,isActive);

@override
String toString() {
  return 'MealType(id: $id, name: $name, startTime: $startTime, endTime: $endTime, priceMinor: $priceMinor, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$MealTypeCopyWith<$Res> implements $MealTypeCopyWith<$Res> {
  factory _$MealTypeCopyWith(_MealType value, $Res Function(_MealType) _then) = __$MealTypeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String startTime, String endTime, int priceMinor, bool isActive
});




}
/// @nodoc
class __$MealTypeCopyWithImpl<$Res>
    implements _$MealTypeCopyWith<$Res> {
  __$MealTypeCopyWithImpl(this._self, this._then);

  final _MealType _self;
  final $Res Function(_MealType) _then;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? endTime = null,Object? priceMinor = null,Object? isActive = null,}) {
  return _then(_MealType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MealItem {

 String get id; String get name; String get mealTypeId; int get priceMinor; List<Allergen> get allergens; bool get isActive;
/// Create a copy of MealItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealItemCopyWith<MealItem> get copyWith => _$MealItemCopyWithImpl<MealItem>(this as MealItem, _$identity);

  /// Serializes this MealItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&const DeepCollectionEquality().equals(other.allergens, allergens)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mealTypeId,priceMinor,const DeepCollectionEquality().hash(allergens),isActive);

@override
String toString() {
  return 'MealItem(id: $id, name: $name, mealTypeId: $mealTypeId, priceMinor: $priceMinor, allergens: $allergens, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $MealItemCopyWith<$Res>  {
  factory $MealItemCopyWith(MealItem value, $Res Function(MealItem) _then) = _$MealItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String mealTypeId, int priceMinor, List<Allergen> allergens, bool isActive
});




}
/// @nodoc
class _$MealItemCopyWithImpl<$Res>
    implements $MealItemCopyWith<$Res> {
  _$MealItemCopyWithImpl(this._self, this._then);

  final MealItem _self;
  final $Res Function(MealItem) _then;

/// Create a copy of MealItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mealTypeId = null,Object? priceMinor = null,Object? allergens = null,Object? isActive = null,}) {
  return _then(MealItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mealTypeId: null == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,allergens: null == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<Allergen>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MealItem].
extension MealItemPatterns on MealItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealItem value)  $default,){
final _that = this;
switch (_that) {
case _MealItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealItem value)?  $default,){
final _that = this;
switch (_that) {
case _MealItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String mealTypeId,  int priceMinor,  List<Allergen> allergens,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealItem() when $default != null:
return $default(_that.id,_that.name,_that.mealTypeId,_that.priceMinor,_that.allergens,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String mealTypeId,  int priceMinor,  List<Allergen> allergens,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _MealItem():
return $default(_that.id,_that.name,_that.mealTypeId,_that.priceMinor,_that.allergens,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String mealTypeId,  int priceMinor,  List<Allergen> allergens,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _MealItem() when $default != null:
return $default(_that.id,_that.name,_that.mealTypeId,_that.priceMinor,_that.allergens,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealItem implements MealItem {
  const _MealItem({required this.id, required this.name, required this.mealTypeId, this.priceMinor = 0,  List<Allergen> allergens = const <Allergen>[], this.isActive = true}): _allergens = allergens;
  factory _MealItem.fromJson(Map<String, dynamic> json) => _$MealItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String mealTypeId;
@override@JsonKey() final  int priceMinor;
 final  List<Allergen> _allergens;
@override@JsonKey() List<Allergen> get allergens {
  if (_allergens is EqualUnmodifiableListView) return _allergens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergens);
}

@override@JsonKey() final  bool isActive;

/// Create a copy of MealItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealItemCopyWith<_MealItem> get copyWith => __$MealItemCopyWithImpl<_MealItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&const DeepCollectionEquality().equals(other._allergens, _allergens)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mealTypeId,priceMinor,const DeepCollectionEquality().hash(_allergens),isActive);

@override
String toString() {
  return 'MealItem(id: $id, name: $name, mealTypeId: $mealTypeId, priceMinor: $priceMinor, allergens: $allergens, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$MealItemCopyWith<$Res> implements $MealItemCopyWith<$Res> {
  factory _$MealItemCopyWith(_MealItem value, $Res Function(_MealItem) _then) = __$MealItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String mealTypeId, int priceMinor, List<Allergen> allergens, bool isActive
});




}
/// @nodoc
class __$MealItemCopyWithImpl<$Res>
    implements _$MealItemCopyWith<$Res> {
  __$MealItemCopyWithImpl(this._self, this._then);

  final _MealItem _self;
  final $Res Function(_MealItem) _then;

/// Create a copy of MealItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mealTypeId = null,Object? priceMinor = null,Object? allergens = null,Object? isActive = null,}) {
  return _then(_MealItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mealTypeId: null == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,allergens: null == allergens ? _self._allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<Allergen>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MealMenu {

 String get id; String get date; String get mealTypeId; List<String> get itemIds;
/// Create a copy of MealMenu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealMenuCopyWith<MealMenu> get copyWith => _$MealMenuCopyWithImpl<MealMenu>(this as MealMenu, _$identity);

  /// Serializes this MealMenu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealMenu&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&const DeepCollectionEquality().equals(other.itemIds, itemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,mealTypeId,const DeepCollectionEquality().hash(itemIds));

@override
String toString() {
  return 'MealMenu(id: $id, date: $date, mealTypeId: $mealTypeId, itemIds: $itemIds)';
}


}

/// @nodoc
abstract mixin class $MealMenuCopyWith<$Res>  {
  factory $MealMenuCopyWith(MealMenu value, $Res Function(MealMenu) _then) = _$MealMenuCopyWithImpl;
@useResult
$Res call({
 String id, String date, String mealTypeId, List<String> itemIds
});




}
/// @nodoc
class _$MealMenuCopyWithImpl<$Res>
    implements $MealMenuCopyWith<$Res> {
  _$MealMenuCopyWithImpl(this._self, this._then);

  final MealMenu _self;
  final $Res Function(MealMenu) _then;

/// Create a copy of MealMenu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? mealTypeId = null,Object? itemIds = null,}) {
  return _then(MealMenu(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,mealTypeId: null == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String,itemIds: null == itemIds ? _self.itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MealMenu].
extension MealMenuPatterns on MealMenu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealMenu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealMenu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealMenu value)  $default,){
final _that = this;
switch (_that) {
case _MealMenu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealMenu value)?  $default,){
final _that = this;
switch (_that) {
case _MealMenu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String mealTypeId,  List<String> itemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealMenu() when $default != null:
return $default(_that.id,_that.date,_that.mealTypeId,_that.itemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String mealTypeId,  List<String> itemIds)  $default,) {final _that = this;
switch (_that) {
case _MealMenu():
return $default(_that.id,_that.date,_that.mealTypeId,_that.itemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String mealTypeId,  List<String> itemIds)?  $default,) {final _that = this;
switch (_that) {
case _MealMenu() when $default != null:
return $default(_that.id,_that.date,_that.mealTypeId,_that.itemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealMenu implements MealMenu {
  const _MealMenu({required this.id, required this.date, required this.mealTypeId,  List<String> itemIds = const <String>[]}): _itemIds = itemIds;
  factory _MealMenu.fromJson(Map<String, dynamic> json) => _$MealMenuFromJson(json);

@override final  String id;
@override final  String date;
@override final  String mealTypeId;
 final  List<String> _itemIds;
@override@JsonKey() List<String> get itemIds {
  if (_itemIds is EqualUnmodifiableListView) return _itemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemIds);
}


/// Create a copy of MealMenu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealMenuCopyWith<_MealMenu> get copyWith => __$MealMenuCopyWithImpl<_MealMenu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealMenuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealMenu&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.mealTypeId, mealTypeId) || other.mealTypeId == mealTypeId)&&const DeepCollectionEquality().equals(other._itemIds, _itemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,mealTypeId,const DeepCollectionEquality().hash(_itemIds));

@override
String toString() {
  return 'MealMenu(id: $id, date: $date, mealTypeId: $mealTypeId, itemIds: $itemIds)';
}


}

/// @nodoc
abstract mixin class _$MealMenuCopyWith<$Res> implements $MealMenuCopyWith<$Res> {
  factory _$MealMenuCopyWith(_MealMenu value, $Res Function(_MealMenu) _then) = __$MealMenuCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String mealTypeId, List<String> itemIds
});




}
/// @nodoc
class __$MealMenuCopyWithImpl<$Res>
    implements _$MealMenuCopyWith<$Res> {
  __$MealMenuCopyWithImpl(this._self, this._then);

  final _MealMenu _self;
  final $Res Function(_MealMenu) _then;

/// Create a copy of MealMenu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? mealTypeId = null,Object? itemIds = null,}) {
  return _then(_MealMenu(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,mealTypeId: null == mealTypeId ? _self.mealTypeId : mealTypeId // ignore: cast_nullable_to_non_nullable
as String,itemIds: null == itemIds ? _self._itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
