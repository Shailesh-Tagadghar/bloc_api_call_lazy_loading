import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_api_call_lazy_loading/Bloc/Post/data/model/post_model.dart';
import 'package:bloc_api_call_lazy_loading/Bloc/Post/data/repository/post_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final int maxRetries = 4;
  int attempts = 0; // Track retry attempts

  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(_postInitialFetchEvent);
    on<PostRetryEvent>(_postRetryEvent); // Add handler for retry event
  }

  FutureOr<void> _postInitialFetchEvent(
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
        // message: 'Failed to fetch posts after $maxRetries attempts.',
        message: 'All attempts failed. Please try again later.',
        attemptsLeft: 0,
        isRetrying: false,
        showAlert: true, // Trigger alert dialog
      ));
      return;
    }

    attempts++; // Increment attempts on each fetch
    try {
      List<PostModel> posts = await PostRepo.fetchPost();
      emit(PostFetchingSuccessfulState(posts: posts));
      attempts = 0; // Reset attempts on success
    } on SocketException {
      emit(PostFechingErrorState(
        message: 'No internet connection. Please check your network.',
        attemptsLeft: maxRetries - attempts,
        showAlert: attempts >= maxRetries - 0, // Alert after last attempt
      ));
    } on TimeoutException {
      emit(PostFechingErrorState(
        message: 'Request timed out. Please try again.',
        attemptsLeft: maxRetries - attempts,
        showAlert: attempts >= maxRetries - 0, // Alert after last attempt
      ));
    } catch (e) {
      emit(PostFechingErrorState(
        message: 'Something went wrong. Please try again later.',
        attemptsLeft: maxRetries - attempts,
        showAlert: attempts >= maxRetries - 0, // Alert after last attempt
      ));
    }
  }
}
