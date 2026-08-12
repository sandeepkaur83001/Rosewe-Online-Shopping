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
    return BaseScreen(
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
          icon: Image.asset("assets/images/heart.png",  height: 20, color: AppColors.blackColor),
          onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/images/search_icon.png",  height: 20, color: AppColors.blackColor),
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
              _subItem('Bra & Triangle'),
              _subItem('Adjustable'),
              _subItem('Tummy Coverage'),
              _subItem('Blouson'),
              _sectionHeader('SHOP BY BOTTOM TYPE'),
              _subItem('Briefs'),
              _subItem('Cheeky'),
              _subItem('Shorts'),
              _subItem('Skirts'),
              _sectionHeader('SHOP BY TREND'),
              _subItem('Leopard & Animal'),
              _subItem('Sexy Chic'),
              _subItem('Ruffle Design'),
              _subItem('Solid'),
              _subItem('Stripe & Dot'),
              _subItem('Tropical Print'),
              _subItem('Tribal Print'),
              _subItem('Halter Neck'),
              _sectionHeader('SHOP BY COLOR'),
              _subItem('Elegant Black'),
              _subItem('Sexy Red'),
              _subItem('Orange & Yellow'),
              _subItem('Vibrant Blue'),
              _subItem('Purple & Pink'),
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
              _sectionHeader('SHOP BY STYLE'),
              _subItem('Casual'),
              _subItem('Party'),
              _subItem('Long Sleeve'),
              _subItem('Off the Shoulder'),
              _subItem('Tummy Coverage'),
              _sectionHeader('SHOP BY COLOR'),
              _subItem('Elegant Black'),
              _subItem('Red Tops'),
              _subItem('White Tops'),
              _subItem('Yellow & Orange'),
              _subItem('Charm Blue'),
            ]),
            _expandableCategory('Dresses', [
              _subHeader('View All'),
              _subHeader('Best Sellers'),
              _sectionHeader('SHOP BY OCCASION'),
              _subItem('Party Dresses'),
              _subItem('Church Attire'),
              _subItem('Vacation Dresses'),
              _subItem('Wedding Guest'),
              _subItem('Prom Dresses'),
              _subItem('Cozy Casual'),
              _subItem('Work Wear'),
              _sectionHeader('SHOP BY TREND'),
              _subItem('X Shape Dresses'),
              _subItem('Bodycon Dresses'),
              _subItem('Plaid Dresses'),
              _subItem('Flared Sleeve'),
              _subItem('Straight Dresses'),
              _subItem('Peplum Dresses'),
              _subItem('Floral Dresses'),
              _sectionHeader('SHOP BY LENGTH'),
              _subItem('Maxi Dresses'),
              _subItem('Midi Dresses'),
              _subItem('Long Sleeve'),
              _subItem('Three Quarters Sleeve'),
              _subItem('Short Sleeve'),
              _subItem('Sleeveless'),
              _sectionHeader('SHOP BY COLOR'),
              _subItem('Black Dresses'),
              _subItem('White Dresses'),
              _subItem('Blue Dresses'),
              _subItem('Red Dresses'),
              _subItem('Pink & Purple Dresses'),
              _subItem('Green Dresses'),
            ]),
            _expandableCategory('Jumpsuits', [
              _subHeader('View All'),
              _sectionHeader('Best Sellers'),
              _subItem('Jumpsuits'),
              _subItem('Rompers'),
              _subHeader('Shapewear'),
              _sectionHeader('SHOP BY OCCASION'),
              _subItem('Party & Cocktail'),
              _sectionHeader('SHOP BY COLOR'),
              _subItem('Blue Jumpsuits'),
            ]),
            _expandableCategory('PLUS SIZE', [
              _subHeader('View All'),
              _sectionHeader('SHOP BY TYPE'),
              _subItem('Plus Size Tops'),
              _sectionHeader('PLUS SIZE SWIMWEAR'),
              _subItem('Plus Size Tankini'),
              _subItem('Plus Size Bikinis'),
              _subItem('Plus Size One Piece'),
              _subItem('Plus Size Swimwear Bottom'),
              _subItem('Plus Size Swimwear Sets'),
              _sectionHeader('SHOP BY COLOR'),
              _subItem('Elegant Black'),
              _subItem('Pink & Purple'),
              _subItem('Hot Red'),
              _subItem('Charm Blue'),
            ]),
            _expandableCategory('BOTTOMS', [
              _subHeader('View All'),
              _sectionHeader('SHOP BY TYPE'),
              _subItem('Denim & Jeans'),
              _subItem('Leggings'),
              _subItem('Skirts'),
              _subItem('Pants'),
              _subItem('Shorts'),
              _subHeader('Jumpsuits & Rompers'),
              _subHeader('Lovely Tops'),
              _sectionHeader('SHOP BY STYLE'),
              _subItem('Classic Black'),
              _subItem('Elegant Blue'),
              _subItem('High Waisted'),
              _subItem('Mid Waisted'),
              _subItem('Skinny Picks'),
            ]),
            _expandableCategory('Clothing', [
              _subHeader('View All'),
              _subHeader('New Arrivals'),
              _subHeader('Must Have Classics'),
              _subHeader('Lounge Wear'),
              _sectionHeader('DRESSES'),
              _subItem('Maxi Dresses'),
              _subItem('Midi Dresses'),
              _subItem('Bodycon Dresses'),
              _subItem('Party Dresses'),
              _sectionHeader('TOPS'),
              _subItem('Blouse'),
              _subItem('Shirts'),
              _subItem('Tees & T-shirts'),
              _subItem('Tank Tops & Camis'),
              _subItem('Sweatshirts'),
              _subItem('Sweaters'),
              _subItem('Tunic Tops'),
              _subItem('Cardigans'),
              _subHeader('Outerwear & Coats'),
              _sectionHeader('SWIMWEAR'),
              _subItem('Bikini'),
              _subItem('Tankini'),
              _subItem('One-Piece'),
              _subItem('Cover Ups'),
              _subItem('Swimwear Bottom'),
              _sectionHeader('JUMPSUITS & ROMPERS'),
              _subItem('Jumpsuits'),
              _subItem('Rompers'),
              _sectionHeader('BOTTOMS'),
              _subItem('Pants'),
              _subItem('Denim & Jeans'),
              _subItem('Leggings'),
              _subItem('Shorts'),
              _subItem('Skirts'),
              _sectionHeader('PLUS SIZE'),
              _subItem('Plus Size Swimwear'),
              _subItem('Plus Size Tops'),
              _subHeader('INTIMATES'),
              _subHeader('Lace Picks'),
              _subHeader('Sparkle Picks'),
            ]),
            _expandableCategory('JEW&ACCS', [
              _subHeader('View All'),
              _subHeader('Pearl Design'),
              _subHeader('Party Picks'),
              _subHeader('Golden Picks'),
              _subHeader('Vacation Picks'),
              _sectionHeader('JEWELRY'),
              _subItem('Earrings'),
              _subItem('Anklets'),
              _subItem('Necklaces & Pendants'),
              _subItem('Bracelets & Bangles'),
              _sectionHeader('ACCESSORIES'),
              _subItem('Hats'),
              _subItem('Bags'),
              _subItem('Beach Blanket'),
              _subItem('Sunglasses'),
              _subItem('Phone Accessories'),
              _subHeader('SHOES'),
            ]),
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
          title: CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold,textColor: Colors.black,),
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
