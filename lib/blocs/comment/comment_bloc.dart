import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/comment_controller.dart';
import 'package:nutrimpasi/models/comment.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentController controller;

  CommentBloc({required this.controller}) : super(CommentInitial()) {
    on<FetchComments>(_onFetch);
    on<StoreComments>(_onStore);
    on<UpdateComments>(_onUpdate);
    on<DeleteComments>(_onDelete);
  }

  Future<void> _onFetch(FetchComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final result = await controller.getComment(threadId: event.threadId);
      emit(CommentLoaded(threadId: event.threadId, comments: result));
    } catch (e) {
      emit(CommentError('Fetch Comment gagal: ${e.toString()}'));
    }
  }

  Future<void> _onStore(StoreComments event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    final currentState = state as CommentLoaded;

    emit(CommentActionInProgress());
    try {
      final newComment = await controller.storeComment(
        threadId: event.threadId,
        content: event.content,
      );

      // Update state lokal tanpa fetch ulang
      emit(
        CommentLoaded(
          threadId: currentState.threadId,
          comments: [...currentState.comments, newComment],
        ),
      );
    } catch (e) {
      emit(CommentError('Store Comment gagal: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onUpdate(
    UpdateComments event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentLoaded) return;
    final currentState = state as CommentLoaded;

    emit(CommentActionInProgress());
    try {
      final updatedComment = await controller.updateComment(
        commentId: event.commentId,
        content: event.content,
      );

      // Update state lokal
      final updatedComments =
          currentState.comments.map((comment) {
            return comment.id == event.commentId ? updatedComment : comment;
          }).toList();

      emit(
        CommentLoaded(
          threadId: currentState.threadId,
          comments: updatedComments,
        ),
      );
    } catch (e) {
      emit(CommentError('Update Comment gagal: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onDelete(
    DeleteComments event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentLoaded) return;
    final currentState = state as CommentLoaded;

    emit(CommentActionInProgress());
    try {
      await controller.deleteComment(commentId: event.commentId);

      // Update state lokal
      final updatedComments =
          currentState.comments
              .where((comment) => comment.id != event.commentId)
              .toList();

      emit(
        CommentLoaded(
          threadId: currentState.threadId,
          comments: updatedComments,
        ),
      );
    } catch (e) {
      emit(CommentError('Delete Comment gagal: ${e.toString()}'));
      emit(currentState);
    }
  }
}
