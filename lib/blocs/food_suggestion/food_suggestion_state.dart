part of 'food_suggestion_bloc.dart';

@immutable
sealed class FoodSuggestionState {}

final class FoodSuggestionInitial extends FoodSuggestionState {}

final class FoodSuggestionLoading extends FoodSuggestionState {}

final class FoodSuggestionDeleted extends FoodSuggestionState {}

final class FoodSuggestionLoaded extends FoodSuggestionState {
  final FoodSuggestion food;

  FoodSuggestionLoaded({required this.food});
}

final class FoodSuggestionError extends FoodSuggestionState {
  final String error;

  FoodSuggestionError(this.error);
}
