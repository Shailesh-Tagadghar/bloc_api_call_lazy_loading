import 'package:bloc_api_call_lazy_loading/Bloc/Post/post_bloc.dart';
import 'package:bloc_api_call_lazy_loading/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.lazyLoading);
            },
            child: const Text('Posts')),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostFechingLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostFetchingSuccessfulState) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
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
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'title : ${state.posts[index].title}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is PostFechingErrorState) {
            // Show alert dialog if showAlert is true
            if (state.showAlert) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pushNamed(context, AppRoutes.home);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  },
                );
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  if (state.attemptsLeft > 0) ...[
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: state.isRetrying
                          ? null // Disable button during retry
                          : () {
                              context.read<PostBloc>().add(PostRetryEvent());
                            },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          state.isRetrying ? Colors.grey : Colors.blue,
                        ),
                      ),
                      child: state.isRetrying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Attempts left: ${state.attemptsLeft}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ] else ...[
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
