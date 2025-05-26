part of 'food_cooking_bloc.dart';

@immutable
sealed class FoodCookingState {}

final class FoodCookingInitial extends FoodCookingState {}

final class FoodCookingLoading extends FoodCookingState {}

final class FoodCookingComplete extends FoodCookingState {}

final class FoodCookingCompleteLoading extends FoodCookingState {}

final class FoodCookingLoaded extends FoodCookingState {
  final FoodCooking foodCooking;

  FoodCookingLoaded({required this.foodCooking});
}

final class FoodCookingError extends FoodCookingState {
  final String error;

  FoodCookingError(this.error);
}
