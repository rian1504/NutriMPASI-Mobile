part of 'food_suggestion_bloc.dart';

@immutable
sealed class FoodSuggestionEvent {}

class FetchFoodSuggestion extends FoodSuggestionEvent {
  final int foodId;

  FetchFoodSuggestion({required this.foodId});
}

class StoreFoodSuggestion extends FoodSuggestionEvent {
  final int foodCategoryId;
  final String name;
  final File image;
  final String age;
  final double energy;
  final double protein;
  final double fat;
  final int portion;
  final List<String> recipe;
  final List<String>? fruit;
  final List<String> step;
  final String description;

  StoreFoodSuggestion({
    required this.foodCategoryId,
    required this.name,
    required this.image,
    required this.age,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.portion,
    required this.recipe,
    this.fruit,
    required this.step,
    required this.description,
  });
}

class UpdateFoodSuggestion extends FoodSuggestionEvent {
  final int foodId;
  final int foodCategoryId;
  final String name;
  final File? image;
  final String age;
  final double energy;
  final double protein;
  final double fat;
  final int portion;
  final List<String> recipe;
  final List<String>? fruit;
  final List<String> step;
  final String description;

  UpdateFoodSuggestion({
    required this.foodId,
    required this.foodCategoryId,
    required this.name,
    this.image,
    required this.age,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.portion,
    required this.recipe,
    this.fruit,
    required this.step,
    required this.description,
  });
}

class DeleteFoodSuggestion extends FoodSuggestionEvent {
  final int foodId;

  DeleteFoodSuggestion({required this.foodId});
}
