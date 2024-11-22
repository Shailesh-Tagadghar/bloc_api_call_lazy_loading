part of 'post_bloc.dart';

@immutable
abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitial extends PostState {}

class PostFechingLoadingState extends PostState {}

class PostFetchingSuccessfulState extends PostState {
  final List<PostModel> posts;

  PostFetchingSuccessfulState({
    required this.posts,
  });
}

class PostFechingErrorState extends PostState {
  final String message;
  final int attemptsLeft;
  final bool isRetrying; // Track if retry is in progress

  PostFechingErrorState({
    required this.message,
    required this.attemptsLeft,
    this.isRetrying = false,
  });
}
