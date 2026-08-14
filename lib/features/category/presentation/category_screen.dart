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
  List<CategoryNode> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryTree();
  }

  Future<void> _fetchCategoryTree({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }
    try {
      final response = await ApiImplementation.getCategoryTree(showLoader: !silent);
      if (response.statusCode == 200) {
        final treeResponse = CategoryTreeResponse.fromJson(jsonDecode(response.body));
        setState(() {
          _categories = treeResponse.data ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching category tree: $e");
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
    await _fetchCategoryTree(silent: true);
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
          icon: Image.asset("assets/images/heart.png", height: 20, color: AppColors.blackColor),
          onPressed: () => RouteNavigate().navigateToPush(context, const FavoritesScreen()),
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/images/search_icon.png", height: 20, color: AppColors.blackColor),
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
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: _categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _buildRefreshBanner();
            final category = _categories[index - 1];
            return _buildCategoryItem(category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryNode category) {
    final children = category.children ?? [];
    List<Widget> subWidgets = [];

    for (var child in children) {
      if (child.children != null && child.children!.isNotEmpty) {
        subWidgets.add(_sectionHeader(child.name ?? ''));
        for (var grandChild in child.children!) {
          subWidgets.add(_subItem(grandChild.name ?? ''));
        }
      } else {
        subWidgets.add(_subHeader(child.name ?? ''));
      }
    }

    return _expandableCategory(category.name ?? '', subWidgets);
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold, textColor: Colors.black,),
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
