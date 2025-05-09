part of 'food_recommendation_bloc.dart';

@immutable
sealed class FoodRecommendationEvent {}

class FetchFoodRecommendation extends FoodRecommendationEvent {
  final int foodId;

  FetchFoodRecommendation({required this.foodId});
}

class DeleteFoodRecommendation extends FoodRecommendationEvent {
  final int foodId;

  DeleteFoodRecommendation({required this.foodId});
}
