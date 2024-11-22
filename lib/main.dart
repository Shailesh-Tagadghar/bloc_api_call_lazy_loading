import 'package:bloc_api_call_lazy_loading/Routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute, // Set up the routes
      initialRoute: AppRoutes.home, // Set the initial screen route
    );
  }
}
