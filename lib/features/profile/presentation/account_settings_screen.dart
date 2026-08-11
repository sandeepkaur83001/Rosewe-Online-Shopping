import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/profile/presentation/about_rosewe_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF1F1), Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Image.asset(
                'assets/images/review_rating_asset.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Rating & Feedback',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              const CustomText(
                text: 'Would you mind leaving a review and let us know what you love and what we need to improve?',
                fontSize: 14,
                align: TextAlign.center,
                textColor: AppColors.grayShade,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'RATING',
                buttonColor: AppColors.blackColor,
                textColor: AppColors.whiteColor,
                borderRadius: 0,
                height: 45,
                onSubmit: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'FEEDBACK',
                buttonColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                borderColor: AppColors.blackColor,
                widthDecoration: 1,
                borderRadius: 0,
                height: 45,
                onSubmit: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        centerTitle: true,
        title: const CustomText(
          text: 'Account Settings',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'DancingScript',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildGroup([
              _settingsItem(context, 'Sign In/Create Account', onTap: () {
                RouteNavigate().navigateToPush(context, const LoginScreen());
              }),
            ]),
            _buildGroup([
              _settingsItem(context, 'Country/Region', value: 'US'),
              _settingsItem(context, 'Currency', value: 'USD'),
            ]),
            _buildGroup([
              _settingsItem(context, 'My Profile'),
              _settingsItem(context, 'Edit Password'),
              _settingsItem(context, 'Address Book'),
            ]),
            _buildGroup([
              _settingsItem(context, 'Contact Us'),
              _settingsItem(context, 'Push Notifications', value: 'OFF'),
              _settingsItem(context, 'About Rosewe', onTap: () {
                RouteNavigate().navigateToPush(context, const AboutRoseweScreen());
              }),
            ]),
            _buildGroup([
              _settingsItem(context, 'Rating & Feedback', onTap: () => _showRatingDialog(context)),
              _settingsItem(context, 'Clear Cache', value: '9.69 MB'),
              _settingsItem(context, 'Version', value: '1.3.0'),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
        ),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsItem(BuildContext context, String title, {String? value, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: CustomText(
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        textColor: Colors.black87,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            CustomText(
              text: value,
              fontSize: 15,
              textColor: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
