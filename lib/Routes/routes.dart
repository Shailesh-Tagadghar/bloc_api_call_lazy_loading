// Define your routes here
import 'package:bloc_api_call_lazy_loading/Bloc/Post/post_bloc.dart';
import 'package:bloc_api_call_lazy_loading/Presentation/Lazy_Loading/product_lazy.dart';
import 'package:bloc_api_call_lazy_loading/Presentation/Post_API_3_Attempt/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String home = '/';
  static const String lazyLoading = '/product_lazy';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (_) => PostBloc()..add(PostInitialFetchEvent()),
              child: const PostPage(),
            );
          },
        );
      case lazyLoading:
        return MaterialPageRoute(
          builder: (context) {
            return const ProductLazy();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const PostPage();
          },
        );
    }
  }
}
