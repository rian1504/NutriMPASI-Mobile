part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentActionInProgress extends CommentState {}

final class CommentStored extends CommentState {}

final class CommentUpdated extends CommentState {}

final class CommentDeleted extends CommentState {}

final class CommentLoaded extends CommentState {
  final ThreadDetail thread;

  CommentLoaded({required this.thread});
}

class CommentError extends CommentState {
  final String error;
  CommentError(this.error);
}
