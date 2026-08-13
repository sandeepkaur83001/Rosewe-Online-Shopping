import 'package:flutter/gestures.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/main_nav/presentation/main_nav_screen.dart';
import 'package:rosewe_online_shopping/features/guide/terms_of_use_screen.dart';
import 'package:rosewe_online_shopping/features/guide/privacy_policy_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String email;
  const RegisterScreen({super.key, required this.email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _signUpForEmails = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
          icon: const Icon(Icons.close, color: AppColors.dimGrayColor, size: 30),
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
              text: 'Create Account',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              textColor: Colors.black,
            ),
            const SizedBox(height: 25),
            // Promo Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2), // Light peach/pink from screenshot
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_number_outlined, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const CustomText(
                    text: '\$40 OFF For New Members',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Email Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                    onPressed: () => _emailController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Password Hint
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Password must contain 6 characters minimum and at least 1 letter.',
                fontSize: 12,
                textColor: AppColors.grayShade,
              ),
            ),
            const SizedBox(height: 20),
            // Checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _signUpForEmails,
                    activeColor: Colors.orange,
                    onChanged: (val) => setState(() => _signUpForEmails = val ?? false),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: CustomText(
                    text: 'Sign up for Rosewe emails. Unsubscribe anytime.',
                    fontSize: 14,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            // Create Account Button
            CustomButton(
              text: 'CREATE ACCOUNT',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
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

                final passwordError = Validators.validateRosewePassword(_passwordController.text);
                if (passwordError != null) {
                  CustomToast.showToast(message: passwordError);
                  return;
                }

                RouteNavigate().navigateToPushAndRemoveUntil(context, const MainNavScreen());
              },
            ),
            const SizedBox(height: 20),
            // T&C text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'Humanist521'),
                children: [
                  const TextSpan(text: 'By selecting CREATE ACCOUNT, you agree to our '),
                  TextSpan(
                    text: 'T&C',
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        RouteNavigate().navigateToPush(context, const TermsOfUseScreen());
                      },
                  ),
                  const TextSpan(text: '. View '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        RouteNavigate().navigateToPush(context, const PrivacyPolicyScreen());
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
