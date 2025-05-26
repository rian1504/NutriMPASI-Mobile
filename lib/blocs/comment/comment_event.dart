part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

class FetchComments extends CommentEvent {
  final int threadId;

  FetchComments({required this.threadId});
}

class StoreComments extends CommentEvent {
  final int threadId;
  final String content;

  StoreComments({required this.threadId, required this.content});
}

class UpdateComments extends CommentEvent {
  final int commentId;
  final String content;

  UpdateComments({required this.commentId, required this.content});
}

class DeleteComments extends CommentEvent {
  final int commentId;

  DeleteComments({required this.commentId});
}
