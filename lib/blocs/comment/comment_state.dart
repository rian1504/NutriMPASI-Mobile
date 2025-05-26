part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentActionInProgress extends CommentState {}

final class CommentLoaded extends CommentState {
  final int threadId;
  final List<ThreadDetail> comments;

  CommentLoaded({required this.threadId, required this.comments});
}

class CommentError extends CommentState {
  final String error;
  CommentError(this.error);
}
