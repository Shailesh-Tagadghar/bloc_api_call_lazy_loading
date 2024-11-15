import 'dart:convert';
import 'dart:developer';

import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static Future<List<PostModel>> fetchPost() async {
    var client = http.Client();
    const int maxRetries = 3; // Maximum number of retry attempts
    int attempt = 0;

    // Define the incorrect and correct URLs
    const String wrongUrl =
        'https://jsonplaceholder.typicode.com/wrong_endpoint';
    const String correctUrl = 'https://jsonplaceholder.typicode.com/posts';

    while (attempt < maxRetries) {
      try {
        // Increment the attempt counter
        attempt++;

        // Use the incorrect URL for the first two attempts, then switch to the correct URL
        var url = attempt < 3 ? wrongUrl : correctUrl;

        // Make the API call
        var response = await client.get(Uri.parse(url));
        // var response = await client
        //     .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

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

        // If we've exhausted all retries, rethrow the exception
        if (attempt == maxRetries) {
          log("Max retry attempts reached. Failed to fetch posts.");
          rethrow;
        }

        // Optional: Add a delay before retrying
        await Future.delayed(Duration(seconds: 2));
      }
    }

    // Return an empty list if all attempts fail
    return [];
  }
}
