import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/search/controller/search_controller.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ProductSearchController _searchController;
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Use Get.put if not already initialized, or Get.find if it is
    if (Get.isRegistered<ProductSearchController>()) {
      _searchController = Get.find<ProductSearchController>();
    } else {
      _searchController = Get.put(ProductSearchController());
    }
  }

  void _handleToggleWishlist(int? productId) async {
    if (productId == null) return;
    if (!_profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to add items to your favorites');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }

    final body = {'product_id': productId.toString()};
    final response = await ApiImplementation.toggleWishlist(body, showLoader: true);
    if (response.statusCode == 200) {
      _searchController.search(_searchController.searchTextFieldController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () {
            _searchController.clearSearch();
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.blackColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _searchController.searchTextFieldController,
                  onSubmitted: (value) => _searchController.search(value),
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: AppColors.grayShade),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _searchController.search(_searchController.searchTextFieldController.text),
                child: Container(
                  width: 45,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                  child: const Icon(Icons.search, color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      child: Obx(() {
        if (_searchController.isLoading.value) {
          return const Center(child: CircularDotLoader(label: ''));
        }

        if (_searchController.searchResults.isNotEmpty) {
          return _buildSearchResults();
        }

        return _buildInitialState();
      }),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchController.searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: 'Recent Searches', fontSize: 16, fontWeight: FontWeight.bold),
                TextButton(
                  onPressed: () => _searchController.searchHistory.clear(),
                  child: const CustomText(text: 'Clear All', fontSize: 12, textColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _searchController.searchHistory.map((query) => _searchHistoryTag(query)).toList(),
            ),
            const SizedBox(height: 30),
          ],
          const CustomText(
            text: 'Popular Searches:',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _searchTag('Best Seller', icon: Icons.local_fire_department, iconColor: Colors.red),
              _searchTag('Swimwear Hot Sale', icon: Icons.local_fire_department, iconColor: Colors.red),
              _searchTag('Tops Picks', icon: Icons.local_fire_department, iconColor: Colors.red),
              _searchTag('Swimwear'),
              _searchTag('Tankinis'),
              _searchTag('Bikinis'),
              _searchTag('One Piece'),
              _searchTag('Vacation Dresses'),
              _searchTag('black dresses'),
              _searchTag('White dress'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: _searchController.searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchController.searchResults[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  NetworkImageView(
                    url: product.image ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _handleToggleWishlist(product.id),
                      child: Icon(
                        product.isFavorite == true ? Icons.favorite : Icons.favorite_border, 
                        color: product.isFavorite == true ? Colors.red : AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomText(
              text: product.name ?? '',
              fontSize: 12,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'US\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                const Icon(Icons.shopping_bag_outlined, size: 20),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _searchTag(String text, {IconData? icon, Color? iconColor}) {
    return GestureDetector(
      onTap: () {
        _searchController.searchTextFieldController.text = text;
        _searchController.search(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
            ],
            CustomText(text: text, fontSize: 14, textColor: AppColors.grayShade),
          ],
        ),
      ),
    );
  }

  Widget _searchHistoryTag(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.searchTextFieldController.text = text;
        _searchController.search(text);
      },
      child: Chip(
        label: CustomText(text: text, fontSize: 12),
        onDeleted: () => _searchController.removeFromHistory(text),
        deleteIconColor: Colors.grey,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
