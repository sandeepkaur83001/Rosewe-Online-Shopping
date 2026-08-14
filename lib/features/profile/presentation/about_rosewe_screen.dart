import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/widgets/common/custom_webview_screen.dart';

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
          _settingsItem(
            context, 
            'About Rosewe',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'About Rosewe', 
                url: 'http://162.241.68.61/rosewe/about-us',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Terms of Use',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Terms of Use', 
                url: 'http://162.241.68.61/rosewe/terms-and-conditions',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Privacy Policy',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Privacy Policy', 
                url: 'http://162.241.68.61/rosewe/privacy-policy',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Shipping Info',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Shipping Info', 
                url: 'http://162.241.68.61/rosewe/shipping-info',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Return & Exchange',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Return & Exchange', 
                url: 'http://162.241.68.61/rosewe/return-and-exchange-policy',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Payment Methods',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Payment Methods', 
                url: 'http://162.241.68.61/rosewe/payment-methods',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'Pro Program',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'Pro Program', 
                url: 'http://162.241.68.61/rosewe/pro-program',
              ),
            ),
          ),
          _settingsItem(
            context, 
            'FAQ',
            onTap: () => RouteNavigate().navigateToPush(
              context, 
              const CustomWebViewScreen(
                title: 'FAQ', 
                url: 'http://162.241.68.61/rosewe/faq',
              ),
            ),
          ),
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
