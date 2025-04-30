part of 'food_cooking_bloc.dart';

@immutable
sealed class FoodCookingEvent {}

class FetchFoodCooking extends FoodCookingEvent {
  final String foodId;
  final List<String> babyId;

  FetchFoodCooking({required this.foodId, required this.babyId});
}

class CompleteFoodCooking extends FoodCookingEvent {
  final String foodId;
  final List<String> babyId;
  final String? scheduleId;

  CompleteFoodCooking({
    required this.foodId,
    required this.babyId,
    this.scheduleId,
  });
}
