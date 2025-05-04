part of 'baby_food_recommendation_bloc.dart';

@immutable
sealed class BabyFoodRecommendationEvent {}

class FetchBabyFoodRecommendation extends BabyFoodRecommendationEvent {
  final int babyId;

  FetchBabyFoodRecommendation({required this.babyId});
}
