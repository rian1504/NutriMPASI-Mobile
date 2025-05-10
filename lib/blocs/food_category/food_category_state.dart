part of 'food_category_bloc.dart';

@immutable
sealed class FoodCategoryState {}

final class FoodCategoryInitial extends FoodCategoryState {}

final class FoodCategoryLoading extends FoodCategoryState {}

final class FoodCategoryLoaded extends FoodCategoryState {
  final List<FoodCategory> categories;

  FoodCategoryLoaded({required this.categories});
}

final class FoodCategoryError extends FoodCategoryState {
  final String error;

  FoodCategoryError(this.error);
}
