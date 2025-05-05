part of 'baby_bloc.dart';

@immutable
sealed class BabyEvent {}

class FetchBabies extends BabyEvent {}

class StoreBabies extends BabyEvent {
  final String name;
  final DateTime dob;
  final String gender;
  final double weight;
  final double height;
  final String condition;

  StoreBabies({
    required this.name,
    required this.dob,
    required this.gender,
    required this.weight,
    required this.height,
    required this.condition,
  });
}

class UpdateBabies extends BabyEvent {
  final int babyId;
  final String name;
  final DateTime dob;
  final String gender;
  final double weight;
  final double height;
  final String condition;

  UpdateBabies({
    required this.babyId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.weight,
    required this.height,
    required this.condition,
  });
}

class DeleteBabies extends BabyEvent {
  final int babyId;

  DeleteBabies({required this.babyId});
}

class ResetBaby extends BabyEvent {}
