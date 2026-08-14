import 'dart:io';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/login_password_screen.dart';
import 'package:rosewe_online_shopping/features/auth/presentation/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:rosewe_online_shopping/features/main_nav/presentation/main_nav_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

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
                final emailError = Validators.email(_emailController.text);
                if (emailError != null) {
                  CustomToast.showToast(message: emailError);
                  return;
                }
                
                RouteNavigate().navigateToPush(
                  context, 
                  LoginPasswordScreen(email: _emailController.text),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                RouteNavigate().navigateToPush(
                  context, 
                  RegisterScreen(email: _emailController.text),
                );
              },
              child: const CustomText(
                text: 'New to Rosewe? Create Account',
                fontSize: 14,
                textColor: AppColors.blackColor,
                decoration: TextDecoration.underline,
              ),
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
                _socialIcon(
                  'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                  onTap: () => _handleSocialLogin('google'),
                ), // Google
                const SizedBox(width: 25),
                _socialIcon(
                  'assets/images/facebook_icon.svg', 
                  isAssetSvg: true,
                  onTap: () => _handleSocialLogin('facebook'),
                ), // Facebook
                const SizedBox(width: 25),
                _socialIcon(
                  'https://cdn-icons-png.flaticon.com/512/174/174861.png',
                  onTap: () => _handleSocialLogin('paypal'), // Provider name for PayPal
                ), // PayPal
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(String iconPath, {bool isAssetSvg = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  void _handleSocialLogin(String provider) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();

    try {
      firebase.User? user;
      if (provider == 'google') {
        user = await SocialSignIn().signInWithGoogle();
      } else if (provider == 'facebook') {
        user = await SocialSignIn().signInWithFacebook();
      }

      if (user != null) {
        final position = await LocationService.getCurrentLocationLangLong();
        final deviceType = Platform.isAndroid ? 'android' : 'ios';
        final deviceToken = 'temp_token';

        final body = {
          'provider': provider,
          'provider_id': user.uid,
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'device_type': deviceType,
          'device_token': deviceToken,
          'latitude': position?.latitude.toString() ?? '',
          'longitude': position?.longitude.toString() ?? '',
        };

        final response = await ApiImplementation.socialLogin(body, showLoader: true);

        if (response != null && (response.status == 200 || response.status == 201)) {
          if (response.data?.token != null) {
            Globals.BearerToken = response.data!.token;
            await SharedManager.setStringSharePreferences(
              SharedConstants.LOGIN_MODEL,
              jsonEncode(response.toJson()),
            );
            final profileController = Get.find<ProfileController>();
            await profileController.checkLoginStatus();
            await profileController.fetchInitialData();
          }
          CustomToast.showToast(message: response.message ?? 'Logged in successfully');
          if (mounted) {
            RouteNavigate().navigateToPushAndRemoveUntil(context, const MainNavScreen());
          }
        } else {
          if (response != null && response.message != null) {
            CustomToast.showToast(message: response.message!);
          }
        }
      }
    } catch (e) {
      debugPrint("Social Login Error: $e");
      CustomToast.showToast(message: 'Social login failed. Please try again.');
    } finally {
      dialog.hideLoader();
    }
  }
}
