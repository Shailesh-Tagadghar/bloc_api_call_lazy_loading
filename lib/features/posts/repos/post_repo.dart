import 'dart:convert';
import 'dart:developer';

import 'package:bloc_api_call_lazy_loading/features/posts/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static Future<List<PostModel>> fetchPost() async {
    var client = http.Client();
    try {
      List<PostModel> posts = [];
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      List result = jsonDecode(response.body);

      for (var i = 0; i < result.length; i++) {
        PostModel post = PostModel.fromMap(result[i] as Map<String, dynamic>);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
