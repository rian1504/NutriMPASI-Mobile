part of 'food_bloc.dart';

@immutable
sealed class FoodState {}

final class FoodInitial extends FoodState {}

final class FoodLoading extends FoodState {}

final class FoodLoaded extends FoodState {
  final List<Food> foods;
  final List<FoodCategory> categories;

  FoodLoaded({required this.foods, required this.categories});
}

class FoodError extends FoodState {
  final String error;
  FoodError(this.error);
}
