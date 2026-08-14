import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:intl/intl.dart';

import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

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
      final response = await ApiImplementation.getNewInProducts(showLoader: !silent);
      if (response.statusCode == 200) {
        final newInResponse = NewInResponse.fromJson(jsonDecode(response.body));
        setState(() {
          _newInData = newInResponse.data;
        });
      }
    } catch (e) {
      debugPrint("Error fetching New In products: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _pullDistance = 0;
      });
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });
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
    final response = await ApiImplementation.toggleWishlist(body);
    if (response.statusCode == 200) {
      _fetchData(silent: true);
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
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : NotificationListener<ScrollNotification>(
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
      child: CustomText(
        text: text,
        fontSize: 14,
        textColor: Colors.black45,
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
        );
      },
    );
  }
}
