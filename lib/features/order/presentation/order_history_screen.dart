import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/models/order/order_model.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderData> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await ApiImplementation.getOrders(showLoader: false);
      if (response.statusCode == 200) {
        final orderResponse = OrderResponse.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          _orders = orderResponse.data?.data ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
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
        title: const CustomText(text: 'My Orders', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: _isLoading
          ? const Center(child: CircularDotLoader(label: ''))
          : _orders.isEmpty
              ? const Center(
                  child: EmptyStateWidget(
                    title: 'No Orders Yet',
                    message: 'You haven\'t placed any orders yet.',
                    icon: Icons.shopping_bag_outlined,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return _buildOrderCard(order);
                  },
                ),
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'Order #${order.id}', fontSize: 14, fontWeight: FontWeight.bold),
                    const SizedBox(height: 4),
                    CustomText(text: _formatDate(order.createdAt), fontSize: 12, textColor: Colors.grey),
                  ],
                ),
                _buildStatusBadge(order.status ?? 'PENDING'),
              ],
            ),
          ),
           Divider(height: 1,color: Colors.grey.withAlpha(50),),
          ...order.items?.map((item) => _buildOrderItem(item)) ?? [],
          Divider(height: 1,color: Colors.grey.withAlpha(50),),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: '${order.items?.length ?? 0} Items', fontSize: 13, textColor: Colors.black54),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: 'Total: '),
                      TextSpan(
                        text: 'US\$${order.total?.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          NetworkImageView(
            url: item.product?.image ?? '',
            width: 50,
            height: 70,
            borderRadius: 6.0,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: item.product?.name ?? '', fontSize: 13, maxLine: 1),
                const SizedBox(height: 4),
                CustomText(text: 'Qty: ${item.quantity}', fontSize: 12, textColor: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        color = Colors.green;
        break;
      case 'CANCELLED':
        color = Colors.red;
        break;
      case 'SHIPPED':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomText(
        text: status,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        textColor: color,
      ),
    );
  }
}
