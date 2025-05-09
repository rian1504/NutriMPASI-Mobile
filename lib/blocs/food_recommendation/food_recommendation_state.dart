part of 'food_recommendation_bloc.dart';

@immutable
sealed class FoodRecommendationState {}

final class FoodRecommendationInitial extends FoodRecommendationState {}

final class FoodRecommendationLoading extends FoodRecommendationState {}

final class FoodRecommendationDeleted extends FoodRecommendationState {}

final class FoodRecommendationLoaded extends FoodRecommendationState {
  final FoodRecommendation food;

  FoodRecommendationLoaded({required this.food});
}

final class FoodRecommendationError extends FoodRecommendationState {
  final String error;

  FoodRecommendationError(this.error);
}
