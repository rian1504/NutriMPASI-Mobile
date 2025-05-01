part of 'baby_bloc.dart';

@immutable
sealed class BabyState {}

final class BabyInitial extends BabyState {}

final class BabyLoading extends BabyState {}

final class BabyFoodRecommendationLoading extends BabyState {}

final class BabyLoaded extends BabyState {
  final List<Baby> babies;

  BabyLoaded({required this.babies});
}

final class BabyFoodRecommendationLoaded extends BabyState {
  final List<BabyFoodRecommendation> babyFoodRecommendation;

  BabyFoodRecommendationLoaded({required this.babyFoodRecommendation});
}

class BabyError extends BabyState {
  final String error;
  BabyError(this.error);
}
