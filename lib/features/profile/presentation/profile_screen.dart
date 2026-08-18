import 'dart:math';
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
    await Future.wait([
      _controller.fetchProfile(),
      _controller.fetchDailyCheckInStatus(),
    ]);
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
                    // _buildCheckInSection(),
                    _buildOrderSection(),
                    _buildWalletSection(),
                    _buildTabSection(),
                    if (_selectedTab == 0) _buildFavoritesContent() else _buildYouMayAlsoLikeContent(),
                  ],
                ),
              ),
            ),
            ]
        );
      }),
    );
  }

  Widget _buildCheckInSection() {
    if (!_controller.isLoggedIn.value) return const SizedBox.shrink();
    
    final checkIn = _controller.checkInData.value;
    if (checkIn == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Daily Check-in',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: 'Current Points: ${checkIn.totalPoints ?? 0}',
                    fontSize: 13,
                    textColor: AppColors.grayShade,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: checkIn.checkedInToday == true 
                    ? null 
                    : () => _controller.performDailyCheckIn(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: checkIn.checkedInToday == true ? Colors.grey : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(checkIn.checkedInToday == true ? 'Checked In' : 'Check In'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                final day = index + 1;
                final reward = checkIn.rewards?[day.toString()] ?? 0;
                final isToday = checkIn.checkedInToday == true 
                    ? (checkIn.currentDay == day) 
                    : ((checkIn.currentDay ?? 0) + 1 == day);
                final isPassed = (checkIn.currentDay ?? 0) >= day && (day != checkIn.currentDay || checkIn.checkedInToday == true);
                
                return Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isPassed
                              ? Colors.orange.shade200
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: isToday && checkIn.checkedInToday == false
                              ? Border.all(color: Colors.orange, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: isPassed
                              ? const Icon(Icons.check, size: 20, color: Colors.orange)
                              : CustomText(
                                  text: '+$reward',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.orange,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: isToday ? 'Today' : 'Day $day',
                        fontSize: 10,
                        textColor: isToday ? Colors.black : AppColors.grayShade,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE0E0E0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            // My Favorites
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0
                        ? AppColors.whiteColor
                        : Colors.transparent,
                    borderRadius: _selectedTab == 0
                        ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),


                    )
                        : const BorderRadius.only(
                      topLeft: Radius.circular(12),

                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'My Favorites',
                      fontSize: 16,
                      fontWeight: _selectedTab == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // You May Also Like
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1
                        ? AppColors.whiteColor
                        : Colors.transparent,
                    borderRadius: _selectedTab == 1
                        ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),

                    )
                        : const BorderRadius.only(
                      topRight: Radius.circular(12),

                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'You May Also Like',
                      fontSize: 16,
                      fontWeight: _selectedTab == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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


class TabShapeClipper extends CustomClipper<Path> {
  final bool isLeftSelected;

  TabShapeClipper({required this.isLeftSelected});

  @override
  Path getClip(Size size) {
    final path = Path();

    const radius = 12.0;

    if (isLeftSelected) {
      // Start top-left
      path.moveTo(radius, 0);

      // Top edge
      path.lineTo(size.width - radius, 0);

      // Top-right rounded corner
      path.quadraticBezierTo(
        size.width,
        0,
        size.width,
        radius,
      );

      // Right side
      path.lineTo(size.width, size.height - radius);

      // Bottom-right rounded corner
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      );

      // Bottom edge
      path.lineTo(radius, size.height);

      // Bottom-left rounded corner
      path.quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      );

      // Left side
      path.lineTo(0, radius);

      // Top-left rounded corner
      path.quadraticBezierTo(
        0,
        0,
        radius,
        0,
      );
    } else {
      // Start top-left
      path.moveTo(0, 0);

      // Top edge
      path.lineTo(size.width - radius, 0);

      // Top-right
      path.quadraticBezierTo(
        size.width,
        0,
        size.width,
        radius,
      );

      // Right side
      path.lineTo(size.width, size.height - radius);

      // Bottom-right
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      );

      // Bottom edge
      path.lineTo(0, size.height);

      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant TabShapeClipper oldClipper) {
    return oldClipper.isLeftSelected != isLeftSelected;
  }
}