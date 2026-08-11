import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_screen.dart';
import 'package:rosewe_online_shopping/features/main_nav/presentation/main_nav_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
          "assets/images/welcome_screen_image.png",
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),
                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Image.asset(
                    'assets/images/rosewe_logo_clean.png',

                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                const CustomText(
                  text: 'Enjoy the Spring and Summer Promotion',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.blackColor,
                ),
                const Spacer(flex: 4),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: 'SIGN IN/CREATE ACCOUNT',
                    buttonColor: AppColors.whiteColor,
                    textColor: AppColors.blackColor,
                    borderRadius: 4,
                    borderColor: AppColors.whiteColor,
                    elevation: 0,
                    onSubmit: () {
                      RouteNavigate().navigateToPush(context, const LoginScreen());
                    },
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    RouteNavigate().navigateToPushAndRemoveUntil(context, const MainNavScreen());
                  },
                  child: const CustomText(
                    text: 'Maybe Later',
                    fontSize: 16,
                    textColor: AppColors.whiteColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
