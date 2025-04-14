part of 'food_detail_bloc.dart';

@immutable
sealed class FoodDetailEvent {}

class FetchFoodDetail extends FoodDetailEvent {
  final String foodId;

  FetchFoodDetail({required this.foodId});
}
