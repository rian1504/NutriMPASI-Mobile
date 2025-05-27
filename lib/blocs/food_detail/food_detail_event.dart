part of 'food_detail_bloc.dart';

@immutable
sealed class FoodDetailEvent {}

class FetchFoodDetail extends FoodDetailEvent {
  final int foodId;

  FetchFoodDetail({required this.foodId});
}

class ToggleFavorite extends FoodDetailEvent {
  final int foodId;

  ToggleFavorite({required this.foodId});
}
