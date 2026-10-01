import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu.freezed.dart';
part 'menu.g.dart';

/// Alergénios a declarar por prato (os 10 mais comuns).
enum Allergen {
  gluten,
  lactose,
  eggs,
  fish,
  shellfish,
  peanuts,
  nuts,
  soy,
  celery,
  sesame,
}

/// Tipo de refeição (pequeno-almoço, almoço, lanche...) com preço e horário.
/// Horas em `HH:mm`; dinheiro em `int` (menor unidade).
@freezed
abstract class MealType with _$MealType {
  const factory MealType({
    required String id,
    required String name,
    required String startTime,
    required String endTime,
    @Default(0) int priceMinor,
    @Default(true) bool isActive,
  }) = _MealType;

  factory MealType.fromJson(Map<String, dynamic> json) =>
      _$MealTypeFromJson(json);
}

/// Prato/item de menu, de um tipo de refeição, com os seus alergénios.
@freezed
abstract class MealItem with _$MealItem {
  const factory MealItem({
    required String id,
    required String name,
    required String mealTypeId,
    @Default(0) int priceMinor,
    @Default(<Allergen>[]) List<Allergen> allergens,
    @Default(true) bool isActive,
  }) = _MealItem;

  factory MealItem.fromJson(Map<String, dynamic> json) =>
      _$MealItemFromJson(json);
}

/// Menu de um dia (`date` = `yyyy-MM-dd`) para um tipo de refeição.
@freezed
abstract class MealMenu with _$MealMenu {
  const factory MealMenu({
    required String id,
    required String date,
    required String mealTypeId,
    @Default(<String>[]) List<String> itemIds,
  }) = _MealMenu;

  factory MealMenu.fromJson(Map<String, dynamic> json) =>
      _$MealMenuFromJson(json);
}
