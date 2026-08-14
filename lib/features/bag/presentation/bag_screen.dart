import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/checkout/presentation/checkout_screen.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  bool _isRefreshing = false;
  double _pullDistance = 0;
  List<NewInProduct> _recommendations = [];
  List<CartItem> _cartItems = [];
  CartData? _cartData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }
    List<Future> futures = [_fetchRecommendations(silent: true)];
    if (_profileController.isLoggedIn.value) {
      futures.add(_fetchCart(silent: true));
    }
    await Future.wait(futures);
    if (!silent) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCart({bool silent = false}) async {
    try {
      final response = await ApiImplementation.getCart(showLoader: !silent);
      if (response.statusCode == 200) {
        final cartRes = CartResponse.fromJson(jsonDecode(response.body));
        setState(() {
          _cartData = cartRes.data;
          _cartItems = cartRes.data?.items ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
  }

  Future<void> _fetchRecommendations({bool silent = false}) async {
    try {
      final response = await ApiImplementation.getCartRecommendations(showLoader: !silent);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          setState(() {
            _recommendations = (decoded['data'] as List)
                .map((i) => NewInProduct.fromJson(i))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching cart recommendations: $e");
    } finally {
      if (silent) {
        setState(() {
          _isRefreshing = false;
          _pullDistance = 0;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });
    await _loadData(silent: true);
  }

  void _handleAddToCart(int? productId) async {
    if (productId == null) return;
    final profileController = Get.find<ProfileController>();
    if (!profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to add items to your bag');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }
    final body = {'product_id': productId.toString(), 'quantity': '1'};
    final response = await ApiImplementation.addToCart(body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomToast.showToast(message: 'Product added to bag successfully');
      _fetchCart(silent: true);
    } else {
      final decoded = jsonDecode(response.body);
      CustomToast.showToast(message: decoded['message'] ?? 'Failed to add product to bag');
    }
  }

  void _handleUpdateQuantity(int productId, int newQuantity) async {
    if (newQuantity < 1) return;
    final body = {'product_id': productId.toString(), 'quantity': newQuantity.toString()};
    final response = await ApiImplementation.updateCart(body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _fetchCart(silent: true);
    }
  }

  void _handleRemoveFromCart(int productId) async {
    final response = await ApiImplementation.removeFromCart(productId.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomToast.showToast(message: 'Product removed from bag');
      _fetchCart(silent: true);
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
    final response = await ApiImplementation.toggleWishlist(body);
    if (response.statusCode == 200) {
      _fetchRecommendations(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: const CustomText(
          text: 'My Bag',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.blackColor),
            onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
          ),
        ],
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels < 0) {
              setState(() {
                _pullDistance = -notification.metrics.pixels;
              });
            } else if (_pullDistance != 0) {
              setState(() {
                _pullDistance = 0;
              });
            }
          }
          if (notification is ScrollEndNotification) {
            if (_pullDistance > 80) {
              _onRefresh();
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildRefreshBanner(),
              _buildShippingProgress(),
              if (_isLoading)
                const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Colors.black))
              else if (_cartItems.isEmpty)
                Obx(() => _buildEmptyState())
              else
                _buildCartList(),
              _buildCouponSection(),
              _buildOrderSummary(),
              _buildRecommendedSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshBanner() {
    String text = '';
    if (_isRefreshing) {
      text = 'UPDATING...';
    } else if (_pullDistance > 10) {
      text = _pullDistance > 80 ? 'Release To Refresh' : 'Pull Down To Refresh';
    }
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      height: 45,
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: CustomText(text: text, fontSize: 14, textColor: Colors.black45),
    );
  }

  Widget _buildShippingProgress() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: 0.6,
              strokeWidth: 4,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: 'Add '),
                      TextSpan(text: 'US\$19.02', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' more to enjoy'),
                    ],
                  ),
                ),
                const CustomText(text: 'Free Standard Shipping.', fontSize: 14),
              ],
            ),
          ),
          CustomButton(
            text: '+ ADD',
            width: 70,
            height: 30,
            fontSize: 12,
            buttonColor: Colors.white,
            textColor: Colors.black,
            borderColor: Colors.black,
            widthDecoration: 1,
            borderRadius: 4,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset("assets/images/shopping_bags_asset.png", width: 150, height: 150),
        const SizedBox(height: 20),
        const CustomText(text: 'You bag is empty', fontSize: 18, fontWeight: FontWeight.w500),
        const SizedBox(height: 10),
        if (!_profileController.isLoggedIn.value)
          const CustomText(text: 'Have an account? Sign in to view your bag.', fontSize: 14, textColor: AppColors.grayShade),
        const SizedBox(height: 30),
        CustomButton(
          text: 'START SHOPPING',
          buttonColor: AppColors.blackColor,
          textColor: AppColors.whiteColor,
          width: 340,
          fontSize: 14,
          borderRadius: 0,
          height: 40,
          onSubmit: () {
            // Optionally navigate to Home tab or Category screen
          },
        ),
        if (!_profileController.isLoggedIn.value) ...[
          const SizedBox(height: 15),
          CustomButton(
            text: 'SIGN IN',
            buttonColor: AppColors.whiteColor,
            textColor: AppColors.blackColor,
            borderColor: AppColors.blackColor,
            borderRadius: 0,
            width: 340,
            fontSize: 14,
            height: 40,
            onSubmit: () => RouteNavigate().navigateToPush(context, const LoginScreen()),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        final product = item.product;
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageView(url: product?.image ?? '', width: 100, height: 130),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: product?.name ?? 'Unknown Product',
                            fontSize: 14,
                            maxLine: 2,
                            textColor: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.favorite_border, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomText(text: 'US\$${item.price?.toStringAsFixed(2) ?? "0.00"}', fontSize: 18, fontWeight: FontWeight.bold),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showEditBottomSheet(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CustomText(text: 'One Size', fontSize: 12), // Placeholder for actual variants
                            const SizedBox(width: 4),
                            const Icon(Icons.edit_outlined, size: 14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _handleRemoveFromCart(item.productId!),
                          child: const CustomText(text: 'Remove', fontSize: 12, textColor: Colors.grey, decoration: TextDecoration.underline),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _handleRemoveFromCart(item.productId!),
                              child: const Icon(Icons.delete_outline, color: Colors.black54, size: 22),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  _qtyButton(Icons.remove, () => _handleUpdateQuantity(item.productId!, (item.quantity ?? 1) - 1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: CustomText(text: '${item.quantity}', fontSize: 14),
                                  ),
                                  _qtyButton(Icons.add, () => _handleUpdateQuantity(item.productId!, (item.quantity ?? 1) + 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Coupon Code',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          CustomButton(
            text: 'APPLY',
            width: 100,
            height: 45,
            borderRadius: 0,
            buttonColor: Colors.black,
            borderColor: Colors.white,
            widthDecoration: 1,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Subtotal', fontSize: 18, fontWeight: FontWeight.bold),
              CustomText(text: 'US\$${_cartData?.total?.toStringAsFixed(2) ?? "0.00"}', fontSize: 18, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 20),
          if (_cartItems.isNotEmpty)
            CustomButton(
              text: 'CHECKOUT',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
              height: 50,
              onSubmit: _handleCheckout,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleCheckout() async {
    if (_cartData == null) return;
    
    if (!_profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to continue to checkout');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }

    RouteNavigate().navigateToPush(
      context, 
      CheckoutScreen(cartData: _cartData!),
      () => _fetchCart(silent: true),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Recommended', fontSize: 18, fontWeight: FontWeight.bold),
              TextButton(
                onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
                child: const CustomText(text: 'My Favorites', textColor: AppColors.grayShade),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator(color: Colors.black))
        else
          _buildRecommendedGrid(),
      ],
    );
  }

  Widget _buildRecommendedGrid() {
    if (_recommendations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CustomText(text: 'No recommendations found'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final product = _recommendations[index];
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
                      onTap: () => _handleToggleWishlist(product.id),
                      child: Icon(
                        product.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite == true ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _handleAddToCart(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.add_shopping_cart, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (product.salePrice != null) ...[
              Row(
                children: [
                  CustomText(
                    text: 'US\$${product.salePrice!.toStringAsFixed(2)}',
                    fontWeight: FontWeight.bold,
                    textColor: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  CustomText(
                    text: 'US\$${product.price!.toStringAsFixed(2)}',
                    fontSize: 12,
                    textColor: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ],
              )
            ] else ...[
              CustomText(
                text: 'US\$${product.price?.toStringAsFixed(2) ?? "0.00"}', 
                fontWeight: FontWeight.bold
              ),
            ],
          ],
        );
      },
    );
  }

  void _showEditBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (ctx, i) => Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: NetworkImageView(url: 'https://via.placeholder.com/400x600?text=View+$i', width: 100, height: 150),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const CustomText(text: 'Floral Print Curved Hem Light Camel One Piece Swimdress', fontSize: 14, fontWeight: FontWeight.w500),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(text: 'US\$42.98', fontSize: 18, fontWeight: FontWeight.bold),
                  const CustomText(text: 'Detail >', fontSize: 12, textColor: Colors.grey),
                ],
              ),
              const SizedBox(height: 20),
              const CustomText(text: 'Color: Light Camel', fontSize: 14, fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              // Color dots placeholder
              Row(children: [Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFD2B48C), shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Colors.black, width: 2))))]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(text: 'Size(US)', fontSize: 14, fontWeight: FontWeight.bold),
                  Row(children: [const Icon(Icons.straighten, size: 16), const SizedBox(width: 4), const CustomText(text: 'Size Guide', fontSize: 12, textColor: Colors.grey)]),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _sizeChip('S | US4-6', false),
                  _sizeChip('M | US8-10', true),
                  _sizeChip('L | US12-14', false),
                  _sizeChip('XL | US16-18', false),
                  _sizeChip('XXL | US20', false),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'ADD TO BAG',
                buttonColor: Colors.black,
                textColor: Colors.white,
                borderRadius: 0,
                height: 50,
                onSubmit: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sizeChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.black : Colors.grey[300]!),
        color: isSelected ? Colors.white : Colors.white,
      ),
      child: CustomText(text: text, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
    );
  }
}
