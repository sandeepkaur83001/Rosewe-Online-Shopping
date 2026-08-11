import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/search/presentation/search_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isRefreshing = false;
  double _pullDistance = 0;

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });

    // API Call Implementation (Commented for now)
    // await DummyApiImplementation.fetchCategories();

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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/rosewe_logo_clean.png',
          height: 20,
          fit: BoxFit.contain,
        ),
        leading: IconButton(
          icon: const Icon(Icons.favorite_border, color: AppColors.blackColor),
          onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/images/search_icon.png", width: 50, height: 50, color: AppColors.blackColor),
            onPressed: () => RouteNavigate().navigateToPush(context, const SearchScreen()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Image.asset("assets/images/bag_icon.png", width: 24, height: 24, color: AppColors.blackColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
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
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            _buildRefreshBanner(),
            _expandableCategory('New IN', [
              _subHeader('View All'),
              _sectionHeader('SHOP BY CATEGORY'),
              _subItem('New in Dresses'),
              _subItem('New in Tops'),
              _subItem('New in Bottoms'),
              _subItem('New in Swimwear'),
              _sectionHeader('SHOP BY DATE'),
              _subItem('New In Today'),
              _subItem('New This Week'),
              _subItem('Back In Stock'),
            ]),
            _expandableCategory('Swimwear', [
              _subHeader('View All'),
              _sectionHeader('Best Sellers'),
              _subItem('Flexible Sizing'),
              _subHeader('Plus Size Swimwear'),
              _sectionHeader('SHOP BY CATEGORY'),
              _subItem('Tankinis'),
              _subItem('Bikinis'),
              _subItem('One-Piece'),
              _subItem('Cover-Ups'),
              _subItem('Swimwear Sets'),
              _subItem('Swimwear Tops'),
              _subItem('Swimwear Bottoms'),
              _sectionHeader('SHOP BY TOP TYPE'),
              _subItem('Push-Up'),
            ]),
            _expandableCategory('TOPS', [
              _subHeader('View All'),
              _subHeader('Plus Size Tops'),
              _subItem('Lovely Bottoms'),
              _sectionHeader('SHOP BY TYPE'),
              _subItem('Tees & T-shirts'),
              _subItem('Shirts'),
              _subItem('Blouse'),
              _subItem('Sweatshirts & Hoodies'),
              _subItem('Sweaters&Cardigan'),
              _sectionHeader('Outerwear & Coats'),
              _subItem('Tank Tops & Camis'),
              _subHeader('Shrug'),
            ]),
            _simpleCategory('Dresses'),
            _simpleCategory('Jumpsuits'),
            _simpleCategory('PLUS SIZE'),
            _simpleCategory('BOTTOMS'),
            _simpleCategory('Clothing'),
            _simpleCategory('JEW&ACCS'),
          ],
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
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _expandableCategory(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
          childrenPadding: EdgeInsets.zero,
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.whiteColor,
          collapsedBackgroundColor: AppColors.whiteColor,
          iconColor: AppColors.blackColor,
          children: children,
        ),
      ),
    );
  }

  Widget _simpleCategory(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
        trailing: const Icon(Icons.keyboard_arrow_down, color: AppColors.blackColor),
        onTap: () {},
      ),
    );
  }

  Widget _subHeader(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w600),
      onTap: () {},
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: CustomText(text: title, fontSize: 14, fontWeight: FontWeight.bold, textColor: AppColors.blackColor),
    );
  }

  Widget _subItem(String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 40),
          title: CustomText(text: title, fontSize: 14, fontWeight: FontWeight.w400, textColor: AppColors.blackColor),
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
