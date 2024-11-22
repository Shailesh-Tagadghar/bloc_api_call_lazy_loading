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
  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(postInitialFetchEvent);
  }

  FutureOr<void> postInitialFetchEvent(
      PostInitialFetchEvent event, Emitter<PostState> emit) async {
    // emit(PostFechingLoadingState());
    int attempts = 0;

    // List<PostModel> posts = await PostRepo.fetchPost();

    // emit(PostFetchingSuccessfulState(posts: posts));

    while (attempts < maxRetries) {
      attempts++;
      emit(PostFechingLoadingState());
      try {
        List<PostModel> posts = await PostRepo.fetchPost();
        emit(PostFetchingSuccessfulState(posts: posts));
        return; // Exit the loop on success
      } catch (e) {
        if (attempts == maxRetries) {
          emit(PostFechingErrorState(
            message: 'Failed to fetch posts after $maxRetries attempts.',
            attemptsLeft: 0,
          ));
        } else {
          emit(PostFechingErrorState(
            message: 'Failed to fetch data. Retrying...',
            attemptsLeft: maxRetries - attempts,
          ));
        }
        await Future.delayed(Duration(seconds: 3)); // Delay before retrying
      }
    }
  }
}
