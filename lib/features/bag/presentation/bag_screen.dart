import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  bool _isRefreshing = false;
  double _pullDistance = 0;

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _pullDistance = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
          return false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildRefreshBanner(),
              const SizedBox(height: 40),
              // Empty Bag Illustration Placeholder
              Image.asset(
                "assets/images/shopping_bags_asset.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const CustomText(text: 'You bag is empty', fontSize: 18, fontWeight: FontWeight.w500),
              const SizedBox(height: 10),
              const CustomText(text: 'Have an account? Sign in to view your bag.', fontSize: 14, textColor: AppColors.grayShade),
              const SizedBox(height: 30),
              CustomButton(
                text: 'START SHOPPING',
                buttonColor: AppColors.blackColor,
                textColor: AppColors.whiteColor,
                borderColor: Colors.transparent,
                elevation: 0,
                width: 340,
                fontSize: 14,
                borderRadius: 0,
                height: 40,
                onSubmit: () {},
              ),
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
                elevation: 0,
                onSubmit: () {
                  RouteNavigate().navigateToPush(context, const LoginScreen());
                },
              ),
              const SizedBox(height: 40),
              // Recommended Section
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
              _buildRecommendedGrid(),
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

  Widget _buildRecommendedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  NetworkImageView(
                    url: 'https://picsum.photos/id/${index + 60}/400/600',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.add_shopping_cart, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomText(text: 'US\$${(25.99 + index * 3).toStringAsFixed(2)}', fontWeight: FontWeight.bold),
          ],
        );
      },
    );
  }
}
