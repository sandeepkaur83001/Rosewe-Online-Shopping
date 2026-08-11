import 'package:rosewe_online_shopping/core/common_imports.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.blackColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Jumpsuit',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: AppColors.grayShade),
                  ),
                ),
              ),
              Container(
                width: 45,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: const Icon(Icons.search, color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Popular Searches:',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _searchTag('Best Seller', icon: Icons.local_fire_department, iconColor: Colors.red),
                _searchTag('Swimwear Hot Sale', icon: Icons.local_fire_department, iconColor: Colors.red),
                _searchTag('Tops Picks', icon: Icons.local_fire_department, iconColor: Colors.red),
                _searchTag('Swimwear'),
                _searchTag('Tankinis'),
                _searchTag('Bikinis'),
                _searchTag('One Piece'),
                _searchTag('Vacation Dresses'),
                _searchTag('black dresses'),
                _searchTag('White dress'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchTag(String text, {IconData? icon, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
          ],
          CustomText(text: text, fontSize: 14, textColor: AppColors.grayShade),
        ],
      ),
    );
  }
}
