import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/search/data/repository/search_repository.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:get/get.dart';

class ProductSearchController extends GetxController {
  final SearchRepository _repository = SearchRepository();
  
  var isLoading = false.obs;
  var searchResults = <NewInProduct>[].obs;
  var searchHistory = <String>[].obs;
  final TextEditingController searchTextFieldController = TextEditingController();

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    
    // Add to history
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) searchHistory.removeLast();
    }

    try {
      isLoading(true);
      final response = await _repository.searchProducts(query, showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data']['data'] != null) {
          searchResults.value = (decoded['data']['data'] as List)
              .map((i) => NewInProduct.fromJson(i))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error searching products: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearSearch() {
    searchTextFieldController.clear();
    searchResults.clear();
  }

  void removeFromHistory(String query) {
    searchHistory.remove(query);
  }
}
