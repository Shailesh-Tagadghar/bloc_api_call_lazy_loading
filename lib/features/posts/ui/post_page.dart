import 'package:bloc_api_call_lazy_loading/features/posts/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostBloc postBloc = PostBloc();
  final int maxAttempts = 3; // Max retry attempts
  int attemptsLeft = 3;

  @override
  void initState() {
    attemptsLeft = maxAttempts;
    super.initState();
  }

  void _fetchPosts() {
    if (attemptsLeft > 0) {
      // Trigger API fetch
      postBloc.add(PostInitialFetchEvent());
      setState(() {
        attemptsLeft--;
      });
    }
  }

  void _showErrorMessage(BuildContext context, int attemptsLeft) {
    final message = attemptsLeft > 0
        ? 'Failed to fetch API data. Attempts left: $attemptsLeft'
        : 'Failed to fetch API. Please check again after some time.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Posts'),
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
            _showErrorMessage(context, attemptsLeft);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state is PostFechingLoadingState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : state is PostFetchingSuccessfulState
                        ? ListView.builder(
                            itemCount: state.posts.length,
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
                                      'id : ${state.posts[index].id}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'title : ${state.posts[index].title}',
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
                          )
                        : Center(
                            child: Text(
                              attemptsLeft == 0
                                  ? 'Failed to fetch posts. Try again later.'
                                  : 'Press the button to fetch posts',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: attemptsLeft > 0 ? _fetchPosts : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    attemptsLeft > 0
                        ? 'Fetch Posts (Attempts Left: $attemptsLeft)'
                        : 'Max Attempts Reached',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
