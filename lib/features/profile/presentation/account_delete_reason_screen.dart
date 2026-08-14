import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:rosewe_online_shopping/features/welcome/presentation/welcome_screen.dart';

class AccountDeleteReasonScreen extends StatefulWidget {
  const AccountDeleteReasonScreen({super.key});

  @override
  State<AccountDeleteReasonScreen> createState() => _AccountDeleteReasonScreenState();
}

class _AccountDeleteReasonScreenState extends State<AccountDeleteReasonScreen> {
  DeleteReasonData? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  List<DeleteReasonData> _reasons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReasons();
  }

  Future<void> _fetchReasons() async {
    final response = await ApiImplementation.getDeleteReasons();
    if (response != null && response.data != null) {
      setState(() {
        _reasons = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  bool get _isNextEnabled {
    if (_selectedReason == null) return false;
    if (_selectedReason?.reason?.toLowerCase() == 'other') return _otherReasonController.text.trim().isNotEmpty;
    return true;
  }

  void _handleDeleteAccount() async {
    final reasonText = _selectedReason?.reason?.toLowerCase() == 'other' 
        ? _otherReasonController.text.trim() 
        : _selectedReason?.reason;

    final dialog = Get.find<DialogService>();
    dialog.showLoader();

    try {
      final body = {
        'user_delete_reason_id': _selectedReason?.id,
        'reason': reasonText ?? '',
      };

      final response = await ApiImplementation.deleteAccount(body, showLoader: false);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final jsonResponse = jsonDecode(response.body);
        CustomToast.showToast(message: jsonResponse['message'] ?? 'Account deleted successfully');
        
        final profileController = Get.find<ProfileController>();
        profileController.logout();
        
        if (mounted) {
          RouteNavigate().navigateToPushAndRemoveUntil(context, const WelcomeScreen());
        }
      } else {
        if (response != null) {
          try {
            final errorData = jsonDecode(response.body);
            CustomToast.showToast(message: errorData['message'] ?? 'Failed to delete account');
          } catch (e) {
            CustomToast.showToast(message: 'Error: ${response.reasonPhrase}');
          }
        }
      }
    } finally {
      dialog.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Delete Account', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _reasons.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                return Column(
                  children: [
                    RadioListTile<DeleteReasonData>(
                      title: CustomText(text: reason.reason ?? '', fontSize: 14),
                      value: reason,
                      groupValue: _selectedReason,
                      activeColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                    ),
                    if (reason.reason?.toLowerCase() == 'other' && _selectedReason?.id == reason.id)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: TextField(
                          controller: _otherReasonController,
                          maxLines: 3,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Please tell us why you want to delete your account...',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: 'NEXT',
              buttonColor: _isNextEnabled ? AppColors.blackColor : Colors.grey[300]!,
              textColor: _isNextEnabled ? AppColors.whiteColor : Colors.white,
              borderRadius: 0,
              height: 45,
              onSubmit: _isNextEnabled ? _handleDeleteAccount : null,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
