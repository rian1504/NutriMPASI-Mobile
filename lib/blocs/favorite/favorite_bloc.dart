import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/favorite_controller.dart';
import 'package:nutrimpasi/models/favorite.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteController controller;

  FavoriteBloc({required this.controller}) : super(FavoriteInitial()) {
    on<FetchFavorites>(_onFetch);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetch(
    FetchFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final result = await controller.getFavorite();
      emit(FavoriteLoaded(favorites: result));
    } catch (e) {
      emit(FavoriteError('Fetch Favorite gagal: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is! FavoriteLoaded) return;
    final currentState = state as FavoriteLoaded;

    try {
      await controller.toggleFavorite(foodId: event.foodId);

      // Hapus Favorite
      final updatedFavorites =
          currentState.favorites
              .where((favorite) => favorite.foodId != event.foodId)
              .toList();

      emit(FavoriteLoaded(favorites: updatedFavorites));
    } catch (e) {
      emit(FavoriteError('Gagal mengupdate Favorite: ${e.toString()}'));
      emit(currentState);
    }
  }
}
