import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  List<NewInProduct> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (_profileController.isLoggedIn.value) {
      _fetchWishlist();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _fetchWishlist() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getWishlist(showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          setState(() {
            _wishlistItems = (decoded['data'] as List)
                .map((i) => NewInProduct.fromJson(i))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleToggleWishlist(int productId) async {
    final body = {'product_id': productId.toString()};
    final response = await ApiImplementation.toggleWishlist(body, showLoader: true);
    if (response.statusCode == 200) {
      _fetchWishlist(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: const CustomText(
          text: 'My Favorites',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Obx(() {
        if (!_profileController.isLoggedIn.value) {
          return _buildLoggedOutState();
        }

        if (_isLoading) {
          return const Center(child: CircularDotLoader(label: ''));
        }

        if (_wishlistItems.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _fetchWishlist,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
            itemCount: _wishlistItems.length,
            itemBuilder: (context, index) {
              final product = _wishlistItems[index];
              return _buildProductCard(product);
            },
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(NewInProduct product) {
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
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _handleToggleWishlist(product.id!),
                  child: const Icon(Icons.favorite, color: Colors.red, size: 24),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.add_shopping_cart, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CustomText(
          text: product.name ?? '',
          fontSize: 13,
          maxLine: 1,
          textColor: Colors.black87,
        ),
        const SizedBox(height: 4),
        if (product.salePrice != null) ...[
          Row(
            children: [
              CustomText(
                text: 'US\$${product.salePrice!.toStringAsFixed(2)}',
                fontWeight: FontWeight.bold,
                textColor: Colors.red,
                fontSize: 14,
              ),
              const SizedBox(width: 5),
              CustomText(
                text: 'US\$${product.price!.toStringAsFixed(2)}',
                fontSize: 11,
                textColor: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ],
          )
        ] else ...[
          CustomText(
            text: 'US\$${product.price?.toStringAsFixed(2) ?? "0.00"}',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ],
      ],
    );
  }

  Widget _buildLoggedOutState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconIllustration(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => RouteNavigate().navigateToPush(context, const LoginScreen()),
                child: const CustomText(
                  text: 'Sign in',
                  fontSize: 16,
                  textColor: Colors.orangeAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
              const CustomText(
                text: ' to view your favorites.',
                fontSize: 16,
                textColor: AppColors.grayShade,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconIllustration(),
          const SizedBox(height: 20),
          const CustomText(
            text: 'Your wishlist is empty.',
            fontSize: 16,
            textColor: AppColors.grayShade,
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: 'START SHOPPING',
            buttonColor: AppColors.blackColor,
            textColor: AppColors.whiteColor,
            width: 200,
            height: 45,
            borderRadius: 0,
            onSubmit: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIconIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
        ),
        const Icon(Icons.favorite, size: 80, color: Colors.orangeAccent),
      ],
    );
  }
}
