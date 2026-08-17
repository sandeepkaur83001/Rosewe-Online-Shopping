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
    final response = await ApiImplementation.getDeleteReasons(showLoader: false);
    if (response != null && response.data != null) {
      if (!mounted) return;
      setState(() {
        _reasons = response.data!;
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
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
      color: const Color(0xFFF5F5F5), // Light gray background matching image
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Delete Account', fontSize: 18, fontWeight: FontWeight.bold),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: _isLoading 
          ? const Center(child: CircularDotLoader(label: ''))
          : Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: const CustomText(
              text: 'Please select reason for deletion',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildReasonsList(),
                const SizedBox(height: 12),
                _buildOtherSection(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
            child: CustomButton(
              text: 'NEXT',
              buttonColor: _isNextEnabled ? AppColors.blackColor : Colors.grey[300]!,
              textColor: _isNextEnabled ? AppColors.whiteColor : Colors.white,
              borderRadius: 0,
              height: 48,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              onSubmit: _isNextEnabled ? _handleDeleteAccount : null,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildReasonsList() {
    final standardReasons = _reasons.where((r) => r.reason?.toLowerCase() != 'other').toList();
    
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: standardReasons.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1), indent: 16),
        itemBuilder: (context, index) {
          final reason = standardReasons[index];
          return _buildRadioItem(reason);
        },
      ),
    );
  }

  Widget _buildOtherSection() {
    final otherReason = _reasons.firstWhereOrNull((r) => r.reason?.toLowerCase() == 'other');
    if (otherReason == null) return const SizedBox.shrink();

    bool isSelected = _selectedReason?.id == otherReason.id;

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(80))
      ),

      child: Column(
        children: [
          _buildRadioItem(otherReason),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _otherReasonController,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Please enter other reason',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(DeleteReasonData reason) {
    bool isSelected = _selectedReason?.id == reason.id;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF5722) : Colors.grey.shade300,
                  width: isSelected ? 6 : 1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: reason.reason ?? '',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                textColor: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
