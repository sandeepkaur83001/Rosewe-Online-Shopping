import 'package:rosewe_online_shopping/core/common_imports.dart';

class AccountDeleteReasonScreen extends StatefulWidget {
  const AccountDeleteReasonScreen({super.key});

  @override
  State<AccountDeleteReasonScreen> createState() => _AccountDeleteReasonScreenState();
}

class _AccountDeleteReasonScreenState extends State<AccountDeleteReasonScreen> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> _reasons = [
    'Multiple Rosewe accounts',
    'Privacy and security concerns',
    'Incorrect registration information',
    'No longer purchase',
    'Other'
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  bool get _isNextEnabled {
    if (_selectedReason == null) return false;
    if (_selectedReason == 'Other') return _otherReasonController.text.trim().isNotEmpty;
    return true;
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
      child: Column(
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
                    RadioListTile<String>(
                      title: CustomText(text: reason, fontSize: 14),
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
                    if (reason == 'Other' && _selectedReason == 'Other')
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
              onSubmit: _isNextEnabled ? () {
                // Navigate to next step
              } : null,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
