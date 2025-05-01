part of 'baby_bloc.dart';

@immutable
sealed class BabyEvent {}

class FetchBabies extends BabyEvent {}

class ResetBaby extends BabyEvent {}

class FetchBabyFoodRecommendation extends BabyEvent {
  final String babyId;

  FetchBabyFoodRecommendation({required this.babyId});
}
