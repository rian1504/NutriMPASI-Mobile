part of 'food_detail_bloc.dart';

@immutable
sealed class FoodDetailState {}

final class FoodDetailInitial extends FoodDetailState {}

final class FoodDetailLoading extends FoodDetailState {}

final class FoodDetailLoaded extends FoodDetailState {
  final Food food;

  FoodDetailLoaded({required this.food});
}

final class FoodDetailError extends FoodDetailState {
  final String error;

  FoodDetailError(this.error);
}
