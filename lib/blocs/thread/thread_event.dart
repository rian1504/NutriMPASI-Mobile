part of 'thread_bloc.dart';

@immutable
sealed class ThreadEvent {}

class FetchThreads extends ThreadEvent {}

class ToggleLike extends ThreadEvent {
  final int threadId;

  ToggleLike({required this.threadId});
}

class StoreThreads extends ThreadEvent {
  final String title;
  final String content;

  StoreThreads({required this.title, required this.content});
}

class UpdateThreads extends ThreadEvent {
  final int threadId;
  final String title;
  final String content;

  UpdateThreads({
    required this.threadId,
    required this.title,
    required this.content,
  });
}

class DeleteThreads extends ThreadEvent {
  final int threadId;

  DeleteThreads({required this.threadId});
}
