part of 'thread_bloc.dart';

@immutable
sealed class ThreadState {}

final class ThreadInitial extends ThreadState {}

final class ThreadLoading extends ThreadState {}

final class ThreadStored extends ThreadState {}

final class ThreadUpdated extends ThreadState {}

final class ThreadDeleted extends ThreadState {}

final class ThreadLoaded extends ThreadState {
  final List<Thread> threads;

  ThreadLoaded({required this.threads});
}

class ThreadError extends ThreadState {
  final String error;
  ThreadError(this.error);
}
