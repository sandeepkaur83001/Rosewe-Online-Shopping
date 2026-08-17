import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/search/presentation/search_screen.dart';
import 'package:rosewe_online_shopping/features/favorites/presentation/favorites_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/common/custom_loader.dart';

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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

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
      final response = await ApiImplementation.getCategoryTree(showLoader: false);
      if (response.statusCode == 200) {
        final treeResponse = CategoryTreeResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          _categories = treeResponse.data ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching category tree: $e");
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
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryItem(category);
            },
          ),
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
