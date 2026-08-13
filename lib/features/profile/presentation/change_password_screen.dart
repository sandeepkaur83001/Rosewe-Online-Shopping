import 'package:rosewe_online_shopping/core/common_imports.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        title: const CustomText(text: 'Change Password', fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Old Password'),
            _buildPasswordField(_oldPasswordController, _obscureOld, (val) => setState(() => _obscureOld = val)),
            const SizedBox(height: 20),
            
            _buildLabel('New Password'),
            _buildPasswordField(_newPasswordController, _obscureNew, (val) => setState(() => _obscureNew = val)),
            const SizedBox(height: 8),
            const CustomText(
              text: 'Password must contain 6 characters minimum and at least 1 letter.',
              fontSize: 12,
              textColor: AppColors.grayShade,
            ),
            const SizedBox(height: 20),

            _buildLabel('Confirm New Password'),
            _buildPasswordField(_confirmPasswordController, _obscureConfirm, (val) => setState(() => _obscureConfirm = val)),
            const SizedBox(height: 40),

            CustomButton(
              text: 'UPDATE PASSWORD',
              buttonColor: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              borderRadius: 0,
              height: 50,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              margin: EdgeInsets.zero,
              onSubmit: _handleChangePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomText(text: text, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool obscure, Function(bool) onToggle) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => onToggle(!obscure),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  void _handleChangePassword() async {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty) {
      CustomToast.showToast(message: 'Old password is required');
      return;
    }

    final newPassError = Validators.validateRosewePassword(newPass);
    if (newPassError != null) {
      CustomToast.showToast(message: newPassError);
      return;
    }

    if (newPass != confirmPass) {
      CustomToast.showToast(message: 'Passwords do not match');
      return;
    }

    final body = {
      'old_password': oldPass,
      'new_password': newPass,
      'new_password_confirmation': confirmPass,
    };

    final response = await ApiImplementation.changePassword(body);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      CustomToast.showToast(message: jsonResponse['message'] ?? 'Password changed successfully');
      Navigator.pop(context);
    }
  }
}
