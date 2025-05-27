part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

class FetchFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final int foodId;

  ToggleFavorite({required this.foodId});
}
