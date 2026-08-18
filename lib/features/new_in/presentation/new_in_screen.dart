import 'dart:math';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:intl/intl.dart';

import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/product/presentation/product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/widgets/common/custom_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewInScreen extends StatefulWidget {
  const NewInScreen({super.key});

  @override
  State<NewInScreen> createState() => _NewInScreenState();
}

class _NewInScreenState extends State<NewInScreen> {
  bool _isRefreshing = false;
  double _pullDistance = 0;
  bool _isLoading = true;
  NewInData? _newInData;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }
    try {
      final response = await ApiImplementation.getNewInProducts(showLoader: false);
      if (response.statusCode == 200) {
        final newInResponse = NewInResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          _newInData = newInResponse.data;
        });
      }
    } catch (e) {
      debugPrint("Error fetching New In products: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
    await _fetchData(silent: true);
  }

  void _handleToggleWishlist(int? productId) async {
    if (productId == null) return;
    final profileController = Get.find<ProfileController>();
    if (!profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to add items to your favorites');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }

    final body = {'product_id': productId.toString()};
    final response = await ApiImplementation.toggleWishlist(body, showLoader: true);
    if (response.statusCode == 200) {
      if (mounted) _fetchData(silent: true);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MM-dd').format(date);
    } catch (e) {
      return dateStr;
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
          text: 'NEW IN',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      child: _isLoading 
          ? const Center(child: CircularDotLoader(label: ''))
          : SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          enablePullDown: true,
          header: CustomHeader(
            height: 45,
            refreshStyle: RefreshStyle.Follow,
            onOffsetChange: (offset) {
              setState(() {
                _pullDistance = offset;
              });
            },
            builder: (context, mode) {
              String text = 'Pull Down To Refresh';
              if (mode == RefreshStatus.refreshing) {
                text = 'UPDATING NEW STYLES...';
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
                const SizedBox(height: 10),
                _buildCircularCategories(),
                const SizedBox(height: 20),
                _buildBanner(),
                const SizedBox(height: 10),
                _buildProductGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );

  }

  Widget _buildGreyRefreshBanner(String text, {double? height}) {
    final bool isRelease = text == 'Release To Refresh';
    return Container(
      width: double.infinity,
      height: height ?? 45,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: isRelease ? pi : 0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value,
                child: const Icon(
                  Icons.arrow_circle_down_sharp,
                  color: Colors.black45,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          CustomText(
            text: text,
            fontSize: 14,
            textColor: Colors.black45,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCategories() {
    final dates = _newInData?.dates ?? [];
    if (dates.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.backgroundColor,
                  child: Center(
                    child: CustomText(
                      text: _formatDate(dates[index]),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const CustomText(text: 'New In', fontSize: 10, textColor: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: CustomText(
          text: 'NEW STYLES ADDED EVERY DAY',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _newInData?.products?.data ?? [];
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CustomText(text: 'No products found'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
                    if (product.isSale == true)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.red.withOpacity(0.8),
                          child: const Center(
                            child: CustomText(text: 'SALE', fontSize: 10, textColor: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    if (product.isNew == true && product.isSale != true)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.black.withOpacity(0.1),
                          child: const Center(
                            child: CustomText(text: 'NEW', fontSize: 10, textColor: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.salePrice != null) ...[
                        CustomText(
                          text: 'US\$${product.salePrice!.toStringAsFixed(2)}',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.red,
                        ),
                        CustomText(
                          text: 'US\$${product.price!.toStringAsFixed(2)}',
                          fontSize: 11,
                          textColor: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ] else ...[
                        CustomText(
                          text: 'US\$${product.price!.toStringAsFixed(2)}',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ],
                  ),
                  const Icon(Icons.shopping_bag_outlined, size: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
