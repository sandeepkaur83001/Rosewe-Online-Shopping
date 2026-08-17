import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/main_nav/presentation/main_nav_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/new_address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartData cartData;
  const CheckoutScreen({super.key, required this.cartData});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<AddressData> _addresses = [];
  AddressData? _selectedAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getAddresses(showLoader: false);
      if (response.statusCode == 200) {
        final addressResponse = AddressResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          _addresses = addressResponse.data ?? [];
          if (_addresses.isNotEmpty) {
            _selectedAddress = _addresses.firstWhere((a) => a.isDefault == 1, orElse: () => _addresses.first);
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching addresses: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handlePlaceOrder() async {
    if (_selectedAddress == null) {
      CustomToast.showToast(message: 'Please select a shipping address');
      return;
    }

    // 1. Call Checkout API
    final checkoutBody = {
      'user_address_id': _selectedAddress!.id.toString(),
    };

    final checkoutResponse = await ApiImplementation.checkout(checkoutBody);
    if (checkoutResponse.statusCode == 200 || checkoutResponse.statusCode == 201) {
      final decodedCheckout = jsonDecode(checkoutResponse.body);
      
      // The order ID might be under 'data' -> 'id' or directly under 'data'
      final dynamic data = decodedCheckout['data'];
      String? orderId;
      
      if (data is Map) {
        orderId = data['id']?.toString() ?? data['order_id']?.toString();
      } else if (data is num || data is String) {
        orderId = data.toString();
      }

      if (orderId == null || orderId == "null") {
        CustomToast.showToast(message: 'Failed to retrieve Order ID');
        return;
      }

      // 2. Call Confirm Checkout API
      final confirmBody = {
        'order_id': orderId,
      };

      final confirmResponse = await ApiImplementation.confirmCheckout(confirmBody);
      if (confirmResponse.statusCode == 200 || confirmResponse.statusCode == 201) {
        CustomToast.showToast(message: 'Order placed successfully!');
        Get.offAll(() => const MainNavScreen());
      } else {
        final error = jsonDecode(confirmResponse.body);
        CustomToast.showToast(message: error['message'] ?? 'Failed to confirm order');
      }
    } else {
      final error = jsonDecode(checkoutResponse.body);
      CustomToast.showToast(message: error['message'] ?? 'Checkout failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Checkout', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: 'Total Amount', fontSize: 16, fontWeight: FontWeight.bold),
                CustomText(text: 'US\$${widget.cartData.total?.toStringAsFixed(2) ?? "0.00"}', fontSize: 18, fontWeight: FontWeight.bold, textColor: Colors.red),
              ],
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: 'PLACE ORDER',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
              height: 50,
              onSubmit: _handlePlaceOrder,
            ),
          ],
        ),
      ),
      child: _isLoading 
          ? const Center(child: CircularDotLoader(label: ''))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Shipping Address', onEdit: () async {
                    final result = await RouteNavigate().navigateToPush(context, const NewAddressScreen());
                    if (result == true) _fetchAddresses();
                  }),
                  if (_addresses.isEmpty)
                    _buildAddAddressPlaceholder()
                  else
                    ..._addresses.map((addr) => _buildAddressItem(addr)),
                  
                  const SizedBox(height: 30),
                  _buildSectionHeader('Order Items'),
                  ...widget.cartData.items?.map((item) => _buildOrderItem(item)) ?? [],
                  
                  const SizedBox(height: 30),
                  _buildSectionHeader('Payment Method'),
                  _buildPaymentPlaceholder(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: title.toUpperCase(), fontSize: 14, fontWeight: FontWeight.bold, textColor: Colors.black),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const CustomText(text: '+ Add New', fontSize: 12, textColor: Colors.blue, decoration: TextDecoration.underline),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(AddressData addr) {
    bool isSelected = _selectedAddress?.id == addr.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = addr),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade200, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: '${addr.firstName} ${addr.lastName}', fontSize: 15, fontWeight: FontWeight.bold),
                  const SizedBox(height: 4),
                  CustomText(text: addr.phone ?? '', fontSize: 13, textColor: Colors.black87),
                  CustomText(text: '${addr.addressLine1}, ${addr.city}, ${addr.stateName ?? ""} ${addr.postalCode}', fontSize: 13, textColor: Colors.black54),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressPlaceholder() {
    return CustomButton(
      text: 'ADD SHIPPING ADDRESS',
      buttonColor: Colors.white,
      textColor: Colors.black,
      borderColor: Colors.black,
      borderRadius: 0,
      height: 45,
      onSubmit: () async {
        final result = await RouteNavigate().navigateToPush(context, const NewAddressScreen());
        if (result == true) _fetchAddresses();
      },
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          NetworkImageView(url: item.product?.image ?? '', width: 60, height: 80),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: item.product?.name ?? '', fontSize: 14, maxLine: 1),
                const SizedBox(height: 4),
                CustomText(text: 'Qty: ${item.quantity}', fontSize: 12, textColor: Colors.grey),
                CustomText(text: 'US\$${item.price?.toStringAsFixed(2)}', fontSize: 14, fontWeight: FontWeight.bold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: Colors.black54),
          const SizedBox(width: 12),
          const Expanded(child: CustomText(text: 'Cash on Delivery (Default)', fontSize: 14)),
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}
