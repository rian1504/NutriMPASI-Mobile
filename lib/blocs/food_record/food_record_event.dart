part of 'food_record_bloc.dart';

@immutable
sealed class FoodRecordEvent {}

class FetchFoodRecords extends FoodRecordEvent {}
