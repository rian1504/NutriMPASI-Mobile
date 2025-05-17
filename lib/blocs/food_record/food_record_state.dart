part of 'food_record_bloc.dart';

@immutable
sealed class FoodRecordState {}

final class FoodRecordInitial extends FoodRecordState {}

final class FoodRecordLoading extends FoodRecordState {}

final class FoodRecordLoaded extends FoodRecordState {
  final List<FoodRecord> foodRecords;

  FoodRecordLoaded({required this.foodRecords});
}

final class FoodRecordError extends FoodRecordState {
  final String error;
  FoodRecordError(this.error);
}
