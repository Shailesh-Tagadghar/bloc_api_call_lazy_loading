import 'package:bloc_api_call_lazy_loading/features/posts/bloc/post_bloc.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/ui/product_lazy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductLazy()),
              );
            },
            child: const Text('Posts')),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: BlocProvider(
        create: (_) => PostBloc()..add(PostInitialFetchEvent()),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostFechingLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostFetchingSuccessfulState) {
              return ListView.builder(
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
                        SizedBox(height: 10),
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
              );
            } else if (state is PostFechingErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    if (state.attemptsLeft > 0) ...[
                      Text('Attempts left: ${state.attemptsLeft}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PostBloc>().add(PostInitialFetchEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ] else ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back or retry later
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
