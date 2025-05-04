part of 'baby_food_recommendation_bloc.dart';

@immutable
sealed class BabyFoodRecommendationState {}

final class BabyFoodRecommendationInitial extends BabyFoodRecommendationState {}

final class BabyFoodRecommendationLoading extends BabyFoodRecommendationState {}

final class BabyFoodRecommendationLoaded extends BabyFoodRecommendationState {
  final List<BabyFoodRecommendation> foods;

  BabyFoodRecommendationLoaded({required this.foods});
}

final class BabyFoodRecommendationError extends BabyFoodRecommendationState {
  final String error;

  BabyFoodRecommendationError(this.error);
}
