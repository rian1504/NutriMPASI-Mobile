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
      final threadDetail = await controller.getThreadDetail(
        threadId: event.threadId,
      );
      emit(CommentLoaded(thread: threadDetail));
    } catch (e) {
      emit(CommentError('Fetch Thread Detail gagal: ${e.toString()}'));
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

      // Update thread dengan komentar baru dan increment commentsCount
      final updatedThread = currentState.thread.copyWith(
        comments: [newComment, ...currentState.thread.comments],
        commentsCount: currentState.thread.commentsCount + 1,
      );

      emit(CommentStored());
      emit(CommentLoaded(thread: updatedThread));
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

      // Update komentar yang diubah (commentsCount tetap sama)
      final updatedComments =
          currentState.thread.comments.map((comment) {
            return comment.id == event.commentId ? updatedComment : comment;
          }).toList();

      final updatedThread = currentState.thread.copyWith(
        comments: updatedComments,
      );

      emit(CommentUpdated());
      emit(CommentLoaded(thread: updatedThread));
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

      // Hapus komentar dan decrement commentsCount
      final updatedComments =
          currentState.thread.comments
              .where((comment) => comment.id != event.commentId)
              .toList();

      final updatedThread = currentState.thread.copyWith(
        comments: updatedComments,
        commentsCount: currentState.thread.commentsCount - 1,
      );

      emit(CommentDeleted());
      emit(CommentLoaded(thread: updatedThread));
    } catch (e) {
      emit(CommentError('Delete Comment gagal: ${e.toString()}'));
      emit(currentState);
    }
  }
}
