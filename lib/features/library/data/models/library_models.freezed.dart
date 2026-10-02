// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookModel {

 String get id;/// ISBN normalizado (único).
 String get isbn; String get title; String get author; String get category; String? get publisher; int? get year;/// Calculados pelo servidor.
 int get totalCopies; int get availableCopies;
/// Create a copy of BookModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookModelCopyWith<BookModel> get copyWith => _$BookModelCopyWithImpl<BookModel>(this as BookModel, _$identity);

  /// Serializes this BookModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookModel&&(identical(other.id, id) || other.id == id)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalCopies, totalCopies) || other.totalCopies == totalCopies)&&(identical(other.availableCopies, availableCopies) || other.availableCopies == availableCopies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isbn,title,author,category,publisher,year,totalCopies,availableCopies);

@override
String toString() {
  return 'BookModel(id: $id, isbn: $isbn, title: $title, author: $author, category: $category, publisher: $publisher, year: $year, totalCopies: $totalCopies, availableCopies: $availableCopies)';
}


}

/// @nodoc
abstract mixin class $BookModelCopyWith<$Res>  {
  factory $BookModelCopyWith(BookModel value, $Res Function(BookModel) _then) = _$BookModelCopyWithImpl;
@useResult
$Res call({
 String id, String isbn, String title, String author, String category, String? publisher, int? year, int totalCopies, int availableCopies
});




}
/// @nodoc
class _$BookModelCopyWithImpl<$Res>
    implements $BookModelCopyWith<$Res> {
  _$BookModelCopyWithImpl(this._self, this._then);

  final BookModel _self;
  final $Res Function(BookModel) _then;

/// Create a copy of BookModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isbn = null,Object? title = null,Object? author = null,Object? category = null,Object? publisher = freezed,Object? year = freezed,Object? totalCopies = null,Object? availableCopies = null,}) {
  return _then(BookModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isbn: null == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,totalCopies: null == totalCopies ? _self.totalCopies : totalCopies // ignore: cast_nullable_to_non_nullable
as int,availableCopies: null == availableCopies ? _self.availableCopies : availableCopies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookModel].
extension BookModelPatterns on BookModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookModel value)  $default,){
final _that = this;
switch (_that) {
case _BookModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String isbn,  String title,  String author,  String category,  String? publisher,  int? year,  int totalCopies,  int availableCopies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookModel() when $default != null:
return $default(_that.id,_that.isbn,_that.title,_that.author,_that.category,_that.publisher,_that.year,_that.totalCopies,_that.availableCopies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String isbn,  String title,  String author,  String category,  String? publisher,  int? year,  int totalCopies,  int availableCopies)  $default,) {final _that = this;
switch (_that) {
case _BookModel():
return $default(_that.id,_that.isbn,_that.title,_that.author,_that.category,_that.publisher,_that.year,_that.totalCopies,_that.availableCopies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String isbn,  String title,  String author,  String category,  String? publisher,  int? year,  int totalCopies,  int availableCopies)?  $default,) {final _that = this;
switch (_that) {
case _BookModel() when $default != null:
return $default(_that.id,_that.isbn,_that.title,_that.author,_that.category,_that.publisher,_that.year,_that.totalCopies,_that.availableCopies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookModel implements BookModel {
  const _BookModel({required this.id, required this.isbn, required this.title, required this.author, required this.category, this.publisher, this.year, this.totalCopies = 0, this.availableCopies = 0});
  factory _BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);

@override final  String id;
/// ISBN normalizado (único).
@override final  String isbn;
@override final  String title;
@override final  String author;
@override final  String category;
@override final  String? publisher;
@override final  int? year;
/// Calculados pelo servidor.
@override@JsonKey() final  int totalCopies;
@override@JsonKey() final  int availableCopies;

/// Create a copy of BookModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookModelCopyWith<_BookModel> get copyWith => __$BookModelCopyWithImpl<_BookModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookModel&&(identical(other.id, id) || other.id == id)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalCopies, totalCopies) || other.totalCopies == totalCopies)&&(identical(other.availableCopies, availableCopies) || other.availableCopies == availableCopies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isbn,title,author,category,publisher,year,totalCopies,availableCopies);

@override
String toString() {
  return 'BookModel(id: $id, isbn: $isbn, title: $title, author: $author, category: $category, publisher: $publisher, year: $year, totalCopies: $totalCopies, availableCopies: $availableCopies)';
}


}

/// @nodoc
abstract mixin class _$BookModelCopyWith<$Res> implements $BookModelCopyWith<$Res> {
  factory _$BookModelCopyWith(_BookModel value, $Res Function(_BookModel) _then) = __$BookModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String isbn, String title, String author, String category, String? publisher, int? year, int totalCopies, int availableCopies
});




}
/// @nodoc
class __$BookModelCopyWithImpl<$Res>
    implements _$BookModelCopyWith<$Res> {
  __$BookModelCopyWithImpl(this._self, this._then);

  final _BookModel _self;
  final $Res Function(_BookModel) _then;

/// Create a copy of BookModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isbn = null,Object? title = null,Object? author = null,Object? category = null,Object? publisher = freezed,Object? year = freezed,Object? totalCopies = null,Object? availableCopies = null,}) {
  return _then(_BookModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isbn: null == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,totalCopies: null == totalCopies ? _self.totalCopies : totalCopies // ignore: cast_nullable_to_non_nullable
as int,availableCopies: null == availableCopies ? _self.availableCopies : availableCopies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CopyModel {

 String get id; String get bookId; String get barcode; CopyStatus get status;
/// Create a copy of CopyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyModelCopyWith<CopyModel> get copyWith => _$CopyModelCopyWithImpl<CopyModel>(this as CopyModel, _$identity);

  /// Serializes this CopyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,barcode,status);

@override
String toString() {
  return 'CopyModel(id: $id, bookId: $bookId, barcode: $barcode, status: $status)';
}


}

/// @nodoc
abstract mixin class $CopyModelCopyWith<$Res>  {
  factory $CopyModelCopyWith(CopyModel value, $Res Function(CopyModel) _then) = _$CopyModelCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String barcode, CopyStatus status
});




}
/// @nodoc
class _$CopyModelCopyWithImpl<$Res>
    implements $CopyModelCopyWith<$Res> {
  _$CopyModelCopyWithImpl(this._self, this._then);

  final CopyModel _self;
  final $Res Function(CopyModel) _then;

/// Create a copy of CopyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? barcode = null,Object? status = null,}) {
  return _then(CopyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CopyStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CopyModel].
extension CopyModelPatterns on CopyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CopyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CopyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CopyModel value)  $default,){
final _that = this;
switch (_that) {
case _CopyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CopyModel value)?  $default,){
final _that = this;
switch (_that) {
case _CopyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String barcode,  CopyStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CopyModel() when $default != null:
return $default(_that.id,_that.bookId,_that.barcode,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String barcode,  CopyStatus status)  $default,) {final _that = this;
switch (_that) {
case _CopyModel():
return $default(_that.id,_that.bookId,_that.barcode,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String barcode,  CopyStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CopyModel() when $default != null:
return $default(_that.id,_that.bookId,_that.barcode,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CopyModel implements CopyModel {
  const _CopyModel({required this.id, required this.bookId, required this.barcode, this.status = CopyStatus.available});
  factory _CopyModel.fromJson(Map<String, dynamic> json) => _$CopyModelFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  String barcode;
@override@JsonKey() final  CopyStatus status;

/// Create a copy of CopyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CopyModelCopyWith<_CopyModel> get copyWith => __$CopyModelCopyWithImpl<_CopyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CopyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CopyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,barcode,status);

@override
String toString() {
  return 'CopyModel(id: $id, bookId: $bookId, barcode: $barcode, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CopyModelCopyWith<$Res> implements $CopyModelCopyWith<$Res> {
  factory _$CopyModelCopyWith(_CopyModel value, $Res Function(_CopyModel) _then) = __$CopyModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String barcode, CopyStatus status
});




}
/// @nodoc
class __$CopyModelCopyWithImpl<$Res>
    implements _$CopyModelCopyWith<$Res> {
  __$CopyModelCopyWithImpl(this._self, this._then);

  final _CopyModel _self;
  final $Res Function(_CopyModel) _then;

/// Create a copy of CopyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? barcode = null,Object? status = null,}) {
  return _then(_CopyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CopyStatus,
  ));
}


}


/// @nodoc
mixin _$LoanModel {

 String get id; String get copyId; String get bookTitle; String get barcode; String get borrowerId; String get borrowerName;@UtcDateTimeConverter() DateTime get loanedAt;@UtcDateTimeConverter() DateTime get dueAt;@UtcDateTimeConverter() DateTime? get returnedAt;/// `overdue` é calculado pelo servidor (activo e fora de prazo).
 LoanStatus get status;/// Multa gerada na devolução, se houve atraso.
 int get fineCents;
/// Create a copy of LoanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanModelCopyWith<LoanModel> get copyWith => _$LoanModelCopyWithImpl<LoanModel>(this as LoanModel, _$identity);

  /// Serializes this LoanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.copyId, copyId) || other.copyId == copyId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanedAt, loanedAt) || other.loanedAt == loanedAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.fineCents, fineCents) || other.fineCents == fineCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,copyId,bookTitle,barcode,borrowerId,borrowerName,loanedAt,dueAt,returnedAt,status,fineCents);

@override
String toString() {
  return 'LoanModel(id: $id, copyId: $copyId, bookTitle: $bookTitle, barcode: $barcode, borrowerId: $borrowerId, borrowerName: $borrowerName, loanedAt: $loanedAt, dueAt: $dueAt, returnedAt: $returnedAt, status: $status, fineCents: $fineCents)';
}


}

/// @nodoc
abstract mixin class $LoanModelCopyWith<$Res>  {
  factory $LoanModelCopyWith(LoanModel value, $Res Function(LoanModel) _then) = _$LoanModelCopyWithImpl;
@useResult
$Res call({
 String id, String copyId, String bookTitle, String barcode, String borrowerId, String borrowerName,@UtcDateTimeConverter() DateTime loanedAt,@UtcDateTimeConverter() DateTime dueAt,@UtcDateTimeConverter() DateTime? returnedAt, LoanStatus status, int fineCents
});




}
/// @nodoc
class _$LoanModelCopyWithImpl<$Res>
    implements $LoanModelCopyWith<$Res> {
  _$LoanModelCopyWithImpl(this._self, this._then);

  final LoanModel _self;
  final $Res Function(LoanModel) _then;

/// Create a copy of LoanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? copyId = null,Object? bookTitle = null,Object? barcode = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanedAt = null,Object? dueAt = null,Object? returnedAt = freezed,Object? status = null,Object? fineCents = null,}) {
  return _then(LoanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,copyId: null == copyId ? _self.copyId : copyId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanedAt: null == loanedAt ? _self.loanedAt : loanedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoanStatus,fineCents: null == fineCents ? _self.fineCents : fineCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanModel].
extension LoanModelPatterns on LoanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanModel value)  $default,){
final _that = this;
switch (_that) {
case _LoanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanModel value)?  $default,){
final _that = this;
switch (_that) {
case _LoanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String copyId,  String bookTitle,  String barcode,  String borrowerId,  String borrowerName, @UtcDateTimeConverter()  DateTime loanedAt, @UtcDateTimeConverter()  DateTime dueAt, @UtcDateTimeConverter()  DateTime? returnedAt,  LoanStatus status,  int fineCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanModel() when $default != null:
return $default(_that.id,_that.copyId,_that.bookTitle,_that.barcode,_that.borrowerId,_that.borrowerName,_that.loanedAt,_that.dueAt,_that.returnedAt,_that.status,_that.fineCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String copyId,  String bookTitle,  String barcode,  String borrowerId,  String borrowerName, @UtcDateTimeConverter()  DateTime loanedAt, @UtcDateTimeConverter()  DateTime dueAt, @UtcDateTimeConverter()  DateTime? returnedAt,  LoanStatus status,  int fineCents)  $default,) {final _that = this;
switch (_that) {
case _LoanModel():
return $default(_that.id,_that.copyId,_that.bookTitle,_that.barcode,_that.borrowerId,_that.borrowerName,_that.loanedAt,_that.dueAt,_that.returnedAt,_that.status,_that.fineCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String copyId,  String bookTitle,  String barcode,  String borrowerId,  String borrowerName, @UtcDateTimeConverter()  DateTime loanedAt, @UtcDateTimeConverter()  DateTime dueAt, @UtcDateTimeConverter()  DateTime? returnedAt,  LoanStatus status,  int fineCents)?  $default,) {final _that = this;
switch (_that) {
case _LoanModel() when $default != null:
return $default(_that.id,_that.copyId,_that.bookTitle,_that.barcode,_that.borrowerId,_that.borrowerName,_that.loanedAt,_that.dueAt,_that.returnedAt,_that.status,_that.fineCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanModel implements LoanModel {
  const _LoanModel({required this.id, required this.copyId, required this.bookTitle, required this.barcode, required this.borrowerId, required this.borrowerName, @UtcDateTimeConverter() required this.loanedAt, @UtcDateTimeConverter() required this.dueAt, @UtcDateTimeConverter() this.returnedAt, this.status = LoanStatus.active, this.fineCents = 0});
  factory _LoanModel.fromJson(Map<String, dynamic> json) => _$LoanModelFromJson(json);

@override final  String id;
@override final  String copyId;
@override final  String bookTitle;
@override final  String barcode;
@override final  String borrowerId;
@override final  String borrowerName;
@override@UtcDateTimeConverter() final  DateTime loanedAt;
@override@UtcDateTimeConverter() final  DateTime dueAt;
@override@UtcDateTimeConverter() final  DateTime? returnedAt;
/// `overdue` é calculado pelo servidor (activo e fora de prazo).
@override@JsonKey() final  LoanStatus status;
/// Multa gerada na devolução, se houve atraso.
@override@JsonKey() final  int fineCents;

/// Create a copy of LoanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanModelCopyWith<_LoanModel> get copyWith => __$LoanModelCopyWithImpl<_LoanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.copyId, copyId) || other.copyId == copyId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanedAt, loanedAt) || other.loanedAt == loanedAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.fineCents, fineCents) || other.fineCents == fineCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,copyId,bookTitle,barcode,borrowerId,borrowerName,loanedAt,dueAt,returnedAt,status,fineCents);

@override
String toString() {
  return 'LoanModel(id: $id, copyId: $copyId, bookTitle: $bookTitle, barcode: $barcode, borrowerId: $borrowerId, borrowerName: $borrowerName, loanedAt: $loanedAt, dueAt: $dueAt, returnedAt: $returnedAt, status: $status, fineCents: $fineCents)';
}


}

/// @nodoc
abstract mixin class _$LoanModelCopyWith<$Res> implements $LoanModelCopyWith<$Res> {
  factory _$LoanModelCopyWith(_LoanModel value, $Res Function(_LoanModel) _then) = __$LoanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String copyId, String bookTitle, String barcode, String borrowerId, String borrowerName,@UtcDateTimeConverter() DateTime loanedAt,@UtcDateTimeConverter() DateTime dueAt,@UtcDateTimeConverter() DateTime? returnedAt, LoanStatus status, int fineCents
});




}
/// @nodoc
class __$LoanModelCopyWithImpl<$Res>
    implements _$LoanModelCopyWith<$Res> {
  __$LoanModelCopyWithImpl(this._self, this._then);

  final _LoanModel _self;
  final $Res Function(_LoanModel) _then;

/// Create a copy of LoanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? copyId = null,Object? bookTitle = null,Object? barcode = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanedAt = null,Object? dueAt = null,Object? returnedAt = freezed,Object? status = null,Object? fineCents = null,}) {
  return _then(_LoanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,copyId: null == copyId ? _self.copyId : copyId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanedAt: null == loanedAt ? _self.loanedAt : loanedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoanStatus,fineCents: null == fineCents ? _self.fineCents : fineCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FineModel {

 String get id; String get loanId; String get borrowerId; String get borrowerName; String get bookTitle; int get daysLate;/// Menor unidade (Kz × 100).
 int get amountCents; FineStatus get status;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime? get paidAt;
/// Create a copy of FineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FineModelCopyWith<FineModel> get copyWith => _$FineModelCopyWithImpl<FineModel>(this as FineModel, _$identity);

  /// Serializes this FineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanId,borrowerId,borrowerName,bookTitle,daysLate,amountCents,status,createdAt,paidAt);

@override
String toString() {
  return 'FineModel(id: $id, loanId: $loanId, borrowerId: $borrowerId, borrowerName: $borrowerName, bookTitle: $bookTitle, daysLate: $daysLate, amountCents: $amountCents, status: $status, createdAt: $createdAt, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $FineModelCopyWith<$Res>  {
  factory $FineModelCopyWith(FineModel value, $Res Function(FineModel) _then) = _$FineModelCopyWithImpl;
@useResult
$Res call({
 String id, String loanId, String borrowerId, String borrowerName, String bookTitle, int daysLate, int amountCents, FineStatus status,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime? paidAt
});




}
/// @nodoc
class _$FineModelCopyWithImpl<$Res>
    implements $FineModelCopyWith<$Res> {
  _$FineModelCopyWithImpl(this._self, this._then);

  final FineModel _self;
  final $Res Function(FineModel) _then;

/// Create a copy of FineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loanId = null,Object? borrowerId = null,Object? borrowerName = null,Object? bookTitle = null,Object? daysLate = null,Object? amountCents = null,Object? status = null,Object? createdAt = null,Object? paidAt = freezed,}) {
  return _then(FineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FineStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FineModel].
extension FineModelPatterns on FineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FineModel value)  $default,){
final _that = this;
switch (_that) {
case _FineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FineModel value)?  $default,){
final _that = this;
switch (_that) {
case _FineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String loanId,  String borrowerId,  String borrowerName,  String bookTitle,  int daysLate,  int amountCents,  FineStatus status, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FineModel() when $default != null:
return $default(_that.id,_that.loanId,_that.borrowerId,_that.borrowerName,_that.bookTitle,_that.daysLate,_that.amountCents,_that.status,_that.createdAt,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String loanId,  String borrowerId,  String borrowerName,  String bookTitle,  int daysLate,  int amountCents,  FineStatus status, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _FineModel():
return $default(_that.id,_that.loanId,_that.borrowerId,_that.borrowerName,_that.bookTitle,_that.daysLate,_that.amountCents,_that.status,_that.createdAt,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String loanId,  String borrowerId,  String borrowerName,  String bookTitle,  int daysLate,  int amountCents,  FineStatus status, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _FineModel() when $default != null:
return $default(_that.id,_that.loanId,_that.borrowerId,_that.borrowerName,_that.bookTitle,_that.daysLate,_that.amountCents,_that.status,_that.createdAt,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FineModel implements FineModel {
  const _FineModel({required this.id, required this.loanId, required this.borrowerId, required this.borrowerName, required this.bookTitle, required this.daysLate, required this.amountCents, this.status = FineStatus.pending, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() this.paidAt});
  factory _FineModel.fromJson(Map<String, dynamic> json) => _$FineModelFromJson(json);

@override final  String id;
@override final  String loanId;
@override final  String borrowerId;
@override final  String borrowerName;
@override final  String bookTitle;
@override final  int daysLate;
/// Menor unidade (Kz × 100).
@override final  int amountCents;
@override@JsonKey() final  FineStatus status;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime? paidAt;

/// Create a copy of FineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FineModelCopyWith<_FineModel> get copyWith => __$FineModelCopyWithImpl<_FineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanId,borrowerId,borrowerName,bookTitle,daysLate,amountCents,status,createdAt,paidAt);

@override
String toString() {
  return 'FineModel(id: $id, loanId: $loanId, borrowerId: $borrowerId, borrowerName: $borrowerName, bookTitle: $bookTitle, daysLate: $daysLate, amountCents: $amountCents, status: $status, createdAt: $createdAt, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$FineModelCopyWith<$Res> implements $FineModelCopyWith<$Res> {
  factory _$FineModelCopyWith(_FineModel value, $Res Function(_FineModel) _then) = __$FineModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String loanId, String borrowerId, String borrowerName, String bookTitle, int daysLate, int amountCents, FineStatus status,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime? paidAt
});




}
/// @nodoc
class __$FineModelCopyWithImpl<$Res>
    implements _$FineModelCopyWith<$Res> {
  __$FineModelCopyWithImpl(this._self, this._then);

  final _FineModel _self;
  final $Res Function(_FineModel) _then;

/// Create a copy of FineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loanId = null,Object? borrowerId = null,Object? borrowerName = null,Object? bookTitle = null,Object? daysLate = null,Object? amountCents = null,Object? status = null,Object? createdAt = null,Object? paidAt = freezed,}) {
  return _then(_FineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FineStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ReservationModel {

 String get id; String get bookId; String get bookTitle; String get borrowerId; String get borrowerName; ReservationStatus get status;@UtcDateTimeConverter() DateTime get createdAt;
/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationModelCopyWith<ReservationModel> get copyWith => _$ReservationModelCopyWithImpl<ReservationModel>(this as ReservationModel, _$identity);

  /// Serializes this ReservationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,borrowerId,borrowerName,status,createdAt);

@override
String toString() {
  return 'ReservationModel(id: $id, bookId: $bookId, bookTitle: $bookTitle, borrowerId: $borrowerId, borrowerName: $borrowerName, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReservationModelCopyWith<$Res>  {
  factory $ReservationModelCopyWith(ReservationModel value, $Res Function(ReservationModel) _then) = _$ReservationModelCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String bookTitle, String borrowerId, String borrowerName, ReservationStatus status,@UtcDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$ReservationModelCopyWithImpl<$Res>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._self, this._then);

  final ReservationModel _self;
  final $Res Function(ReservationModel) _then;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? borrowerId = null,Object? borrowerName = null,Object? status = null,Object? createdAt = null,}) {
  return _then(ReservationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationModel].
extension ReservationModelPatterns on ReservationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationModel value)  $default,){
final _that = this;
switch (_that) {
case _ReservationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String borrowerId,  String borrowerName,  ReservationStatus status, @UtcDateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.borrowerId,_that.borrowerName,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String borrowerId,  String borrowerName,  ReservationStatus status, @UtcDateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReservationModel():
return $default(_that.id,_that.bookId,_that.bookTitle,_that.borrowerId,_that.borrowerName,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String bookTitle,  String borrowerId,  String borrowerName,  ReservationStatus status, @UtcDateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.borrowerId,_that.borrowerName,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationModel implements ReservationModel {
  const _ReservationModel({required this.id, required this.bookId, required this.bookTitle, required this.borrowerId, required this.borrowerName, this.status = ReservationStatus.pending, @UtcDateTimeConverter() required this.createdAt});
  factory _ReservationModel.fromJson(Map<String, dynamic> json) => _$ReservationModelFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  String bookTitle;
@override final  String borrowerId;
@override final  String borrowerName;
@override@JsonKey() final  ReservationStatus status;
@override@UtcDateTimeConverter() final  DateTime createdAt;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationModelCopyWith<_ReservationModel> get copyWith => __$ReservationModelCopyWithImpl<_ReservationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,borrowerId,borrowerName,status,createdAt);

@override
String toString() {
  return 'ReservationModel(id: $id, bookId: $bookId, bookTitle: $bookTitle, borrowerId: $borrowerId, borrowerName: $borrowerName, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReservationModelCopyWith<$Res> implements $ReservationModelCopyWith<$Res> {
  factory _$ReservationModelCopyWith(_ReservationModel value, $Res Function(_ReservationModel) _then) = __$ReservationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String bookTitle, String borrowerId, String borrowerName, ReservationStatus status,@UtcDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$ReservationModelCopyWithImpl<$Res>
    implements _$ReservationModelCopyWith<$Res> {
  __$ReservationModelCopyWithImpl(this._self, this._then);

  final _ReservationModel _self;
  final $Res Function(_ReservationModel) _then;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? borrowerId = null,Object? borrowerName = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_ReservationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
