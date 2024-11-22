import 'dart:convert';

import 'package:bloc_api_call_lazy_loading/Data/API/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductLazy extends StatefulWidget {
  const ProductLazy({super.key});

  @override
  State<ProductLazy> createState() => _ProductLazyState();
}

class _ProductLazyState extends State<ProductLazy> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List posts = [];
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollLister);
    fetchLazyPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lazy Loading Data'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.blue[600],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
          itemCount: isLoadingMore ? posts.length + 1 : posts.length,
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < posts.length) {
              final post = posts[index];
              final id = post['id'];
              final title = post['title']['rendered'];
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
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'id : $id',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'title : ${title}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> fetchLazyPosts() async {
    String url = fetchPostsUrl(page);
    // final url =
    //     "https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=10&page=$page";
    print('url : $url');
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = posts + json;
      });
    } else {
      print('Error while fetching data');
    }
  }

  Future<void> _scrollLister() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // print('scroll listner called');
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await fetchLazyPosts();
      setState(() {
        isLoadingMore = false;
      });
    } else {
      // print('don\'t called');
    }
  }
}
