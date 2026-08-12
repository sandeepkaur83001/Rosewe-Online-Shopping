import 'package:rosewe_online_shopping/core/common_imports.dart';

class NewInScreen extends StatefulWidget {
  const NewInScreen({super.key});

  @override
  State<NewInScreen> createState() => _NewInScreenState();
}

class _NewInScreenState extends State<NewInScreen> {
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
        elevation: 0,
        centerTitle: true,
        title: const CustomText(
          text: 'NEW IN',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
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
              const SizedBox(height: 10),
              _buildCircularCategories(),
              const SizedBox(height: 20),
              _buildBanner(),
              const SizedBox(height: 10),
              _buildProductGrid(),
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
    final categories = [
      {'name': '08-11', 'image': 'https://picsum.photos/id/1/200/200'},
      {'name': '08-10', 'image': 'https://picsum.photos/id/2/200/200'},
      {'name': '08-09', 'image': 'https://picsum.photos/id/3/200/200'},
      {'name': '08-08', 'image': 'https://picsum.photos/id/4/200/200'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.backgroundColor,
                  backgroundImage: NetworkImage(categories[index]['image']!),
                ),
                const SizedBox(height: 5),
                CustomText(text: categories[index]['name']!, fontSize: 12),
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
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  NetworkImageView(
                    url: 'https://picsum.photos/id/${index + 100}/400/600',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.favorite_border, color: AppColors.whiteColor),
                  ),
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
                CustomText(
                  text: 'US\$${(29.99 + index).toStringAsFixed(2)}',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
