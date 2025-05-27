part of 'like_bloc.dart';

@immutable
sealed class LikeEvent {}

class FetchLikes extends LikeEvent {}

class ToggleLike extends LikeEvent {
  final int threadId;

  ToggleLike({required this.threadId});
}
