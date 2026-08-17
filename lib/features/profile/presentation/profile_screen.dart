import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/account_settings_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/order/presentation/order_history_screen.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0 for My Favorites, 1 for You May Also Like
  final ProfileController _controller = Get.find<ProfileController>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  double _pullDistance = 0;

  @override
  void initState() {
    super.initState();
    _controller.fetchInitialData();
  }

  void _onRefresh() async {
    await _controller.fetchProfile();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _pullDistance = 0;
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF1F1),
        elevation: 0,
        toolbarHeight: 0, // Hidden app bar but provides status bar styling
      ),
      child: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularDotLoader(label: ''));
        }
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SmartRefresher(
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _buildOrderSection(),
                    _buildWalletSection(),
                    _buildTabSection(),
                    if (_selectedTab == 0) _buildFavoritesContent() else _buildYouMayAlsoLikeContent(),
                  ],
                ),
              ),
            ),
            )],
        );
      }),
    );
  }

  Widget _buildGreyRefreshBanner(String text, {double? height}) {
    return Container(
      width: double.infinity,
      height: height ?? 45,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: CustomText(
        text: text,
        fontSize: 14,
        textColor: Colors.black45,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: const Color(0xFFFFF1F1), // Light pinkish background as seen in screenshot
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (!_controller.isLoggedIn.value) {
                RouteNavigate().navigateToPush(context, const LoginScreen());
              }
            },
            child: Row(
              children: [
                CustomText(
                  text: _controller.isLoggedIn.value 
                      ? 'Hi, ${_controller.userProfile.value?.name ?? _controller.userProfile.value?.email ?? 'User'}'
                      : 'Sign In/Create Account',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                if (!_controller.isLoggedIn.value) const Icon(Icons.chevron_right, size: 24),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 28),
            onPressed: () {
              RouteNavigate().navigateToPush(context, const AccountSettingsScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required String title, String? trailingText, VoidCallback? onTrailingTap, required Widget content}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: title, fontSize: 16, fontWeight: FontWeight.bold),
              if (trailingText != null)
                GestureDetector(
                  onTap: onTrailingTap,
                  child: CustomText(
                    text: trailingText,
                    fontSize: 12,
                    textColor: AppColors.grayShade,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildOrderSection() {
    return _buildSectionContainer(
      title: 'My Order',
      trailingText: 'View All>',
      onTrailingTap: () {
        if (_controller.isLoggedIn.value) {
          RouteNavigate().navigateToPush(context, const OrderHistoryScreen());
        } else {
          RouteNavigate().navigateToPush(context, const LoginScreen());
        }
      },
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: _buildIconItem(Icons.check_circle_outline, 'Confirmed', onTap: () => _navigateToOrders())),
          Expanded(child: _buildIconItem(Icons.inventory_outlined, 'Delivered', onTap: () => _navigateToOrders())),
          const Expanded(child: SizedBox()),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  void _navigateToOrders() {
    if (_controller.isLoggedIn.value) {
      RouteNavigate().navigateToPush(context, const OrderHistoryScreen());
    } else {
      RouteNavigate().navigateToPush(context, const LoginScreen());
    }
  }

  Widget _buildWalletSection() {
    final profile = _controller.userProfile.value;
    return _buildSectionContainer(
      title: 'My Wallet',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: _buildIconItem(
            Icons.layers_outlined, 
            'Points', 
            badgeValue: profile?.points?.toString()
          )),
          const Expanded(child: SizedBox()),
          const Expanded(child: SizedBox()),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildIconItem(IconData icon, String label, {String? badgeValue, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (badgeValue != null && badgeValue != '0' && badgeValue != '0.00')
            CustomText(
              text: badgeValue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
          else
            Icon(icon, size: 30),
          const SizedBox(height: 8),
          CustomText(text: label, fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? AppColors.whiteColor : const Color(0xFFE0E0E0),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: Center(
                  child: CustomText(
                    text: 'My Favorites',
                    fontSize: 16,
                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? AppColors.whiteColor : const Color(0xFFE0E0E0),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                ),
                child: Center(
                  child: CustomText(
                    text: 'You May Also Like',
                    fontSize: 16,
                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const Icon(Icons.description_outlined, size: 80, color: Color(0xFFFFDAB9)),
              Positioned(
                bottom: 20,
                right: 20,
                child: const Icon(Icons.favorite, size: 24, color: Colors.redAccent),
              ),
              const Icon(Icons.edit, size: 24, color: Colors.orangeAccent),
            ],
          ),
          const SizedBox(height: 16),
          if (!_controller.isLoggedIn.value)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => RouteNavigate().navigateToPush(context, const LoginScreen()),
                  child: const CustomText(
                    text: 'Sign in',
                    fontSize: 14,
                    textColor: Colors.orangeAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const CustomText(
                  text: ' to view your favorites.',
                  fontSize: 14,
                  textColor: AppColors.grayShade,
                ),
              ],
            )
          else
            const CustomText(
              text: 'You haven\'t added any favorites yet.',
              fontSize: 14,
              textColor: AppColors.grayShade,
            ),
        ],
      ),
    );
  }

  Widget _buildYouMayAlsoLikeContent() {
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CustomText(text: 'Suggestions appear here'),
      ),
    );
  }
}
