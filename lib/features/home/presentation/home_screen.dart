import 'dart:async';

import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/new_in/presentation/new_in_screen.dart';
import 'package:rosewe_online_shopping/models/home/new_in_model.dart';
import 'package:rosewe_online_shopping/widgets/common/notification_promo_dialog.dart';
import 'package:rosewe_online_shopping/features/search/presentation/search_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';
import 'package:rosewe_online_shopping/features/points_mall/presentation/points_mall_screen.dart';
import 'package:rosewe_online_shopping/features/product/presentation/product_list_screen.dart';
import 'package:rosewe_online_shopping/features/product/presentation/product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/home/controller/home_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _bannerController;
  late PageController _secondaryCarouselController;
  final ProfileController _profileController = Get.find<ProfileController>();
  final HomeController _homeController = Get.find<HomeController>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

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

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        String type = '';
        switch (_tabController.index) {
          case 0: type = 'best_sellers'; break;
          case 1: type = 'new'; break;
          case 2: type = 'dresses'; break;
          case 3: type = 'jumpsuits'; break;
          case 4: type = 'tops'; break;
        }
        if (type.isNotEmpty) {
          _homeController.fetchTabProducts(type);
        }
      }
    });

    // Initial fetch for the first tab
    _homeController.fetchTabProducts('best_sellers');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPromo();
    });
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || _isRefreshing || _pullDistance > 0) return;
      
      int nextBannerPage = 0;
      if (_homeController.announcements.isNotEmpty) {
        nextBannerPage = (_currentBannerPage + 1) % _homeController.announcements.length;
      }
      
      int nextSecondaryPage = (_currentSecondaryPage + 1) % 2;

      if (_bannerController.hasClients && _homeController.announcements.isNotEmpty) {
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

    await _homeController.refreshData();

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _pullDistance = 0;
      });
    }
    _refreshController.refreshCompleted();
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
      // Refresh data to reflect wishlist status
      _homeController.refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          top: true,
          bottom: false,
          child: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            centerTitle: true,
            // title: Image.asset(
            //   'assets/images/rosewe_logo_clean.png',
            //   height: 20,
            //   fit: BoxFit.contain,
            // ),
            leading: IconButton(
              icon: Image.asset(
                'assets/images/heart.png',
                height: 20,
                fit: BoxFit.contain,
              ),
              onPressed: () async {
                await RouteNavigate().navigateToPush(
                  context,
                  const FavoritesScreen(),
                );
                // Refresh home data in case anything was changed in favorites screen
                _homeController.refreshData();
              },
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
        child: Column(
          children: [
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
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Obx(() => _buildBannerCarousel()),
                    _buildGracefulShoresSection(),
                    Obx(() {
                      return _buildSecondaryMovingCarousel();
                    }),
                    _buildPromoBanner(),
                    _buildCategoryGrid(),
                    const SizedBox(height: 30),
                    _buildTheNewNewSection(),
                    const SizedBox(height: 20),
                    _buildDailyCheckInSection(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                    _buildProductGrid(),
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
            ),
          Obx(() {
            debugPrint("HomeScreen Login Status: ${_profileController.isLoggedIn.value}");
            if (_profileController.isLoggedIn.value) {
              return const SizedBox.shrink();
            }
            return _bottomSigninFooter(context);
          }),
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
    return Obx(() => _buildBannerCarousel());
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

  Widget _buildBannerCarousel() {
    if (_homeController.announcements.isEmpty) {
      return SizedBox(
        height: 45,
        child: _buildReturnsBanner('30 DAYS EASY RETURNS FOR US!', AppColors.blackColor),
      );
    }

    return SizedBox(
      height: 45,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _homeController.announcements.length,
        onPageChanged: (index) {
          if (_currentBannerPage != index) {
            setState(() {
              _currentBannerPage = index;
            });
          }
        },
        itemBuilder: (context, index) {
          final announcement = _homeController.announcements[index];
          return _buildReturnsBanner(
            announcement.title?.toUpperCase() ?? '',
            index % 2 == 0 ? AppColors.blackColor : Colors.grey[800]!,
          );
        },
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
          if (_homeController.announcements.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_homeController.announcements.length, (index) {
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
      height: 220,
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
    final banner = _homeController.banners.length > 1 ? _homeController.banners[1] : null;
    
    return Container(
      color: Colors.white,

      child: Row(
        children: [
          Expanded(

            child: NetworkImageView(
              url: banner?.image ?? '',
              fit: BoxFit.contain,
              placeholder: Image.asset(
                'assets/images/banner_effortless_tummy_clear.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Expanded(
          //   flex: 6,
          //   child: Container(
          //     padding: const EdgeInsets.all(20),
          //     child: Container(
          //       padding: const EdgeInsets.all(12),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: const Color(0xFFFFD180), width: 4),
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           CustomText(
          //             text: banner?.title?.toUpperCase() ?? 'EFFORTLESS TUMMY',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             textColor: Colors.orange,
          //             align: TextAlign.center,
          //           ),
          //           const SizedBox(height: 5),
          //           const CustomText(
          //             text: 'Smooth looks, easy days.',
          //             fontSize: 12,
          //             textColor: AppColors.blackColor,
          //           ),
          //           const SizedBox(height: 15),
          //           CustomButton(
          //             text: 'SHOP NOW >>',
          //             buttonColor: AppColors.blackColor,
          //             borderRadius: 0,
          //             height: 35,
          //             width: 130,
          //             fontSize: 12,
          //             margin: EdgeInsets.zero,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTummyControlSection() {
    final banner = _homeController.banners.length > 1 ? _homeController.banners[0] : null;
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            // flex: 4,
            child: NetworkImageView(
              url:  banner?.image ?? '',
              fit: BoxFit.cover,
            ),
          ),
          // Expanded(
          //   flex: 6,
          //   child: Container(
          //     padding: const EdgeInsets.all(20),
          //     child: Container(
          //       padding: const EdgeInsets.all(12),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.lightBlueAccent.withValues(alpha: 0.5), width: 4),
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const CustomText(
          //             text: 'TUMMY CONTROL',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             textColor: Colors.blueAccent,
          //           ),
          //           const SizedBox(height: 5),
          //           const CustomText(
          //             text: 'Sculpt your summer body.',
          //             fontSize: 12,
          //             textColor: AppColors.blackColor,
          //           ),
          //           const SizedBox(height: 15),
          //           CustomButton(
          //             text: 'SHOP NOW >>',
          //             buttonColor: AppColors.blackColor,
          //             borderRadius: 0,
          //             height: 35,
          //             width: 130,
          //             fontSize: 12,
          //             margin: EdgeInsets.zero,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Obx(() {
      final offer = _homeController.offerCategory.value;
      if (offer == null || (offer.categories?.isEmpty ?? true)) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
              ),
              children: [
                const TextSpan(
                  text: 'Up To ',
                  style: TextStyle(
                    fontFamily: 'PinyonScript',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: offer.label?.replaceAll('Up To ', '') ?? ' 70% OFF',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: offer.categories!.length,
            itemBuilder: (context, index) {
              final cat = offer.categories![index];
              return GestureDetector(
                onTap: () => RouteNavigate().navigateToPush(
                  context,
                  ProductListScreen(title: cat.name ?? '', categoryId: cat.id),
                ),
                child: NetworkImageView(
                  url: cat.image ?? '',
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildCategoryGrid() {
    return Obx(() {
      final categories = _homeController.categories;
      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

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
        itemCount: categories.length > 6 ? 6 : categories.length, // Limit to 6 for the grid
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: CustomText(
                      text: cat.name ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: NetworkImageView(
                    url: cat.image ?? 'https://picsum.photos/id/${100 + index}/400/200',
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildTheNewNewSection() {
    return Obx(() {
      final products = _homeController.newArrivals;
      if (products.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          GestureDetector(
            onTap:(){
              RouteNavigate().navigateToPush(context, NewInScreen());

            },
            child: Padding(
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
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
                  itemBuilder: (context, index) {
                final productMap = products[index];
                final product = NewInProduct.fromJson(productMap);
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
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
                                url: product.image ?? 'https://picsum.photos/id/${index + 20}/300/450',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _handleToggleWishlist(product.id),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                                    child: Icon(
                                      product.isFavorite == true 
                                          ? Icons.favorite 
                                          : Icons.favorite_border, 
                                      size: 14, 
                                      color: Colors.red
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                                  child: const Icon(Icons.shopping_bag_outlined, size: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text: 'US\$${(product.price ?? (36.98 + index)).toStringAsFixed(2)}',
                          fontSize: 14, 
                          fontWeight: FontWeight.bold
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
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
              text: 'Check In',
              width: 200,
              height: 40,
              buttonColor: AppColors.blackColor,
              borderRadius: 4,
              onSubmit: () {},
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              CustomText(text: "To explore more functionalities, please chick on "),
              GestureDetector(
                onTap: () => RouteNavigate().navigateToPush(context, const PointsMallScreen()),
                child: const CustomText(text: "View More.", isUnderline: true),
              )
            ],
          )

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
    return Obx(() {
      final products = _homeController.tabProducts.isNotEmpty 
          ? _homeController.tabProducts 
          : _homeController.bestSellers;
      
      if (_homeController.isTabLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator(color: AppColors.primaryDarkColor,)),
        );
      }

      if (products.isEmpty) return const SizedBox.shrink();

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
        itemCount: products.length,
        itemBuilder: (context, index) {
          final productMap = products[index];
          final product = NewInProduct.fromJson(productMap);
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
                        url: product.image ?? 'https://picsum.photos/id/${index + 50}/300/450',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _handleToggleWishlist(product.id),
                          child: Icon(
                            product.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: product.isFavorite == true ? Colors.red : Colors.white,
                          ),
                        ),
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
                    CustomText(
                      text: 'US\$${(product.price ?? (22.98 + index * 5)).toStringAsFixed(2)}',
                      fontSize: 12, 
                      fontWeight: FontWeight.bold
                    ),
                    const Icon(Icons.shopping_bag_outlined, size: 16),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
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
