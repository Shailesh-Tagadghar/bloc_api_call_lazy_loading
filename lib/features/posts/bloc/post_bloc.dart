import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/repos/post_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final int maxRetries = 3;
  int attempts = 0; // Track retry attempts

  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(postInitialFetchEvent);
    on<PostRetryEvent>(_postRetryEvent); // Add handler for retry event
  }

  FutureOr<void> postInitialFetchEvent(
      PostInitialFetchEvent event, Emitter<PostState> emit) async {
    emit(PostFechingLoadingState());
    await _fetchPosts(emit);
  }

  FutureOr<void> _postRetryEvent(
      PostRetryEvent event, Emitter<PostState> emit) async {
    emit(PostFechingErrorState(
      message: 'Retrying...',
      attemptsLeft: maxRetries - attempts,
      isRetrying: true,
    )); // Indicate retry in progress
    await _fetchPosts(emit);
  }

  Future<void> _fetchPosts(Emitter<PostState> emit) async {
    if (attempts >= maxRetries) {
      emit(PostFechingErrorState(
        message: 'Failed to fetch posts after $maxRetries attempts.',
        attemptsLeft: 0,
      ));
      return;
    }

    attempts++; // Increment attempts on each fetch
    try {
      List<PostModel> posts = await PostRepo.fetchPost();
      emit(PostFetchingSuccessfulState(posts: posts));
      attempts = 0; // Reset attempts on success
    } catch (e) {
      emit(PostFechingErrorState(
        message: 'Failed to fetch data. Please retry.',
        attemptsLeft: maxRetries - attempts,
        isRetrying: false,
      ));
    }
  }
}
