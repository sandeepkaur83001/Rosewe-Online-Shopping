import 'dart:io';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/main_nav/presentation/main_nav_screen.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';

class LoginPasswordScreen extends StatefulWidget {
  final String email;
  const LoginPasswordScreen({super.key, required this.email});

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Logo
            Image.asset(
              'assets/images/rosewe_logo_clean.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            const CustomText(
              text: 'Sign In',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              textColor: Colors.black,
            ),
            const SizedBox(height: 15),
             CustomText(
              text: widget.email,
              fontSize: 16,
              textColor: AppColors.grayShade,
            ),
            const SizedBox(height: 40),
            // Password Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'SIGN IN',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
              height: 50,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              onSubmit: _handleLogin,
            ),
             const SizedBox(height: 20),
             TextButton(
              onPressed: () {
                // Implement forgot password flow if needed
              },
              child: const CustomText(
                text: 'Forgot Password?',
                fontSize: 14,
                textColor: AppColors.blackColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      CustomToast.showToast(message: 'Password is required');
      return;
    }

    final dialog = Get.find<DialogService>();
    dialog.showLoader();

    try {

      // API Implementation
      final position = await LocationService.getCurrentLocationLangLong();
      print('dfdjfldjfld');
      final deviceType = Platform.isAndroid ? 'android' : 'ios';

      final deviceToken = 'temp_token';

      final body = {
        'email': widget.email,
        'password': password,
        'device_type': deviceType,
        'device_token': deviceToken,
        'latitude': position?.latitude.toString() ?? '',
        'longitude': position?.longitude.toString() ?? '',
      };

      final response = await ApiImplementation.login(body, showLoader: true);

      if (response != null) {
        if (response.status == 200) {
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
          // Explicitly show toast for errors (like 401 Invalid Credentials)
          CustomToast.showToast(message: response.message ?? 'Login failed');
        }
      } else {
        CustomToast.showToast(message: 'Login failed: Server error');
      }
    } catch (e) {
      CustomToast.showToast(message: 'Login failed: $e');
    } finally {
      dialog.hideLoader();
    }
  }
}
