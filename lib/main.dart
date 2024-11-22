import 'package:bloc_api_call_lazy_loading/features/posts/bloc/post_bloc.dart';
import 'package:bloc_api_call_lazy_loading/features/posts/ui/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc()..add(PostInitialFetchEvent()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PostPage(),
      ),
    );
  }
}
