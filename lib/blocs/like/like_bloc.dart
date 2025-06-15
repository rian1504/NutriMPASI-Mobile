import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/like_controller.dart';
import 'package:nutrimpasi/models/like.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeController controller;

  LikeBloc({required this.controller}) : super(LikeInitial()) {
    on<FetchLikes>(_onFetch);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onFetch(FetchLikes event, Emitter<LikeState> emit) async {
    emit(LikeLoading());
    try {
      final result = await controller.getLike();
      emit(LikeLoaded(likes: result));
    } catch (e) {
      emit(LikeError('Fetch Like gagal: ${e.toString()}'));
    }
  }

  Future<void> _onToggleLike(ToggleLike event, Emitter<LikeState> emit) async {
    if (state is! LikeLoaded) return;
    final currentState = state as LikeLoaded;
    emit(LikeLoading());

    try {
      await controller.toggleLike(threadId: event.threadId);

      // Hapus Like
      final updatedLikes =
          currentState.likes
              .where((like) => like.threadId != event.threadId)
              .toList();

      emit(LikeLoaded(likes: updatedLikes));
    } catch (e) {
      emit(LikeError('Gagal mengupdate like: ${e.toString()}'));
      emit(currentState);
    }
  }
}
