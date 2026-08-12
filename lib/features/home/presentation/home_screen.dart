import 'dart:async';

import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/widgets/common/notification_promo_dialog.dart';
import 'package:rosewe_online_shopping/features/search/presentation/search_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _bannerController;
  late PageController _secondaryCarouselController;

  Timer? _timer;
  int _currentBannerPage = 0;
  int _currentSecondaryPage = 0;
  bool _isRefreshing = false;
  double _pullDistance = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _bannerController = PageController();
    _secondaryCarouselController = PageController();
    
    _startAutoSwipe();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPromo();
    });
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || _isRefreshing || _pullDistance > 0) return;
      
      int nextBannerPage = (_currentBannerPage + 1) % 2;
      int nextSecondaryPage = (_currentSecondaryPage + 1) % 2;

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          nextBannerPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      
      if (_secondaryCarouselController.hasClients) {
        _secondaryCarouselController.animateToPage(
          nextSecondaryPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      setState(() {
        _currentBannerPage = nextBannerPage;
        _currentSecondaryPage = nextSecondaryPage;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerController.dispose();
    _secondaryCarouselController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  static bool _promoShown = false;

  void _showNotificationPromo() async {
    if (_promoShown) return;
    
    var status = await Permission.notification.status;
    if (status.isGranted) return;

    if (!mounted) return;
    _promoShown = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationPromoDialog(),
    );
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });

    // API Call Implementation (Commented for now)
    // await ApiImplementation.fetchProducts();
    // await ApiImplementation.fetchCategories();

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

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          top: true,
          bottom: false,
          child: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'assets/images/rosewe_logo_clean.png',
              height: 20,
              fit: BoxFit.contain,
            ),
            leading: IconButton(
              icon: Image.asset(
                'assets/images/heart.png',
                height: 20,
                fit: BoxFit.contain,
              ),
              onPressed: () => RouteNavigate().navigateToPush(
                context,
                const FavoritesScreen(),
              ),
            ),
            actions: [
              IconButton(
                icon: Image.asset(
                  'assets/images/search_icon.png',
                  height: 20,
                  fit: BoxFit.contain,
                ),
                onPressed: () => RouteNavigate().navigateToPush(
                  context,
                  const SearchScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
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
                    _buildTopSection(),
                    _buildGracefulShoresSection(),
                    _buildSecondaryMovingCarousel(),
                    // const SizedBox(height: 20),
                    _buildPromoBanner(),
                    // const SizedBox(height: 10),
                    _buildCategoryGrid(),
                    const SizedBox(height: 30),
                    _buildTheNewNewSection(),
                    const SizedBox(height: 20),
                    _buildDailyCheckInSection(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                    _buildProductGrid(),
                    const SizedBox(height: 80), // Padding for bottom banner
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _bottomSigninFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    if (_isRefreshing) {
      return _buildGreyRefreshBanner('UPDATING NEW STYLES...');
    }
    if (_pullDistance > 10) {
      return _buildGreyRefreshBanner(_pullDistance > 80 ? 'Release To Refresh' : 'Pull Down To Refresh');
    }
    return _buildBannerCarousel();
  }

  Widget _buildGreyRefreshBanner(String text) {
    return Container(
      width: double.infinity,
      height: 45,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: CustomText(
        text: text,
        fontSize: 14,
        textColor: Colors.black45,
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 45,
      child: PageView(
        controller: _bannerController,
        onPageChanged: (index) {
          if (_currentBannerPage != index) {
            setState(() {
              _currentBannerPage = index;
            });
          }
        },
        children: [
          _buildReturnsBanner('30 DAYS EASY RETURNS FOR US!', AppColors.blackColor),
          _buildReturnsBanner('FREE SHIPPING ON ORDERS OVER \$59', Colors.grey[800]!),
        ],
      ),
    );
  }

  Widget _buildReturnsBanner(String text, Color color) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            textColor: Colors.white,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: _currentBannerPage == index ? Colors.white : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryMovingCarousel() {
    return SizedBox(
      height: 250,
      child: PageView(
        controller: _secondaryCarouselController,
        onPageChanged: (index) {
          setState(() {
            _currentSecondaryPage = index;
          });
        },
        children: [
          _buildResortDressSection(),
          _buildTummyControlSection(),
        ],
      ),
    );
  }

  Widget _buildGracefulShoresSection() {
    return Image.asset(
      'assets/images/graceful.jpg',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildResortDressSection() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/banner_effortless_tummy_clear.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD180), width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'EFFORTLESS TUMMY',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.orange,
                    ),
                    const SizedBox(height: 5),
                    const CustomText(
                      text: 'Smooth looks, easy days.',
                      fontSize: 12,
                      textColor: AppColors.blackColor,
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'SHOP NOW >>',
                      buttonColor: AppColors.blackColor,
                      borderRadius: 0,
                      height: 35,
                      width: 130,
                      fontSize: 12,
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTummyControlSection() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: NetworkImageView(
              url: 'https://picsum.photos/id/102/600/800',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.5), width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'TUMMY CONTROL',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.blueAccent,
                    ),
                    const SizedBox(height: 5),
                    const CustomText(
                      text: 'Sculpt your summer body.',
                      fontSize: 12,
                      textColor: AppColors.blackColor,
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'SHOP NOW >>',
                      buttonColor: AppColors.blackColor,
                      borderRadius: 0,
                      height: 35,
                      width: 130,
                      fontSize: 12,
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return const Column(
      children: [
        CustomText(
          text: 'Up To 70% OFF',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'SWIMWEAR', 'image': 'https://picsum.photos/id/101/400/200'},
      {'name': 'TOPS', 'image': 'https://picsum.photos/id/102/400/200'},
      {'name': 'DRESSES', 'image': 'https://picsum.photos/id/103/400/200'},
      {'name': 'JUMPSUITS', 'image': 'https://picsum.photos/id/104/400/200'},
      {'name': 'PLUS SIZE', 'image': 'https://picsum.photos/id/105/400/200'},
      {'name': 'BOTTOMS', 'image': 'https://picsum.photos/id/106/400/200'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: CustomText(
                    text: categories[index]['name']!,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: NetworkImageView(
                  url: categories[index]['image']!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTheNewNewSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CustomText(text: 'The New New', fontSize: 18, fontWeight: FontWeight.bold),
                  const SizedBox(width: 8),
                  CustomText(text: '100+ Styles Added!', fontSize: 12, textColor: AppColors.grayShade),
                ],
              ),
              const Icon(Icons.chevron_right, color: AppColors.grayShade),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          NetworkImageView(
                            url: 'https://picsum.photos/id/${index + 20}/300/450',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: const Icon(Icons.favorite_border, size: 14, color: Colors.red),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: const Icon(Icons.shopping_bag_outlined, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomText(text: 'US\$${(36.98 + index).toStringAsFixed(2)}', fontSize: 14, fontWeight: FontWeight.bold),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyCheckInSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF8F8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: 'Daily check-in & Get your Free Gifts', fontSize: 14, fontWeight: FontWeight.bold),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: index == 0 ? Colors.orange.withOpacity(0.2) : Colors.pink.withOpacity(0.1),
                    child: CustomText(text: '+${(index + 2) * 10}', fontSize: 10, textColor: Colors.pink),
                  ),
                  const SizedBox(height: 8),
                  CustomText(text: index == 0 ? 'Today' : '08-${11 + index}', fontSize: 10, textColor: AppColors.grayShade),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Center(
            child: CustomButton(
              text: 'Login to check-in',
              width: 200,
              height: 40,
              buttonColor: AppColors.blackColor,
              borderRadius: 4,
              onSubmit: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: AppColors.blackColor,
      unselectedLabelColor: AppColors.grayShade,
      indicatorColor: AppColors.blackColor,
      indicatorWeight: 2,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      tabs: const [
        Tab(text: 'BEST SELLERS'),
        Tab(text: 'NEW'),
        Tab(text: 'DRESSES'),
        Tab(text: 'JUMPSUITS'),
        Tab(text: 'TOPS'),
      ],
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  NetworkImageView(
                    url: 'https://picsum.photos/id/${index + 50}/300/450',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: const Icon(Icons.favorite_border, size: 18, color: Colors.white),
                  ),
                  if (index % 3 == 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.red,
                        child: const CustomText(text: 'Sale', fontSize: 10, textColor: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'US\$${(22.98 + index * 5).toStringAsFixed(2)}', fontSize: 12, fontWeight: FontWeight.bold),
                const Icon(Icons.shopping_bag_outlined, size: 16),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _bottomSigninFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF1F1),
        border: Border(top: BorderSide(color: Color(0xFFFEE2E2))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: CustomText(text: 'Sign in for the best experience', fontSize: 18, fontWeight: FontWeight.w500),
          ),
          CustomButton(
            text: 'Sign In',
            width: 100,
            padding: EdgeInsets.zero,
            height: 36,
            borderRadius: 0,
            borderColor: Colors.transparent,
            elevation: 0,
            buttonColor: AppColors.blackColor,
            onSubmit: () {
              RouteNavigate().navigateToPush(context, const LoginScreen());
            },
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
