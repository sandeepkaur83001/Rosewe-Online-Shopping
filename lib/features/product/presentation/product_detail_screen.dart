import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  Map<String, dynamic>? _productData;
  bool _isLoading = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getProductDetail(widget.productId, showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          _productData = decoded['data'];
        });
      }
    } catch (e) {
      debugPrint("Error fetching product detail: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleToggleWishlist() async {
    if (_productData == null) return;
    if (!_profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to add items to your favorites');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }

    final body = {'product_id': _productData!['id'].toString()};
    final response = await ApiImplementation.toggleWishlist(body, showLoader: true);
    if (response.statusCode == 200) {
      if (!mounted) return;
      // Toggle local state to avoid full refresh
      setState(() {
        _productData!['is_wishlist'] = !(_productData!['is_wishlist'] ?? false);
      });
    }
  }

  void _handleAddToCart() async {
    if (_productData == null) return;
    if (!_profileController.isLoggedIn.value) {
      CustomToast.showToast(message: 'Please sign in to add items to your bag');
      RouteNavigate().navigateToPush(context, const LoginScreen());
      return;
    }

    final body = {
      'product_id': _productData!['id'].toString(),
      'quantity': '1',
    };

    final response = await ApiImplementation.addToCart(body, showLoader: true);
    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomToast.showToast(message: 'Added to bag successfully');
    } else {
      final decoded = jsonDecode(response.body);
      CustomToast.showToast(message: decoded['message'] ?? 'Failed to add to bag');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: _productData == null ? null : _buildBottomBar(),
      child: _isLoading
          ? const Center(child: CircularDotLoader(label: ''))
          : _productData == null
              ? const Center(child: CustomText(text: 'Product not found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageCarousel(),
                      _buildMainInfo(),
                      const Divider(height: 1, thickness: 8, color: Color(0xFFF7F7F7)),
                      _buildExpandableSection('Size & Fit', Icons.add),
                      const Divider(height: 1),
                      _buildProductDetailsSection(),
                      const Divider(height: 1, thickness: 8, color: Color(0xFFF7F7F7)),
                      _buildInfoRow(Icons.local_shipping_outlined, 'Shipping', 'Estimated shipped 17 Aug - 18 Aug'),
                      _buildInfoRow(Icons.assignment_return_outlined, '30 Days Easy Return', null),
                      _buildInfoRow(Icons.verified_user_outlined, 'Intellectual Property Notice', 'ALL designs and images are registered with the U.S Copyright Office.'),
                      const Divider(height: 1, thickness: 8, color: Color(0xFFF7F7F7)),
                      _buildCustomerReviews(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildImageCarousel() {
    final images = _productData!['images'] as List? ?? [];
    // If images list is empty, fallback to the main image
    final List<String> imageUrls = images.isNotEmpty 
        ? images.map((img) => img['image'].toString()).toList() 
        : [_productData!['image']?.toString() ?? ''];

    return Stack(
      children: [
        SizedBox(
          height: 500,
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) {
              return NetworkImageView(
                url: imageUrls[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: '${_currentImageIndex + 1}/${imageUrls.length}',
                  textColor: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'US\$${_productData!['price']?.toStringAsFixed(2)}',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  text: _productData!['name'] ?? '',
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
              ),
              const Icon(Icons.share_outlined, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          const CustomText(text: 'Color: Multi', fontWeight: FontWeight.bold, fontSize: 14),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sizeChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomText(text: text, fontSize: 12),
    );
  }

  Widget _buildExpandableSection(String title, IconData icon) {
    return ListTile(
      title: CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14),
      trailing: Icon(icon, size: 20),
      onTap: () {},
    );
  }

  Widget _buildProductDetailsSection() {
    return ExpansionTile(
      title: const CustomText(text: 'Product Details', fontWeight: FontWeight.bold, fontSize: 14),
      initiallyExpanded: true,
      shape: const RoundedRectangleBorder(),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      expandedAlignment: Alignment.centerLeft,
      children: [
        if (_productData!['description'] != null)
           Padding(
             padding: const EdgeInsets.only(bottom: 10.0),
             child: CustomText(text: _productData!['description'], fontSize: 13, textColor: Colors.black54),
           ),
        _detailBullet('Product ID: ${_productData!['id']}'),
        _detailBullet('Slug: ${_productData!['slug']}'),
        const SizedBox(height: 10),
        const CustomText(text: 'See More', textColor: Colors.deepOrangeAccent, fontSize: 13, decoration: TextDecoration.underline),
      ],
    );
  }

  Widget _detailBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: '• ', textColor: Colors.grey),
          Expanded(child: CustomText(text: text, fontSize: 13, textColor: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 12),
              CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 15),
              const Spacer(),
              const CustomText(text: 'More', fontSize: 12, textColor: Colors.grey),
              const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: CustomText(text: subtitle, fontSize: 13, textColor: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerReviews() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: 'Customer Reviews (0):', fontWeight: FontWeight.bold, fontSize: 15),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => const Icon(Icons.star_outline, color: Colors.deepOrangeAccent, size: 20)),
                ),
                const SizedBox(height: 10),
                const CustomText(text: 'No Reviews Yet', fontSize: 13, textColor: Colors.grey),
                const SizedBox(height: 25),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    minimumSize: const Size(double.infinity, 45),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const CustomText(text: 'BE THE FIRST TO WRITE A REVIEW', fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isWishlist = _productData!['is_wishlist'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _handleToggleWishlist,
              child: Icon(
                isWishlist ? Icons.favorite : Icons.favorite_border,
                color: isWishlist ? Colors.red : Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomButton(
                text: 'ADD TO BAG',
                buttonColor: Colors.black,
                textColor: Colors.white,
                borderRadius: 0,
                height: 48,
                margin: EdgeInsets.zero,
                onSubmit: _handleAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
