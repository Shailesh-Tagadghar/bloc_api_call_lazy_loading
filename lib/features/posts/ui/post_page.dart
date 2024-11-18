import 'dart:async';

import 'package:bloc_api_call_lazy_loading/features/posts/bloc/post_bloc.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/repos/post_repo.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/ui/product_lazy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostBloc postBloc = PostBloc();
  bool showRetryMessage = false; // State to show retry message
  Timer? timer; // Timer for delaying the retry message
  int attemptsLeft = PostRepo.maxRetries;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    startRetryTimer(); // Start the timer on page load
  }

  void fetchPosts() {
    setState(() {
      showRetryMessage = false;
      attemptsLeft = PostRepo.maxRetries;
    });
    postBloc.add(PostInitialFetchEvent());
  }

  void startRetryTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer(Duration(seconds: 20), () {
      // After 20 seconds, show the retry message if data hasn't loaded
      setState(() {
        showRetryMessage = true;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Clean up the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductLazy()),
              );
            },
            child: Text('Posts')),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        bloc: postBloc,
        listenWhen: (previous, current) => current is PostActionState,
        buildWhen: (previous, current) => current is! PostActionState,
        listener: (context, state) {
          if (state is PostFechingErrorState) {
            setState(() {
              attemptsLeft--;
              if (attemptsLeft == 0) {
                showRetryMessage = true;
                timer?.cancel(); // Stop the timer when max attempts are reached
              } else if (state is PostFetchingSuccessfulState) {
                // Cancel the timer if data is successfully fetched
                timer?.cancel();
              }
            });
          }
        },
        builder: (context, state) {
          if (showRetryMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to fetch data. Please retry after some time.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchPosts,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          switch (state.runtimeType) {
            case PostFechingLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostFetchingSuccessfulState:
              final successState = state as PostFetchingSuccessfulState;
              return ListView.builder(
                itemCount: successState.posts.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'id : ${successState.posts[index].id}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'title : ${successState.posts[index].title}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
