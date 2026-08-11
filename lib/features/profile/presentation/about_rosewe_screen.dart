import 'package:rosewe_online_shopping/core/common_imports.dart';

class AboutRoseweScreen extends StatelessWidget {
  const AboutRoseweScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: const CustomText(
          text: 'About Rosewe',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // const SizedBox(height: 20),
          // Center(
          //   child: Image.asset(
          //     'assets/images/app_logo.png',
          //     height: 100,
          //     width: 100,
          //     fit: BoxFit.contain,
          //   ),
          // ),
          // const SizedBox(height: 20),
          _settingsItem(context, 'Shipping Info'),
          _settingsItem(context, 'Return & Exchange'),
          _settingsItem(context, 'Payment Methods'),
          _settingsItem(context, 'Pro Program'),
          _settingsItem(context, 'Term of Use'),
          _settingsItem(context, 'Privacy Policy'),
          _settingsItem(context, 'Rosewe Story'),
        ],
      ),
    );
  }

  Widget _settingsItem(BuildContext context, String title, {VoidCallback? onTap}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(bottom: BorderSide(color: AppColors.backgroundColor, width: 1)),
      ),
      child: ListTile(
        onTap: onTap,
        title: CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w400),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.blackColor),
      ),
    );
  }
}
