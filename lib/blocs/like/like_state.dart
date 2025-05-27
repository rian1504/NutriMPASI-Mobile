part of 'like_bloc.dart';

@immutable
sealed class LikeState {}

final class LikeInitial extends LikeState {}

final class LikeLoading extends LikeState {}

final class LikeLoaded extends LikeState {
  final List<Like> likes;

  LikeLoaded({required this.likes});
}

class LikeError extends LikeState {
  final String error;
  LikeError(this.error);
}
