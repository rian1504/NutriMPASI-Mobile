part of 'food_bloc.dart';

@immutable
sealed class FoodEvent {}

class FetchFoods extends FoodEvent {}

class FetchCategories extends FoodEvent {}

class FilterFoods extends FoodEvent {
  final String? search;
  final String? foodCategoryId;
  final String? source;
  final String? age;

  FilterFoods({this.search, this.foodCategoryId, this.source, this.age});
}
