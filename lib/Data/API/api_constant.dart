/// baseUrl of our api
const String baseUrl = 'https://jsonplaceholder.typicode.com';

const String lazybaseUrl = 'https://techcrunch.com/wp-json/wp/v2/posts';

/// Add endpoint of apis below
const String productAPI = '/posts';

String fetchPostsUrl(int page) {
  return "$lazybaseUrl?context=embed&per_page=10&page=$page";
}
