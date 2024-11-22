import 'dart:convert';
import 'package:bloc_api_call_lazy_loading/Bloc/Post/data/model/post_model.dart';
import 'package:bloc_api_call_lazy_loading/Data/API/api_constant.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  static Future<List<PostModel>> fetchPost() async {
    var client = http.Client();
    var url = '$baseUrl$productAPI';
    try {
      var response = await client.get(Uri.parse(url));

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
