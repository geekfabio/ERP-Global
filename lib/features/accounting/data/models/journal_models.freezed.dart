// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalLineModel {

 String get accountId; int get debitMinor; int get creditMinor; String? get costCenterId; String? get description;
/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalLineModelCopyWith<JournalLineModel> get copyWith => _$JournalLineModelCopyWithImpl<JournalLineModel>(this as JournalLineModel, _$identity);

  /// Serializes this JournalLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalLineModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.costCenterId, costCenterId) || other.costCenterId == costCenterId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,debitMinor,creditMinor,costCenterId,description);

@override
String toString() {
  return 'JournalLineModel(accountId: $accountId, debitMinor: $debitMinor, creditMinor: $creditMinor, costCenterId: $costCenterId, description: $description)';
}


}

/// @nodoc
abstract mixin class $JournalLineModelCopyWith<$Res>  {
  factory $JournalLineModelCopyWith(JournalLineModel value, $Res Function(JournalLineModel) _then) = _$JournalLineModelCopyWithImpl;
@useResult
$Res call({
 String accountId, int debitMinor, int creditMinor, String? costCenterId, String? description
});




}
/// @nodoc
class _$JournalLineModelCopyWithImpl<$Res>
    implements $JournalLineModelCopyWith<$Res> {
  _$JournalLineModelCopyWithImpl(this._self, this._then);

  final JournalLineModel _self;
  final $Res Function(JournalLineModel) _then;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? debitMinor = null,Object? creditMinor = null,Object? costCenterId = freezed,Object? description = freezed,}) {
  return _then(JournalLineModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,costCenterId: freezed == costCenterId ? _self.costCenterId : costCenterId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalLineModel].
extension JournalLineModelPatterns on JournalLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalLineModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  int debitMinor,  int creditMinor,  String? costCenterId,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
return $default(_that.accountId,_that.debitMinor,_that.creditMinor,_that.costCenterId,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  int debitMinor,  int creditMinor,  String? costCenterId,  String? description)  $default,) {final _that = this;
switch (_that) {
case _JournalLineModel():
return $default(_that.accountId,_that.debitMinor,_that.creditMinor,_that.costCenterId,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  int debitMinor,  int creditMinor,  String? costCenterId,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
return $default(_that.accountId,_that.debitMinor,_that.creditMinor,_that.costCenterId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalLineModel implements JournalLineModel {
  const _JournalLineModel({required this.accountId, this.debitMinor = 0, this.creditMinor = 0, this.costCenterId, this.description});
  factory _JournalLineModel.fromJson(Map<String, dynamic> json) => _$JournalLineModelFromJson(json);

@override final  String accountId;
@override@JsonKey() final  int debitMinor;
@override@JsonKey() final  int creditMinor;
@override final  String? costCenterId;
@override final  String? description;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalLineModelCopyWith<_JournalLineModel> get copyWith => __$JournalLineModelCopyWithImpl<_JournalLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalLineModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.costCenterId, costCenterId) || other.costCenterId == costCenterId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,debitMinor,creditMinor,costCenterId,description);

@override
String toString() {
  return 'JournalLineModel(accountId: $accountId, debitMinor: $debitMinor, creditMinor: $creditMinor, costCenterId: $costCenterId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$JournalLineModelCopyWith<$Res> implements $JournalLineModelCopyWith<$Res> {
  factory _$JournalLineModelCopyWith(_JournalLineModel value, $Res Function(_JournalLineModel) _then) = __$JournalLineModelCopyWithImpl;
@override @useResult
$Res call({
 String accountId, int debitMinor, int creditMinor, String? costCenterId, String? description
});




}
/// @nodoc
class __$JournalLineModelCopyWithImpl<$Res>
    implements _$JournalLineModelCopyWith<$Res> {
  __$JournalLineModelCopyWithImpl(this._self, this._then);

  final _JournalLineModel _self;
  final $Res Function(_JournalLineModel) _then;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? debitMinor = null,Object? creditMinor = null,Object? costCenterId = freezed,Object? description = freezed,}) {
  return _then(_JournalLineModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,costCenterId: freezed == costCenterId ? _self.costCenterId : costCenterId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JournalEntryModel {

 String get id; int get number;@DateOnlyConverter() DateTime get date; String get description; List<JournalLineModel> get lines; JournalEntryStatus get status; JournalSource get source;/// Referência da origem (ex.: `payment.received:<id>`); idempotência.
 String? get sourceRef; String? get reversalOfId;
/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryModelCopyWith<JournalEntryModel> get copyWith => _$JournalEntryModelCopyWithImpl<JournalEntryModel>(this as JournalEntryModel, _$identity);

  /// Serializes this JournalEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceRef, sourceRef) || other.sourceRef == sourceRef)&&(identical(other.reversalOfId, reversalOfId) || other.reversalOfId == reversalOfId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,date,description,const DeepCollectionEquality().hash(lines),status,source,sourceRef,reversalOfId);

@override
String toString() {
  return 'JournalEntryModel(id: $id, number: $number, date: $date, description: $description, lines: $lines, status: $status, source: $source, sourceRef: $sourceRef, reversalOfId: $reversalOfId)';
}


}

/// @nodoc
abstract mixin class $JournalEntryModelCopyWith<$Res>  {
  factory $JournalEntryModelCopyWith(JournalEntryModel value, $Res Function(JournalEntryModel) _then) = _$JournalEntryModelCopyWithImpl;
@useResult
$Res call({
 String id, int number,@DateOnlyConverter() DateTime date, String description, List<JournalLineModel> lines, JournalEntryStatus status, JournalSource source, String? sourceRef, String? reversalOfId
});




}
/// @nodoc
class _$JournalEntryModelCopyWithImpl<$Res>
    implements $JournalEntryModelCopyWith<$Res> {
  _$JournalEntryModelCopyWithImpl(this._self, this._then);

  final JournalEntryModel _self;
  final $Res Function(JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? date = null,Object? description = null,Object? lines = null,Object? status = null,Object? source = null,Object? sourceRef = freezed,Object? reversalOfId = freezed,}) {
  return _then(JournalEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JournalEntryStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,sourceRef: freezed == sourceRef ? _self.sourceRef : sourceRef // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryModel].
extension JournalEntryModelPatterns on JournalEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number, @DateOnlyConverter()  DateTime date,  String description,  List<JournalLineModel> lines,  JournalEntryStatus status,  JournalSource source,  String? sourceRef,  String? reversalOfId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.number,_that.date,_that.description,_that.lines,_that.status,_that.source,_that.sourceRef,_that.reversalOfId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number, @DateOnlyConverter()  DateTime date,  String description,  List<JournalLineModel> lines,  JournalEntryStatus status,  JournalSource source,  String? sourceRef,  String? reversalOfId)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel():
return $default(_that.id,_that.number,_that.date,_that.description,_that.lines,_that.status,_that.source,_that.sourceRef,_that.reversalOfId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number, @DateOnlyConverter()  DateTime date,  String description,  List<JournalLineModel> lines,  JournalEntryStatus status,  JournalSource source,  String? sourceRef,  String? reversalOfId)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.number,_that.date,_that.description,_that.lines,_that.status,_that.source,_that.sourceRef,_that.reversalOfId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JournalEntryModel implements JournalEntryModel {
  const _JournalEntryModel({required this.id, this.number = 0, @DateOnlyConverter() required this.date, required this.description, required  List<JournalLineModel> lines, this.status = JournalEntryStatus.posted, this.source = JournalSource.manual, this.sourceRef, this.reversalOfId}): _lines = lines;
  factory _JournalEntryModel.fromJson(Map<String, dynamic> json) => _$JournalEntryModelFromJson(json);

@override final  String id;
@override@JsonKey() final  int number;
@override@DateOnlyConverter() final  DateTime date;
@override final  String description;
 final  List<JournalLineModel> _lines;
@override List<JournalLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  JournalEntryStatus status;
@override@JsonKey() final  JournalSource source;
/// Referência da origem (ex.: `payment.received:<id>`); idempotência.
@override final  String? sourceRef;
@override final  String? reversalOfId;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryModelCopyWith<_JournalEntryModel> get copyWith => __$JournalEntryModelCopyWithImpl<_JournalEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceRef, sourceRef) || other.sourceRef == sourceRef)&&(identical(other.reversalOfId, reversalOfId) || other.reversalOfId == reversalOfId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,date,description,const DeepCollectionEquality().hash(_lines),status,source,sourceRef,reversalOfId);

@override
String toString() {
  return 'JournalEntryModel(id: $id, number: $number, date: $date, description: $description, lines: $lines, status: $status, source: $source, sourceRef: $sourceRef, reversalOfId: $reversalOfId)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryModelCopyWith<$Res> implements $JournalEntryModelCopyWith<$Res> {
  factory _$JournalEntryModelCopyWith(_JournalEntryModel value, $Res Function(_JournalEntryModel) _then) = __$JournalEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int number,@DateOnlyConverter() DateTime date, String description, List<JournalLineModel> lines, JournalEntryStatus status, JournalSource source, String? sourceRef, String? reversalOfId
});




}
/// @nodoc
class __$JournalEntryModelCopyWithImpl<$Res>
    implements _$JournalEntryModelCopyWith<$Res> {
  __$JournalEntryModelCopyWithImpl(this._self, this._then);

  final _JournalEntryModel _self;
  final $Res Function(_JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? date = null,Object? description = null,Object? lines = null,Object? status = null,Object? source = null,Object? sourceRef = freezed,Object? reversalOfId = freezed,}) {
  return _then(_JournalEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JournalEntryStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,sourceRef: freezed == sourceRef ? _self.sourceRef : sourceRef // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LedgerLineModel {

 String get entryId; int get number;@DateOnlyConverter() DateTime get date; String get description; int get debitMinor; int get creditMinor; int get balanceMinor;
/// Create a copy of LedgerLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerLineModelCopyWith<LedgerLineModel> get copyWith => _$LedgerLineModelCopyWithImpl<LedgerLineModel>(this as LedgerLineModel, _$identity);

  /// Serializes this LedgerLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerLineModel&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.number, number) || other.number == number)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,number,date,description,debitMinor,creditMinor,balanceMinor);

@override
String toString() {
  return 'LedgerLineModel(entryId: $entryId, number: $number, date: $date, description: $description, debitMinor: $debitMinor, creditMinor: $creditMinor, balanceMinor: $balanceMinor)';
}


}

/// @nodoc
abstract mixin class $LedgerLineModelCopyWith<$Res>  {
  factory $LedgerLineModelCopyWith(LedgerLineModel value, $Res Function(LedgerLineModel) _then) = _$LedgerLineModelCopyWithImpl;
@useResult
$Res call({
 String entryId, int number,@DateOnlyConverter() DateTime date, String description, int debitMinor, int creditMinor, int balanceMinor
});




}
/// @nodoc
class _$LedgerLineModelCopyWithImpl<$Res>
    implements $LedgerLineModelCopyWith<$Res> {
  _$LedgerLineModelCopyWithImpl(this._self, this._then);

  final LedgerLineModel _self;
  final $Res Function(LedgerLineModel) _then;

/// Create a copy of LedgerLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = null,Object? number = null,Object? date = null,Object? description = null,Object? debitMinor = null,Object? creditMinor = null,Object? balanceMinor = null,}) {
  return _then(LedgerLineModel(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerLineModel].
extension LedgerLineModelPatterns on LedgerLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerLineModel value)  $default,){
final _that = this;
switch (_that) {
case _LedgerLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entryId,  int number, @DateOnlyConverter()  DateTime date,  String description,  int debitMinor,  int creditMinor,  int balanceMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerLineModel() when $default != null:
return $default(_that.entryId,_that.number,_that.date,_that.description,_that.debitMinor,_that.creditMinor,_that.balanceMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entryId,  int number, @DateOnlyConverter()  DateTime date,  String description,  int debitMinor,  int creditMinor,  int balanceMinor)  $default,) {final _that = this;
switch (_that) {
case _LedgerLineModel():
return $default(_that.entryId,_that.number,_that.date,_that.description,_that.debitMinor,_that.creditMinor,_that.balanceMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entryId,  int number, @DateOnlyConverter()  DateTime date,  String description,  int debitMinor,  int creditMinor,  int balanceMinor)?  $default,) {final _that = this;
switch (_that) {
case _LedgerLineModel() when $default != null:
return $default(_that.entryId,_that.number,_that.date,_that.description,_that.debitMinor,_that.creditMinor,_that.balanceMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerLineModel implements LedgerLineModel {
  const _LedgerLineModel({required this.entryId, required this.number, @DateOnlyConverter() required this.date, required this.description, this.debitMinor = 0, this.creditMinor = 0, required this.balanceMinor});
  factory _LedgerLineModel.fromJson(Map<String, dynamic> json) => _$LedgerLineModelFromJson(json);

@override final  String entryId;
@override final  int number;
@override@DateOnlyConverter() final  DateTime date;
@override final  String description;
@override@JsonKey() final  int debitMinor;
@override@JsonKey() final  int creditMinor;
@override final  int balanceMinor;

/// Create a copy of LedgerLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerLineModelCopyWith<_LedgerLineModel> get copyWith => __$LedgerLineModelCopyWithImpl<_LedgerLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerLineModel&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.number, number) || other.number == number)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,number,date,description,debitMinor,creditMinor,balanceMinor);

@override
String toString() {
  return 'LedgerLineModel(entryId: $entryId, number: $number, date: $date, description: $description, debitMinor: $debitMinor, creditMinor: $creditMinor, balanceMinor: $balanceMinor)';
}


}

/// @nodoc
abstract mixin class _$LedgerLineModelCopyWith<$Res> implements $LedgerLineModelCopyWith<$Res> {
  factory _$LedgerLineModelCopyWith(_LedgerLineModel value, $Res Function(_LedgerLineModel) _then) = __$LedgerLineModelCopyWithImpl;
@override @useResult
$Res call({
 String entryId, int number,@DateOnlyConverter() DateTime date, String description, int debitMinor, int creditMinor, int balanceMinor
});




}
/// @nodoc
class __$LedgerLineModelCopyWithImpl<$Res>
    implements _$LedgerLineModelCopyWith<$Res> {
  __$LedgerLineModelCopyWithImpl(this._self, this._then);

  final _LedgerLineModel _self;
  final $Res Function(_LedgerLineModel) _then;

/// Create a copy of LedgerLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = null,Object? number = null,Object? date = null,Object? description = null,Object? debitMinor = null,Object? creditMinor = null,Object? balanceMinor = null,}) {
  return _then(_LedgerLineModel(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LedgerModel {

 String get accountId; String get code; String get name; int get openingMinor; int get debitMinor; int get creditMinor; int get closingMinor; List<LedgerLineModel> get lines;
/// Create a copy of LedgerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerModelCopyWith<LedgerModel> get copyWith => _$LedgerModelCopyWithImpl<LedgerModel>(this as LedgerModel, _$identity);

  /// Serializes this LedgerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.closingMinor, closingMinor) || other.closingMinor == closingMinor)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,code,name,openingMinor,debitMinor,creditMinor,closingMinor,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'LedgerModel(accountId: $accountId, code: $code, name: $name, openingMinor: $openingMinor, debitMinor: $debitMinor, creditMinor: $creditMinor, closingMinor: $closingMinor, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $LedgerModelCopyWith<$Res>  {
  factory $LedgerModelCopyWith(LedgerModel value, $Res Function(LedgerModel) _then) = _$LedgerModelCopyWithImpl;
@useResult
$Res call({
 String accountId, String code, String name, int openingMinor, int debitMinor, int creditMinor, int closingMinor, List<LedgerLineModel> lines
});




}
/// @nodoc
class _$LedgerModelCopyWithImpl<$Res>
    implements $LedgerModelCopyWith<$Res> {
  _$LedgerModelCopyWithImpl(this._self, this._then);

  final LedgerModel _self;
  final $Res Function(LedgerModel) _then;

/// Create a copy of LedgerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? code = null,Object? name = null,Object? openingMinor = null,Object? debitMinor = null,Object? creditMinor = null,Object? closingMinor = null,Object? lines = null,}) {
  return _then(LedgerModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,closingMinor: null == closingMinor ? _self.closingMinor : closingMinor // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<LedgerLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerModel].
extension LedgerModelPatterns on LedgerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerModel value)  $default,){
final _that = this;
switch (_that) {
case _LedgerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerModel value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor,  List<LedgerLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerModel() when $default != null:
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor,  List<LedgerLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _LedgerModel():
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor,  List<LedgerLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _LedgerModel() when $default != null:
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor,_that.lines);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LedgerModel implements LedgerModel {
  const _LedgerModel({required this.accountId, required this.code, required this.name, required this.openingMinor, required this.debitMinor, required this.creditMinor, required this.closingMinor, required  List<LedgerLineModel> lines}): _lines = lines;
  factory _LedgerModel.fromJson(Map<String, dynamic> json) => _$LedgerModelFromJson(json);

@override final  String accountId;
@override final  String code;
@override final  String name;
@override final  int openingMinor;
@override final  int debitMinor;
@override final  int creditMinor;
@override final  int closingMinor;
 final  List<LedgerLineModel> _lines;
@override List<LedgerLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of LedgerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerModelCopyWith<_LedgerModel> get copyWith => __$LedgerModelCopyWithImpl<_LedgerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.closingMinor, closingMinor) || other.closingMinor == closingMinor)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,code,name,openingMinor,debitMinor,creditMinor,closingMinor,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'LedgerModel(accountId: $accountId, code: $code, name: $name, openingMinor: $openingMinor, debitMinor: $debitMinor, creditMinor: $creditMinor, closingMinor: $closingMinor, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$LedgerModelCopyWith<$Res> implements $LedgerModelCopyWith<$Res> {
  factory _$LedgerModelCopyWith(_LedgerModel value, $Res Function(_LedgerModel) _then) = __$LedgerModelCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String code, String name, int openingMinor, int debitMinor, int creditMinor, int closingMinor, List<LedgerLineModel> lines
});




}
/// @nodoc
class __$LedgerModelCopyWithImpl<$Res>
    implements _$LedgerModelCopyWith<$Res> {
  __$LedgerModelCopyWithImpl(this._self, this._then);

  final _LedgerModel _self;
  final $Res Function(_LedgerModel) _then;

/// Create a copy of LedgerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? code = null,Object? name = null,Object? openingMinor = null,Object? debitMinor = null,Object? creditMinor = null,Object? closingMinor = null,Object? lines = null,}) {
  return _then(_LedgerModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,closingMinor: null == closingMinor ? _self.closingMinor : closingMinor // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<LedgerLineModel>,
  ));
}


}


/// @nodoc
mixin _$TrialBalanceRowModel {

 String get accountId; String get code; String get name; int get openingMinor; int get debitMinor; int get creditMinor; int get closingMinor;
/// Create a copy of TrialBalanceRowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrialBalanceRowModelCopyWith<TrialBalanceRowModel> get copyWith => _$TrialBalanceRowModelCopyWithImpl<TrialBalanceRowModel>(this as TrialBalanceRowModel, _$identity);

  /// Serializes this TrialBalanceRowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrialBalanceRowModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.closingMinor, closingMinor) || other.closingMinor == closingMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,code,name,openingMinor,debitMinor,creditMinor,closingMinor);

@override
String toString() {
  return 'TrialBalanceRowModel(accountId: $accountId, code: $code, name: $name, openingMinor: $openingMinor, debitMinor: $debitMinor, creditMinor: $creditMinor, closingMinor: $closingMinor)';
}


}

/// @nodoc
abstract mixin class $TrialBalanceRowModelCopyWith<$Res>  {
  factory $TrialBalanceRowModelCopyWith(TrialBalanceRowModel value, $Res Function(TrialBalanceRowModel) _then) = _$TrialBalanceRowModelCopyWithImpl;
@useResult
$Res call({
 String accountId, String code, String name, int openingMinor, int debitMinor, int creditMinor, int closingMinor
});




}
/// @nodoc
class _$TrialBalanceRowModelCopyWithImpl<$Res>
    implements $TrialBalanceRowModelCopyWith<$Res> {
  _$TrialBalanceRowModelCopyWithImpl(this._self, this._then);

  final TrialBalanceRowModel _self;
  final $Res Function(TrialBalanceRowModel) _then;

/// Create a copy of TrialBalanceRowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? code = null,Object? name = null,Object? openingMinor = null,Object? debitMinor = null,Object? creditMinor = null,Object? closingMinor = null,}) {
  return _then(TrialBalanceRowModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,closingMinor: null == closingMinor ? _self.closingMinor : closingMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrialBalanceRowModel].
extension TrialBalanceRowModelPatterns on TrialBalanceRowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrialBalanceRowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrialBalanceRowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrialBalanceRowModel value)  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceRowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrialBalanceRowModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceRowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrialBalanceRowModel() when $default != null:
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor)  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceRowModel():
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String code,  String name,  int openingMinor,  int debitMinor,  int creditMinor,  int closingMinor)?  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceRowModel() when $default != null:
return $default(_that.accountId,_that.code,_that.name,_that.openingMinor,_that.debitMinor,_that.creditMinor,_that.closingMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrialBalanceRowModel implements TrialBalanceRowModel {
  const _TrialBalanceRowModel({required this.accountId, required this.code, required this.name, required this.openingMinor, required this.debitMinor, required this.creditMinor, required this.closingMinor});
  factory _TrialBalanceRowModel.fromJson(Map<String, dynamic> json) => _$TrialBalanceRowModelFromJson(json);

@override final  String accountId;
@override final  String code;
@override final  String name;
@override final  int openingMinor;
@override final  int debitMinor;
@override final  int creditMinor;
@override final  int closingMinor;

/// Create a copy of TrialBalanceRowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrialBalanceRowModelCopyWith<_TrialBalanceRowModel> get copyWith => __$TrialBalanceRowModelCopyWithImpl<_TrialBalanceRowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrialBalanceRowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrialBalanceRowModel&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor)&&(identical(other.closingMinor, closingMinor) || other.closingMinor == closingMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,code,name,openingMinor,debitMinor,creditMinor,closingMinor);

@override
String toString() {
  return 'TrialBalanceRowModel(accountId: $accountId, code: $code, name: $name, openingMinor: $openingMinor, debitMinor: $debitMinor, creditMinor: $creditMinor, closingMinor: $closingMinor)';
}


}

/// @nodoc
abstract mixin class _$TrialBalanceRowModelCopyWith<$Res> implements $TrialBalanceRowModelCopyWith<$Res> {
  factory _$TrialBalanceRowModelCopyWith(_TrialBalanceRowModel value, $Res Function(_TrialBalanceRowModel) _then) = __$TrialBalanceRowModelCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String code, String name, int openingMinor, int debitMinor, int creditMinor, int closingMinor
});




}
/// @nodoc
class __$TrialBalanceRowModelCopyWithImpl<$Res>
    implements _$TrialBalanceRowModelCopyWith<$Res> {
  __$TrialBalanceRowModelCopyWithImpl(this._self, this._then);

  final _TrialBalanceRowModel _self;
  final $Res Function(_TrialBalanceRowModel) _then;

/// Create a copy of TrialBalanceRowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? code = null,Object? name = null,Object? openingMinor = null,Object? debitMinor = null,Object? creditMinor = null,Object? closingMinor = null,}) {
  return _then(_TrialBalanceRowModel(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,closingMinor: null == closingMinor ? _self.closingMinor : closingMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TrialBalanceModel {

 List<TrialBalanceRowModel> get rows; int get totalDebitMinor; int get totalCreditMinor;
/// Create a copy of TrialBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrialBalanceModelCopyWith<TrialBalanceModel> get copyWith => _$TrialBalanceModelCopyWithImpl<TrialBalanceModel>(this as TrialBalanceModel, _$identity);

  /// Serializes this TrialBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrialBalanceModel&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.totalDebitMinor, totalDebitMinor) || other.totalDebitMinor == totalDebitMinor)&&(identical(other.totalCreditMinor, totalCreditMinor) || other.totalCreditMinor == totalCreditMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rows),totalDebitMinor,totalCreditMinor);

@override
String toString() {
  return 'TrialBalanceModel(rows: $rows, totalDebitMinor: $totalDebitMinor, totalCreditMinor: $totalCreditMinor)';
}


}

/// @nodoc
abstract mixin class $TrialBalanceModelCopyWith<$Res>  {
  factory $TrialBalanceModelCopyWith(TrialBalanceModel value, $Res Function(TrialBalanceModel) _then) = _$TrialBalanceModelCopyWithImpl;
@useResult
$Res call({
 List<TrialBalanceRowModel> rows, int totalDebitMinor, int totalCreditMinor
});




}
/// @nodoc
class _$TrialBalanceModelCopyWithImpl<$Res>
    implements $TrialBalanceModelCopyWith<$Res> {
  _$TrialBalanceModelCopyWithImpl(this._self, this._then);

  final TrialBalanceModel _self;
  final $Res Function(TrialBalanceModel) _then;

/// Create a copy of TrialBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? totalDebitMinor = null,Object? totalCreditMinor = null,}) {
  return _then(TrialBalanceModel(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<TrialBalanceRowModel>,totalDebitMinor: null == totalDebitMinor ? _self.totalDebitMinor : totalDebitMinor // ignore: cast_nullable_to_non_nullable
as int,totalCreditMinor: null == totalCreditMinor ? _self.totalCreditMinor : totalCreditMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrialBalanceModel].
extension TrialBalanceModelPatterns on TrialBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrialBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrialBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrialBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrialBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TrialBalanceRowModel> rows,  int totalDebitMinor,  int totalCreditMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrialBalanceModel() when $default != null:
return $default(_that.rows,_that.totalDebitMinor,_that.totalCreditMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TrialBalanceRowModel> rows,  int totalDebitMinor,  int totalCreditMinor)  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceModel():
return $default(_that.rows,_that.totalDebitMinor,_that.totalCreditMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TrialBalanceRowModel> rows,  int totalDebitMinor,  int totalCreditMinor)?  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceModel() when $default != null:
return $default(_that.rows,_that.totalDebitMinor,_that.totalCreditMinor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrialBalanceModel implements TrialBalanceModel {
  const _TrialBalanceModel({required  List<TrialBalanceRowModel> rows, required this.totalDebitMinor, required this.totalCreditMinor}): _rows = rows;
  factory _TrialBalanceModel.fromJson(Map<String, dynamic> json) => _$TrialBalanceModelFromJson(json);

 final  List<TrialBalanceRowModel> _rows;
@override List<TrialBalanceRowModel> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  int totalDebitMinor;
@override final  int totalCreditMinor;

/// Create a copy of TrialBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrialBalanceModelCopyWith<_TrialBalanceModel> get copyWith => __$TrialBalanceModelCopyWithImpl<_TrialBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrialBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrialBalanceModel&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.totalDebitMinor, totalDebitMinor) || other.totalDebitMinor == totalDebitMinor)&&(identical(other.totalCreditMinor, totalCreditMinor) || other.totalCreditMinor == totalCreditMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),totalDebitMinor,totalCreditMinor);

@override
String toString() {
  return 'TrialBalanceModel(rows: $rows, totalDebitMinor: $totalDebitMinor, totalCreditMinor: $totalCreditMinor)';
}


}

/// @nodoc
abstract mixin class _$TrialBalanceModelCopyWith<$Res> implements $TrialBalanceModelCopyWith<$Res> {
  factory _$TrialBalanceModelCopyWith(_TrialBalanceModel value, $Res Function(_TrialBalanceModel) _then) = __$TrialBalanceModelCopyWithImpl;
@override @useResult
$Res call({
 List<TrialBalanceRowModel> rows, int totalDebitMinor, int totalCreditMinor
});




}
/// @nodoc
class __$TrialBalanceModelCopyWithImpl<$Res>
    implements _$TrialBalanceModelCopyWith<$Res> {
  __$TrialBalanceModelCopyWithImpl(this._self, this._then);

  final _TrialBalanceModel _self;
  final $Res Function(_TrialBalanceModel) _then;

/// Create a copy of TrialBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? totalDebitMinor = null,Object? totalCreditMinor = null,}) {
  return _then(_TrialBalanceModel(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<TrialBalanceRowModel>,totalDebitMinor: null == totalDebitMinor ? _self.totalDebitMinor : totalDebitMinor // ignore: cast_nullable_to_non_nullable
as int,totalCreditMinor: null == totalCreditMinor ? _self.totalCreditMinor : totalCreditMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BillingEventModel {

 BillingEventType get event; String get referenceId; int get amountMinor;@DateOnlyConverter() DateTime get occurredOn;/// Meio de pagamento (`cash` → caixa; restantes → depósitos à ordem).
 String? get method; String? get description;
/// Create a copy of BillingEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillingEventModelCopyWith<BillingEventModel> get copyWith => _$BillingEventModelCopyWithImpl<BillingEventModel>(this as BillingEventModel, _$identity);

  /// Serializes this BillingEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillingEventModel&&(identical(other.event, event) || other.event == event)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.method, method) || other.method == method)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,referenceId,amountMinor,occurredOn,method,description);

@override
String toString() {
  return 'BillingEventModel(event: $event, referenceId: $referenceId, amountMinor: $amountMinor, occurredOn: $occurredOn, method: $method, description: $description)';
}


}

/// @nodoc
abstract mixin class $BillingEventModelCopyWith<$Res>  {
  factory $BillingEventModelCopyWith(BillingEventModel value, $Res Function(BillingEventModel) _then) = _$BillingEventModelCopyWithImpl;
@useResult
$Res call({
 BillingEventType event, String referenceId, int amountMinor,@DateOnlyConverter() DateTime occurredOn, String? method, String? description
});




}
/// @nodoc
class _$BillingEventModelCopyWithImpl<$Res>
    implements $BillingEventModelCopyWith<$Res> {
  _$BillingEventModelCopyWithImpl(this._self, this._then);

  final BillingEventModel _self;
  final $Res Function(BillingEventModel) _then;

/// Create a copy of BillingEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? referenceId = null,Object? amountMinor = null,Object? occurredOn = null,Object? method = freezed,Object? description = freezed,}) {
  return _then(BillingEventModel(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as BillingEventType,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BillingEventModel].
extension BillingEventModelPatterns on BillingEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillingEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillingEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillingEventModel value)  $default,){
final _that = this;
switch (_that) {
case _BillingEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillingEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _BillingEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BillingEventType event,  String referenceId,  int amountMinor, @DateOnlyConverter()  DateTime occurredOn,  String? method,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillingEventModel() when $default != null:
return $default(_that.event,_that.referenceId,_that.amountMinor,_that.occurredOn,_that.method,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BillingEventType event,  String referenceId,  int amountMinor, @DateOnlyConverter()  DateTime occurredOn,  String? method,  String? description)  $default,) {final _that = this;
switch (_that) {
case _BillingEventModel():
return $default(_that.event,_that.referenceId,_that.amountMinor,_that.occurredOn,_that.method,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BillingEventType event,  String referenceId,  int amountMinor, @DateOnlyConverter()  DateTime occurredOn,  String? method,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _BillingEventModel() when $default != null:
return $default(_that.event,_that.referenceId,_that.amountMinor,_that.occurredOn,_that.method,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillingEventModel implements BillingEventModel {
  const _BillingEventModel({required this.event, required this.referenceId, required this.amountMinor, @DateOnlyConverter() required this.occurredOn, this.method, this.description});
  factory _BillingEventModel.fromJson(Map<String, dynamic> json) => _$BillingEventModelFromJson(json);

@override final  BillingEventType event;
@override final  String referenceId;
@override final  int amountMinor;
@override@DateOnlyConverter() final  DateTime occurredOn;
/// Meio de pagamento (`cash` → caixa; restantes → depósitos à ordem).
@override final  String? method;
@override final  String? description;

/// Create a copy of BillingEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillingEventModelCopyWith<_BillingEventModel> get copyWith => __$BillingEventModelCopyWithImpl<_BillingEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillingEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillingEventModel&&(identical(other.event, event) || other.event == event)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.method, method) || other.method == method)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,referenceId,amountMinor,occurredOn,method,description);

@override
String toString() {
  return 'BillingEventModel(event: $event, referenceId: $referenceId, amountMinor: $amountMinor, occurredOn: $occurredOn, method: $method, description: $description)';
}


}

/// @nodoc
abstract mixin class _$BillingEventModelCopyWith<$Res> implements $BillingEventModelCopyWith<$Res> {
  factory _$BillingEventModelCopyWith(_BillingEventModel value, $Res Function(_BillingEventModel) _then) = __$BillingEventModelCopyWithImpl;
@override @useResult
$Res call({
 BillingEventType event, String referenceId, int amountMinor,@DateOnlyConverter() DateTime occurredOn, String? method, String? description
});




}
/// @nodoc
class __$BillingEventModelCopyWithImpl<$Res>
    implements _$BillingEventModelCopyWith<$Res> {
  __$BillingEventModelCopyWithImpl(this._self, this._then);

  final _BillingEventModel _self;
  final $Res Function(_BillingEventModel) _then;

/// Create a copy of BillingEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? referenceId = null,Object? amountMinor = null,Object? occurredOn = null,Object? method = freezed,Object? description = freezed,}) {
  return _then(_BillingEventModel(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as BillingEventType,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OpenItemModel {

 String get id; OpenItemKind get kind; String get party; String get description; int get amountMinor; int get paidMinor;@DateOnlyConverter() DateTime get issueDate;@DateOnlyConverter() DateTime get dueDate; OpenItemStatus get status;/// Contrapartida: despesa (a pagar) ou proveito (a receber).
 String get counterAccountId; String? get entryId;
/// Create a copy of OpenItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenItemModelCopyWith<OpenItemModel> get copyWith => _$OpenItemModelCopyWithImpl<OpenItemModel>(this as OpenItemModel, _$identity);

  /// Serializes this OpenItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.party, party) || other.party == party)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.counterAccountId, counterAccountId) || other.counterAccountId == counterAccountId)&&(identical(other.entryId, entryId) || other.entryId == entryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,party,description,amountMinor,paidMinor,issueDate,dueDate,status,counterAccountId,entryId);

@override
String toString() {
  return 'OpenItemModel(id: $id, kind: $kind, party: $party, description: $description, amountMinor: $amountMinor, paidMinor: $paidMinor, issueDate: $issueDate, dueDate: $dueDate, status: $status, counterAccountId: $counterAccountId, entryId: $entryId)';
}


}

/// @nodoc
abstract mixin class $OpenItemModelCopyWith<$Res>  {
  factory $OpenItemModelCopyWith(OpenItemModel value, $Res Function(OpenItemModel) _then) = _$OpenItemModelCopyWithImpl;
@useResult
$Res call({
 String id, OpenItemKind kind, String party, String description, int amountMinor, int paidMinor,@DateOnlyConverter() DateTime issueDate,@DateOnlyConverter() DateTime dueDate, OpenItemStatus status, String counterAccountId, String? entryId
});




}
/// @nodoc
class _$OpenItemModelCopyWithImpl<$Res>
    implements $OpenItemModelCopyWith<$Res> {
  _$OpenItemModelCopyWithImpl(this._self, this._then);

  final OpenItemModel _self;
  final $Res Function(OpenItemModel) _then;

/// Create a copy of OpenItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? party = null,Object? description = null,Object? amountMinor = null,Object? paidMinor = null,Object? issueDate = null,Object? dueDate = null,Object? status = null,Object? counterAccountId = null,Object? entryId = freezed,}) {
  return _then(OpenItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as OpenItemKind,party: null == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OpenItemStatus,counterAccountId: null == counterAccountId ? _self.counterAccountId : counterAccountId // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenItemModel].
extension OpenItemModelPatterns on OpenItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenItemModel value)  $default,){
final _that = this;
switch (_that) {
case _OpenItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpenItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  OpenItemKind kind,  String party,  String description,  int amountMinor,  int paidMinor, @DateOnlyConverter()  DateTime issueDate, @DateOnlyConverter()  DateTime dueDate,  OpenItemStatus status,  String counterAccountId,  String? entryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenItemModel() when $default != null:
return $default(_that.id,_that.kind,_that.party,_that.description,_that.amountMinor,_that.paidMinor,_that.issueDate,_that.dueDate,_that.status,_that.counterAccountId,_that.entryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  OpenItemKind kind,  String party,  String description,  int amountMinor,  int paidMinor, @DateOnlyConverter()  DateTime issueDate, @DateOnlyConverter()  DateTime dueDate,  OpenItemStatus status,  String counterAccountId,  String? entryId)  $default,) {final _that = this;
switch (_that) {
case _OpenItemModel():
return $default(_that.id,_that.kind,_that.party,_that.description,_that.amountMinor,_that.paidMinor,_that.issueDate,_that.dueDate,_that.status,_that.counterAccountId,_that.entryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  OpenItemKind kind,  String party,  String description,  int amountMinor,  int paidMinor, @DateOnlyConverter()  DateTime issueDate, @DateOnlyConverter()  DateTime dueDate,  OpenItemStatus status,  String counterAccountId,  String? entryId)?  $default,) {final _that = this;
switch (_that) {
case _OpenItemModel() when $default != null:
return $default(_that.id,_that.kind,_that.party,_that.description,_that.amountMinor,_that.paidMinor,_that.issueDate,_that.dueDate,_that.status,_that.counterAccountId,_that.entryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenItemModel implements OpenItemModel {
  const _OpenItemModel({required this.id, required this.kind, required this.party, required this.description, required this.amountMinor, this.paidMinor = 0, @DateOnlyConverter() required this.issueDate, @DateOnlyConverter() required this.dueDate, this.status = OpenItemStatus.open, required this.counterAccountId, this.entryId});
  factory _OpenItemModel.fromJson(Map<String, dynamic> json) => _$OpenItemModelFromJson(json);

@override final  String id;
@override final  OpenItemKind kind;
@override final  String party;
@override final  String description;
@override final  int amountMinor;
@override@JsonKey() final  int paidMinor;
@override@DateOnlyConverter() final  DateTime issueDate;
@override@DateOnlyConverter() final  DateTime dueDate;
@override@JsonKey() final  OpenItemStatus status;
/// Contrapartida: despesa (a pagar) ou proveito (a receber).
@override final  String counterAccountId;
@override final  String? entryId;

/// Create a copy of OpenItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenItemModelCopyWith<_OpenItemModel> get copyWith => __$OpenItemModelCopyWithImpl<_OpenItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.party, party) || other.party == party)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.counterAccountId, counterAccountId) || other.counterAccountId == counterAccountId)&&(identical(other.entryId, entryId) || other.entryId == entryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,party,description,amountMinor,paidMinor,issueDate,dueDate,status,counterAccountId,entryId);

@override
String toString() {
  return 'OpenItemModel(id: $id, kind: $kind, party: $party, description: $description, amountMinor: $amountMinor, paidMinor: $paidMinor, issueDate: $issueDate, dueDate: $dueDate, status: $status, counterAccountId: $counterAccountId, entryId: $entryId)';
}


}

/// @nodoc
abstract mixin class _$OpenItemModelCopyWith<$Res> implements $OpenItemModelCopyWith<$Res> {
  factory _$OpenItemModelCopyWith(_OpenItemModel value, $Res Function(_OpenItemModel) _then) = __$OpenItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, OpenItemKind kind, String party, String description, int amountMinor, int paidMinor,@DateOnlyConverter() DateTime issueDate,@DateOnlyConverter() DateTime dueDate, OpenItemStatus status, String counterAccountId, String? entryId
});




}
/// @nodoc
class __$OpenItemModelCopyWithImpl<$Res>
    implements _$OpenItemModelCopyWith<$Res> {
  __$OpenItemModelCopyWithImpl(this._self, this._then);

  final _OpenItemModel _self;
  final $Res Function(_OpenItemModel) _then;

/// Create a copy of OpenItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? party = null,Object? description = null,Object? amountMinor = null,Object? paidMinor = null,Object? issueDate = null,Object? dueDate = null,Object? status = null,Object? counterAccountId = null,Object? entryId = freezed,}) {
  return _then(_OpenItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as OpenItemKind,party: null == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OpenItemStatus,counterAccountId: null == counterAccountId ? _self.counterAccountId : counterAccountId // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
