import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:http/http.dart' as http;

class SearchRepository {
  Future<http.Response> searchProducts(String query, {bool showLoader = true}) async {
    return await ApiService.get('products/search?q=$query', showLoader: showLoader);
  }
}
