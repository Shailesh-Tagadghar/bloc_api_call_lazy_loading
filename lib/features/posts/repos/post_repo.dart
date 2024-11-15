import 'dart:convert';
import 'dart:developer';
import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static const int maxRetries = 3; // Maximum number of retry attempts
  static Future<List<PostModel>> fetchPost() async {
    var client = http.Client();
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        attempt++;

        // Make the API call
        var response = await client
            .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

        if (response.statusCode == 200) {
          // Parse and return the data if the response is successful
          List result = jsonDecode(response.body);
          List<PostModel> posts = result
              .map((data) => PostModel.fromMap(data as Map<String, dynamic>))
              .toList();
          return posts;
        } else {
          log("Error: ${response.statusCode}");
          throw Exception("Failed to fetch posts");
        }
      } catch (e) {
        log("Attempt $attempt failed: $e");

        if (attempt == maxRetries) {
          log("Max retry attempts reached. User should retry after some time.");
          throw Exception(
              "Max retry attempts reached. Please retry after some time.");
        }

        // Add a delay before retrying
        await Future.delayed(Duration(seconds: 2));
      }
    }

    return []; // This will only execute if all attempts fail, returning an empty list
  }
}
