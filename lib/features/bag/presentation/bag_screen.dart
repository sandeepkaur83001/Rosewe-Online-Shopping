import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/checkout/presentation/checkout_screen.dart';
import 'package:rosewe_online_shopping/features/product/presentation/product_detail_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/common/custom_loader.dart';

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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      if (mounted) setState(() => _isLoading = true);
    }
    List<Future> futures = [_fetchRecommendations(silent: true)];
    if (_profileController.isLoggedIn.value) {
      futures.add(_fetchCart(silent: true));
    }
    await Future.wait(futures);
    if (!silent) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCart({bool silent = false}) async {
    try {
      final response = await ApiImplementation.getCart(showLoader: false);
      if (response.statusCode == 200) {
        final cartRes = CartResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
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
      final response = await ApiImplementation.getCartRecommendations(showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          if (!mounted) return;
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
      if (silent && mounted) {
        setState(() {
          _isRefreshing = false;
          _pullDistance = 0;
        });
      }
      _refreshController.refreshCompleted();
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }
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
    final response = await ApiImplementation.addToCart(body, showLoader: true);
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
    final response = await ApiImplementation.updateCart(body, showLoader: true);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _fetchCart(silent: true);
    }
  }

  void _handleRemoveFromCart(int productId) async {
    final response = await ApiImplementation.removeFromCart(productId.toString(), showLoader: true);
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
    final response = await ApiImplementation.toggleWishlist(body, showLoader: true);
    if (response.statusCode == 200) {
      _fetchRecommendations(silent: true);
      _fetchCart(silent: true);
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.blackColor),
            onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
          ),
        ],
      ),
      bottomNavigationBar: _isLoading || _cartItems.isEmpty ? null : _buildStickyBottomBar(),
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
          return false;
        },
        child: _isLoading 
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(80.0),
                child: CircularDotLoader(label: ''),
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: true,
              header: CustomHeader(
                height: 45,
                refreshStyle: RefreshStyle.Follow,
                builder: (context, mode) {
                  String text = 'Pull Down To Refresh';
                  if (mode == RefreshStatus.refreshing) {
                    text = 'UPDATING...';
                  } else if (mode == RefreshStatus.canRefresh) {
                    text = 'Release To Refresh';
                  } else if (mode == RefreshStatus.completed) {
                    text = 'UPDATED';
                  } else if (mode == RefreshStatus.failed) {
                    text = 'FAILED';
                  }
                  return _buildGreyRefreshBanner(
                    text,
                    height: _pullDistance > 45 ? _pullDistance : 45
                  );
                },
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildShippingProgress(),
                    if (_cartItems.isEmpty)
                      Obx(() => _buildEmptyState())
                    else
                      _buildCartList(),
                    if (_cartItems.isNotEmpty) ...[
                      _buildCouponSection(),
                      _buildOrderSummary(),
                    ],
                    _buildRecommendedSection(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildGreyRefreshBanner(String text, {double? height}) {
    return Container(
      width: double.infinity,
      height: height ?? 45,
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: CustomText(text: text, fontSize: 14, textColor: Colors.black45),
    );
  }

  Widget _buildShippingProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              value: 0.3,
              strokeWidth: 3,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Add CA\$30.92 more to enjoy',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: 'Free Standard Shipping.',
                  fontSize: 13,
                  textColor: Colors.black54,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const CustomText(
              text: '+ ADD',
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
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
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
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
                            fontSize: 13,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            textColor: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _handleToggleWishlist(item.productId),
                        ),
                      ],
                    ),
                    CustomText(
                      text: 'CA\$${item.price?.toStringAsFixed(2) ?? "0.00"}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    const CustomText(
                      text: '24h Dispatch',
                      fontSize: 12,
                      textColor: Colors.orange,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _showEditBottomSheet(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText(text: 'Multi Color | EU36/US6', fontSize: 13),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_outlined, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      text: 'Only 9 pcs',
                      fontSize: 12,
                      textColor: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _handleRemoveFromCart(item.productId!),
                          child: const CustomText(
                            text: 'Remove',
                            fontSize: 12,
                            textColor: Colors.black54,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              _qtyButton(Icons.delete_outline, () => _handleRemoveFromCart(item.productId!), size: 18),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(text: '${item.quantity}', fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              _qtyButton(Icons.add, () => _handleUpdateQuantity(item.productId!, (item.quantity ?? 1) + 1), size: 18),
                            ],
                          ),
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

  Widget _qtyButton(IconData icon, VoidCallback onTap, {double size = 16}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: size, color: Colors.black),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Coupon Code',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const CustomText(
                text: 'APPLY',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Subtotal', fontSize: 18, fontWeight: FontWeight.bold),
              CustomText(
                text: 'CA\$${_cartData?.total?.toStringAsFixed(2) ?? "0.00"}',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: '(Reward 27 R Points)',
                fontSize: 11,
                textColor: Colors.orange.shade800,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.help_outline, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: '${_cartItems.length} Item(s)', fontSize: 14, fontWeight: FontWeight.bold),
              CustomText(
                text: 'CA\$${_cartData?.total?.toStringAsFixed(2) ?? "0.00"}',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'Shipping Cost', fontSize: 14, textColor: Colors.black54),
              CustomText(text: 'Calculated at next step', fontSize: 14, textColor: Colors.black54),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Recommended', fontSize: 16, fontWeight: FontWeight.bold),
              GestureDetector(
                onTap: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
                child: const CustomText(
                  text: 'My Favorites',
                  fontSize: 14,
                  textColor: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final product = _recommendations[index];
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
                      bottom: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => _handleAddToCart(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              CustomText(
                text: 'CA\$${product.price?.toStringAsFixed(2) ?? "0.00"}', 
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: 'Subtotal: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: 'CA\$${_cartData?.total?.toStringAsFixed(2) ?? "0.00"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'CHECKOUT',
              buttonColor: Colors.black,
              textColor: Colors.white,
              borderRadius: 4,
              height: 42,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              onSubmit: _handleCheckout,
            ),
          ],
        ),
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
