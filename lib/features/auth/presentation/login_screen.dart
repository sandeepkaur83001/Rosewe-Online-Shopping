import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.dimGrayColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Logo Image
            Image.asset(
              'assets/images/rosewe_logo_clean.png',
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
             const CustomText(
              text: 'Sign In/Create Account',
              fontSize: 21,
              textColor: Colors.black,
              fontWeight: FontWeight.w500,

            ),
            const SizedBox(height: 40),
            // Email TextField
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.8)),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/images/mail_icon.svg',
                      width: 24,
                      height: 24,
                    color: AppColors.blackColor.withValues(alpha: 0.6),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 35),
            // Continue Button
            CustomButton(
              text: 'CONTINUE',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderColor: Colors.transparent,

              borderRadius: 0,
              elevation: 0,
              height: 50,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              margin: EdgeInsets.zero,
              onSubmit: () {
                if (_emailController.text.isNotEmpty) {
                  RouteNavigate().navigateToPush(
                    context, 
                    RegisterScreen(email: _emailController.text),
                  );
                }
              },
            ),
            const SizedBox(height: 60),
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.dividerColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomText(
                    text: 'Or sign in/sign up with',
                    fontSize: 12,
                    textColor: AppColors.grayShade,
                  ),
                ),
                Expanded(child: Divider(color: AppColors.dividerColor, thickness: 1)),
              ],
            ),
            const SizedBox(height: 40),
            // Social Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon('https://cdn-icons-png.flaticon.com/512/2991/2991148.png'), // Google
                const SizedBox(width: 25),
                _socialIcon('assets/images/facebook_icon.svg', isAssetSvg: true), // Facebook
                const SizedBox(width: 25),
                _socialIcon('https://cdn-icons-png.flaticon.com/512/174/174861.png'), // PayPal
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(String iconPath, {bool isAssetSvg = false}) {
    return Container(
      padding: isAssetSvg ? EdgeInsets.zero : const EdgeInsets.all(12),
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: !isAssetSvg ? Border.all(color: AppColors.dividerColor) : null,
      ),
      child: ClipOval(
        child: isAssetSvg
            ? SvgPicture.asset(
                iconPath,
                fit: BoxFit.cover,
              )
            : NetworkImageView(
                url: iconPath,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
