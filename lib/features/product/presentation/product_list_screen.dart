import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/product/presentation/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final dynamic categoryId;

  const ProductListScreen({super.key, required this.title, required this.categoryId});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  List<NewInProduct> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getProductCollection(widget.categoryId, showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          setState(() {
            _products = (decoded['data'] as List)
                .map((i) => NewInProduct.fromJson(i))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      setState(() => _isLoading = false);
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
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: widget.title.toUpperCase(),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: _isLoading
          ? const Center(child: CircularDotLoader(label: ''))
          : _products.isEmpty
              ? const Center(child: CustomText(text: 'No products found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return GestureDetector(
                      onTap: () => RouteNavigate().navigateToPush(
                        context,
                        ProductDetailScreen(productId: product.id!),
                      ),
                      child: Column(
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
                            maxLine: 2,
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
                      ),
                    );
                  },
                ),
    );
  }
}
