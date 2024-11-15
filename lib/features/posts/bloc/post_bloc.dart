import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/repos/post_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(postInitialFetchEvent);
  }

  FutureOr<void> postInitialFetchEvent(
      PostInitialFetchEvent event, Emitter<PostState> emit) async {
    emit(PostFechingLoadingState());

    List<PostModel> posts = await PostRepo.fetchPost();

    emit(PostFetchingSuccessfulState(posts: posts));
  }
}
