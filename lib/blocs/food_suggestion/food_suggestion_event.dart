part of 'food_suggestion_bloc.dart';

@immutable
sealed class FoodSuggestionEvent {}

class FetchFoodSuggestion extends FoodSuggestionEvent {
  final int foodId;

  FetchFoodSuggestion({required this.foodId});
}

class DeleteFoodSuggestion extends FoodSuggestionEvent {
  final int foodId;

  DeleteFoodSuggestion({required this.foodId});
}
