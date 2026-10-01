// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetModel {

 String get id;/// Número de património (único).
 String get tag; String get name; String get category; String get location;/// Responsável (nome) pelo bem.
 String get custodian; AssetStatus get status;@DateOnlyConverter() DateTime get acquiredOn;/// Valor de aquisição na menor unidade (Kz × 100).
 int get valueCents; String? get writeOffReason;@UtcDateTimeConverter() DateTime? get writtenOffAt;
/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetModelCopyWith<AssetModel> get copyWith => _$AssetModelCopyWithImpl<AssetModel>(this as AssetModel, _$identity);

  /// Serializes this AssetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&(identical(other.custodian, custodian) || other.custodian == custodian)&&(identical(other.status, status) || other.status == status)&&(identical(other.acquiredOn, acquiredOn) || other.acquiredOn == acquiredOn)&&(identical(other.valueCents, valueCents) || other.valueCents == valueCents)&&(identical(other.writeOffReason, writeOffReason) || other.writeOffReason == writeOffReason)&&(identical(other.writtenOffAt, writtenOffAt) || other.writtenOffAt == writtenOffAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,name,category,location,custodian,status,acquiredOn,valueCents,writeOffReason,writtenOffAt);

@override
String toString() {
  return 'AssetModel(id: $id, tag: $tag, name: $name, category: $category, location: $location, custodian: $custodian, status: $status, acquiredOn: $acquiredOn, valueCents: $valueCents, writeOffReason: $writeOffReason, writtenOffAt: $writtenOffAt)';
}


}

/// @nodoc
abstract mixin class $AssetModelCopyWith<$Res>  {
  factory $AssetModelCopyWith(AssetModel value, $Res Function(AssetModel) _then) = _$AssetModelCopyWithImpl;
@useResult
$Res call({
 String id, String tag, String name, String category, String location, String custodian, AssetStatus status,@DateOnlyConverter() DateTime acquiredOn, int valueCents, String? writeOffReason,@UtcDateTimeConverter() DateTime? writtenOffAt
});




}
/// @nodoc
class _$AssetModelCopyWithImpl<$Res>
    implements $AssetModelCopyWith<$Res> {
  _$AssetModelCopyWithImpl(this._self, this._then);

  final AssetModel _self;
  final $Res Function(AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tag = null,Object? name = null,Object? category = null,Object? location = null,Object? custodian = null,Object? status = null,Object? acquiredOn = null,Object? valueCents = null,Object? writeOffReason = freezed,Object? writtenOffAt = freezed,}) {
  return _then(AssetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,custodian: null == custodian ? _self.custodian : custodian // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssetStatus,acquiredOn: null == acquiredOn ? _self.acquiredOn : acquiredOn // ignore: cast_nullable_to_non_nullable
as DateTime,valueCents: null == valueCents ? _self.valueCents : valueCents // ignore: cast_nullable_to_non_nullable
as int,writeOffReason: freezed == writeOffReason ? _self.writeOffReason : writeOffReason // ignore: cast_nullable_to_non_nullable
as String?,writtenOffAt: freezed == writtenOffAt ? _self.writtenOffAt : writtenOffAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetModel].
extension AssetModelPatterns on AssetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetModel value)  $default,){
final _that = this;
switch (_that) {
case _AssetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tag,  String name,  String category,  String location,  String custodian,  AssetStatus status, @DateOnlyConverter()  DateTime acquiredOn,  int valueCents,  String? writeOffReason, @UtcDateTimeConverter()  DateTime? writtenOffAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
return $default(_that.id,_that.tag,_that.name,_that.category,_that.location,_that.custodian,_that.status,_that.acquiredOn,_that.valueCents,_that.writeOffReason,_that.writtenOffAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tag,  String name,  String category,  String location,  String custodian,  AssetStatus status, @DateOnlyConverter()  DateTime acquiredOn,  int valueCents,  String? writeOffReason, @UtcDateTimeConverter()  DateTime? writtenOffAt)  $default,) {final _that = this;
switch (_that) {
case _AssetModel():
return $default(_that.id,_that.tag,_that.name,_that.category,_that.location,_that.custodian,_that.status,_that.acquiredOn,_that.valueCents,_that.writeOffReason,_that.writtenOffAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tag,  String name,  String category,  String location,  String custodian,  AssetStatus status, @DateOnlyConverter()  DateTime acquiredOn,  int valueCents,  String? writeOffReason, @UtcDateTimeConverter()  DateTime? writtenOffAt)?  $default,) {final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
return $default(_that.id,_that.tag,_that.name,_that.category,_that.location,_that.custodian,_that.status,_that.acquiredOn,_that.valueCents,_that.writeOffReason,_that.writtenOffAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetModel implements AssetModel {
  const _AssetModel({required this.id, required this.tag, required this.name, required this.category, required this.location, required this.custodian, this.status = AssetStatus.active, @DateOnlyConverter() required this.acquiredOn, this.valueCents = 0, this.writeOffReason, @UtcDateTimeConverter() this.writtenOffAt});
  factory _AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);

@override final  String id;
/// Número de património (único).
@override final  String tag;
@override final  String name;
@override final  String category;
@override final  String location;
/// Responsável (nome) pelo bem.
@override final  String custodian;
@override@JsonKey() final  AssetStatus status;
@override@DateOnlyConverter() final  DateTime acquiredOn;
/// Valor de aquisição na menor unidade (Kz × 100).
@override@JsonKey() final  int valueCents;
@override final  String? writeOffReason;
@override@UtcDateTimeConverter() final  DateTime? writtenOffAt;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetModelCopyWith<_AssetModel> get copyWith => __$AssetModelCopyWithImpl<_AssetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&(identical(other.custodian, custodian) || other.custodian == custodian)&&(identical(other.status, status) || other.status == status)&&(identical(other.acquiredOn, acquiredOn) || other.acquiredOn == acquiredOn)&&(identical(other.valueCents, valueCents) || other.valueCents == valueCents)&&(identical(other.writeOffReason, writeOffReason) || other.writeOffReason == writeOffReason)&&(identical(other.writtenOffAt, writtenOffAt) || other.writtenOffAt == writtenOffAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,name,category,location,custodian,status,acquiredOn,valueCents,writeOffReason,writtenOffAt);

@override
String toString() {
  return 'AssetModel(id: $id, tag: $tag, name: $name, category: $category, location: $location, custodian: $custodian, status: $status, acquiredOn: $acquiredOn, valueCents: $valueCents, writeOffReason: $writeOffReason, writtenOffAt: $writtenOffAt)';
}


}

/// @nodoc
abstract mixin class _$AssetModelCopyWith<$Res> implements $AssetModelCopyWith<$Res> {
  factory _$AssetModelCopyWith(_AssetModel value, $Res Function(_AssetModel) _then) = __$AssetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String tag, String name, String category, String location, String custodian, AssetStatus status,@DateOnlyConverter() DateTime acquiredOn, int valueCents, String? writeOffReason,@UtcDateTimeConverter() DateTime? writtenOffAt
});




}
/// @nodoc
class __$AssetModelCopyWithImpl<$Res>
    implements _$AssetModelCopyWith<$Res> {
  __$AssetModelCopyWithImpl(this._self, this._then);

  final _AssetModel _self;
  final $Res Function(_AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tag = null,Object? name = null,Object? category = null,Object? location = null,Object? custodian = null,Object? status = null,Object? acquiredOn = null,Object? valueCents = null,Object? writeOffReason = freezed,Object? writtenOffAt = freezed,}) {
  return _then(_AssetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,custodian: null == custodian ? _self.custodian : custodian // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssetStatus,acquiredOn: null == acquiredOn ? _self.acquiredOn : acquiredOn // ignore: cast_nullable_to_non_nullable
as DateTime,valueCents: null == valueCents ? _self.valueCents : valueCents // ignore: cast_nullable_to_non_nullable
as int,writeOffReason: freezed == writeOffReason ? _self.writeOffReason : writeOffReason // ignore: cast_nullable_to_non_nullable
as String?,writtenOffAt: freezed == writtenOffAt ? _self.writtenOffAt : writtenOffAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MaintenanceModel {

 String get id; String get assetId; String get description;@DateOnlyConverter() DateTime get scheduledOn; int get costCents; MaintenanceStatus get status;@UtcDateTimeConverter() DateTime? get completedAt;
/// Create a copy of MaintenanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceModelCopyWith<MaintenanceModel> get copyWith => _$MaintenanceModelCopyWithImpl<MaintenanceModel>(this as MaintenanceModel, _$identity);

  /// Serializes this MaintenanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.scheduledOn, scheduledOn) || other.scheduledOn == scheduledOn)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,description,scheduledOn,costCents,status,completedAt);

@override
String toString() {
  return 'MaintenanceModel(id: $id, assetId: $assetId, description: $description, scheduledOn: $scheduledOn, costCents: $costCents, status: $status, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $MaintenanceModelCopyWith<$Res>  {
  factory $MaintenanceModelCopyWith(MaintenanceModel value, $Res Function(MaintenanceModel) _then) = _$MaintenanceModelCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String description,@DateOnlyConverter() DateTime scheduledOn, int costCents, MaintenanceStatus status,@UtcDateTimeConverter() DateTime? completedAt
});




}
/// @nodoc
class _$MaintenanceModelCopyWithImpl<$Res>
    implements $MaintenanceModelCopyWith<$Res> {
  _$MaintenanceModelCopyWithImpl(this._self, this._then);

  final MaintenanceModel _self;
  final $Res Function(MaintenanceModel) _then;

/// Create a copy of MaintenanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? description = null,Object? scheduledOn = null,Object? costCents = null,Object? status = null,Object? completedAt = freezed,}) {
  return _then(MaintenanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scheduledOn: null == scheduledOn ? _self.scheduledOn : scheduledOn // ignore: cast_nullable_to_non_nullable
as DateTime,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaintenanceStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceModel].
extension MaintenanceModelPatterns on MaintenanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceModel value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String description, @DateOnlyConverter()  DateTime scheduledOn,  int costCents,  MaintenanceStatus status, @UtcDateTimeConverter()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceModel() when $default != null:
return $default(_that.id,_that.assetId,_that.description,_that.scheduledOn,_that.costCents,_that.status,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String description, @DateOnlyConverter()  DateTime scheduledOn,  int costCents,  MaintenanceStatus status, @UtcDateTimeConverter()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceModel():
return $default(_that.id,_that.assetId,_that.description,_that.scheduledOn,_that.costCents,_that.status,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String description, @DateOnlyConverter()  DateTime scheduledOn,  int costCents,  MaintenanceStatus status, @UtcDateTimeConverter()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceModel() when $default != null:
return $default(_that.id,_that.assetId,_that.description,_that.scheduledOn,_that.costCents,_that.status,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceModel implements MaintenanceModel {
  const _MaintenanceModel({required this.id, required this.assetId, required this.description, @DateOnlyConverter() required this.scheduledOn, this.costCents = 0, this.status = MaintenanceStatus.open, @UtcDateTimeConverter() this.completedAt});
  factory _MaintenanceModel.fromJson(Map<String, dynamic> json) => _$MaintenanceModelFromJson(json);

@override final  String id;
@override final  String assetId;
@override final  String description;
@override@DateOnlyConverter() final  DateTime scheduledOn;
@override@JsonKey() final  int costCents;
@override@JsonKey() final  MaintenanceStatus status;
@override@UtcDateTimeConverter() final  DateTime? completedAt;

/// Create a copy of MaintenanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceModelCopyWith<_MaintenanceModel> get copyWith => __$MaintenanceModelCopyWithImpl<_MaintenanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.scheduledOn, scheduledOn) || other.scheduledOn == scheduledOn)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,description,scheduledOn,costCents,status,completedAt);

@override
String toString() {
  return 'MaintenanceModel(id: $id, assetId: $assetId, description: $description, scheduledOn: $scheduledOn, costCents: $costCents, status: $status, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceModelCopyWith<$Res> implements $MaintenanceModelCopyWith<$Res> {
  factory _$MaintenanceModelCopyWith(_MaintenanceModel value, $Res Function(_MaintenanceModel) _then) = __$MaintenanceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String description,@DateOnlyConverter() DateTime scheduledOn, int costCents, MaintenanceStatus status,@UtcDateTimeConverter() DateTime? completedAt
});




}
/// @nodoc
class __$MaintenanceModelCopyWithImpl<$Res>
    implements _$MaintenanceModelCopyWith<$Res> {
  __$MaintenanceModelCopyWithImpl(this._self, this._then);

  final _MaintenanceModel _self;
  final $Res Function(_MaintenanceModel) _then;

/// Create a copy of MaintenanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? description = null,Object? scheduledOn = null,Object? costCents = null,Object? status = null,Object? completedAt = freezed,}) {
  return _then(_MaintenanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scheduledOn: null == scheduledOn ? _self.scheduledOn : scheduledOn // ignore: cast_nullable_to_non_nullable
as DateTime,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaintenanceStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StockItemModel {

 String get id; String get sku; String get name;/// Unidade de medida (un, cx, resma…).
 String get unit; int get quantity; int get minQuantity; String get location;/// Calculado pelo servidor: `quantity <= minQuantity`.
 bool get lowStock;
/// Create a copy of StockItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockItemModelCopyWith<StockItemModel> get copyWith => _$StockItemModelCopyWithImpl<StockItemModel>(this as StockItemModel, _$identity);

  /// Serializes this StockItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.location, location) || other.location == location)&&(identical(other.lowStock, lowStock) || other.lowStock == lowStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,unit,quantity,minQuantity,location,lowStock);

@override
String toString() {
  return 'StockItemModel(id: $id, sku: $sku, name: $name, unit: $unit, quantity: $quantity, minQuantity: $minQuantity, location: $location, lowStock: $lowStock)';
}


}

/// @nodoc
abstract mixin class $StockItemModelCopyWith<$Res>  {
  factory $StockItemModelCopyWith(StockItemModel value, $Res Function(StockItemModel) _then) = _$StockItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name, String unit, int quantity, int minQuantity, String location, bool lowStock
});




}
/// @nodoc
class _$StockItemModelCopyWithImpl<$Res>
    implements $StockItemModelCopyWith<$Res> {
  _$StockItemModelCopyWithImpl(this._self, this._then);

  final StockItemModel _self;
  final $Res Function(StockItemModel) _then;

/// Create a copy of StockItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? unit = null,Object? quantity = null,Object? minQuantity = null,Object? location = null,Object? lowStock = null,}) {
  return _then(StockItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,minQuantity: null == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StockItemModel].
extension StockItemModelPatterns on StockItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockItemModel value)  $default,){
final _that = this;
switch (_that) {
case _StockItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String unit,  int quantity,  int minQuantity,  String location,  bool lowStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockItemModel() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.unit,_that.quantity,_that.minQuantity,_that.location,_that.lowStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String unit,  int quantity,  int minQuantity,  String location,  bool lowStock)  $default,) {final _that = this;
switch (_that) {
case _StockItemModel():
return $default(_that.id,_that.sku,_that.name,_that.unit,_that.quantity,_that.minQuantity,_that.location,_that.lowStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name,  String unit,  int quantity,  int minQuantity,  String location,  bool lowStock)?  $default,) {final _that = this;
switch (_that) {
case _StockItemModel() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.unit,_that.quantity,_that.minQuantity,_that.location,_that.lowStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockItemModel implements StockItemModel {
  const _StockItemModel({required this.id, required this.sku, required this.name, required this.unit, required this.quantity, required this.minQuantity, required this.location, this.lowStock = false});
  factory _StockItemModel.fromJson(Map<String, dynamic> json) => _$StockItemModelFromJson(json);

@override final  String id;
@override final  String sku;
@override final  String name;
/// Unidade de medida (un, cx, resma…).
@override final  String unit;
@override final  int quantity;
@override final  int minQuantity;
@override final  String location;
/// Calculado pelo servidor: `quantity <= minQuantity`.
@override@JsonKey() final  bool lowStock;

/// Create a copy of StockItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockItemModelCopyWith<_StockItemModel> get copyWith => __$StockItemModelCopyWithImpl<_StockItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.location, location) || other.location == location)&&(identical(other.lowStock, lowStock) || other.lowStock == lowStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,unit,quantity,minQuantity,location,lowStock);

@override
String toString() {
  return 'StockItemModel(id: $id, sku: $sku, name: $name, unit: $unit, quantity: $quantity, minQuantity: $minQuantity, location: $location, lowStock: $lowStock)';
}


}

/// @nodoc
abstract mixin class _$StockItemModelCopyWith<$Res> implements $StockItemModelCopyWith<$Res> {
  factory _$StockItemModelCopyWith(_StockItemModel value, $Res Function(_StockItemModel) _then) = __$StockItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name, String unit, int quantity, int minQuantity, String location, bool lowStock
});




}
/// @nodoc
class __$StockItemModelCopyWithImpl<$Res>
    implements _$StockItemModelCopyWith<$Res> {
  __$StockItemModelCopyWithImpl(this._self, this._then);

  final _StockItemModel _self;
  final $Res Function(_StockItemModel) _then;

/// Create a copy of StockItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? unit = null,Object? quantity = null,Object? minQuantity = null,Object? location = null,Object? lowStock = null,}) {
  return _then(_StockItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,minQuantity: null == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
