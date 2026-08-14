import 'package:rosewe_online_shopping/core/common_imports.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isTitleError = false;
  bool _isMessageError = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      _isTitleError = _titleController.text.trim().isEmpty;
      _isMessageError = _messageController.text.trim().isEmpty;
    });

    if (_isTitleError || _isMessageError) {
      CustomToast.showToast(message: 'Please fill in all required fields');
      return;
    }

    final body = {
      'title': _titleController.text.trim(),
      'message': _messageController.text.trim(),
    };

    try {
      final response = await ApiImplementation.contactUs(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showToast(message: 'Message sent successfully');
        if (mounted) Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        CustomToast.showToast(message: error['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      debugPrint("Error in contact us: $e");
      CustomToast.showToast(message: 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      color: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(text: 'Contact Us', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          text: 'SUBMIT',
          buttonColor: AppColors.blackColor,
          textColor: AppColors.whiteColor,
          borderRadius: 0,
          height: 50,
          onSubmit: _handleSubmit,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Feel free to contact us with any questions or suggestions!',
              fontSize: 14,
              textColor: Colors.black54,
            ),
            const SizedBox(height: 25),
            
            _buildLabel('Title *'),
            _buildTextField(
              controller: _titleController,
              hint: 'Enter subject/title',
              error: _isTitleError,
            ),
            const SizedBox(height: 20),

            _buildLabel('Message *'),
            _buildTextField(
              controller: _messageController,
              hint: 'How can we help you?',
              maxLines: 6,
              error: _isMessageError,
            ),
            const SizedBox(height: 20),

            // Optional info sections
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                   _buildInfoRow(Icons.mail_outline, 'support@rosewe.com'),
                   const Divider(height: 24),
                   _buildInfoRow(Icons.access_time, 'Mon-Fri: 9:00 AM - 6:00 PM'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CustomText(text: label, fontSize: 14, fontWeight: FontWeight.w600, textColor: Colors.black87),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    int maxLines = 1,
    bool error = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: error ? Colors.red : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (val) {
          if (error && val.trim().isNotEmpty) {
            setState(() {
              if (controller == _titleController) _isTitleError = false;
              if (controller == _messageController) _isMessageError = false;
            });
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 12),
        CustomText(text: text, fontSize: 14, textColor: Colors.black87),
      ],
    );
  }
}
