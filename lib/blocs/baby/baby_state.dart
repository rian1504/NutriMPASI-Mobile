part of 'baby_bloc.dart';

@immutable
sealed class BabyState {}

final class BabyInitial extends BabyState {}

final class BabyLoading extends BabyState {}

final class BabyLoaded extends BabyState {
  final List<Baby> babies;

  BabyLoaded({required this.babies});
}

class BabyError extends BabyState {
  final String error;
  BabyError(this.error);
}
