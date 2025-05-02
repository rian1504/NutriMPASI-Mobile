part of 'baby_bloc.dart';

@immutable
sealed class BabyEvent {}

class FetchBabies extends BabyEvent {}

class ResetBaby extends BabyEvent {}
