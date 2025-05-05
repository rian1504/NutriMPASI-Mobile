part of 'nutritionist_bloc.dart';

@immutable
sealed class NutritionistState {}

final class NutritionistInitial extends NutritionistState {}

final class NutritionistLoading extends NutritionistState {}

final class NutritionistLoaded extends NutritionistState {
  final List<Nutritionist> nutritionists;

  NutritionistLoaded({required this.nutritionists});
}

class NutritionistError extends NutritionistState {
  final String error;
  NutritionistError(this.error);
}
