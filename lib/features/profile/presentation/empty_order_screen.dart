import 'package:rosewe_online_shopping/core/common_imports.dart';

class EmptyOrderScreen extends StatelessWidget {
  const EmptyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'My Orders', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: const EmptyStateWidget(
        title: 'You have no orders',
        message: 'Your order list is empty. Start shopping now!',
        // Placeholder for the box image in the screenshot
        icon: Icons.inventory_2_outlined, 
      ),
    );
  }
}
