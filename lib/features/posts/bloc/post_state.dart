part of 'post_bloc.dart';

@immutable
abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitial extends PostState {}

class PostFechingLoadingState extends PostState {}

class PostFechingErrorState extends PostState {}

class PostFetchingSuccessfulState extends PostState {
  final List<PostModel> posts;

  PostFetchingSuccessfulState({
    required this.posts,
  });
}
