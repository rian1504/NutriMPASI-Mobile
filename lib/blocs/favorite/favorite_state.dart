part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<Favorite> favorites;

  FavoriteLoaded({required this.favorites});
}

class FavoriteError extends FavoriteState {
  final String error;
  FavoriteError(this.error);
}
