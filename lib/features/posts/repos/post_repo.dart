import 'dart:convert';
import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static Future<List<PostModel>> fetchPost() async {
    var client = http.Client();
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        return result
            .map((data) => PostModel.fromMap(data as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to fetch posts");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
