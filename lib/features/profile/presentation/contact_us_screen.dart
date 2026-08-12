import 'package:rosewe_online_shopping/core/common_imports.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildItem(Icons.chat_bubble_outline, 'Messenger', () {}),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildItem(Icons.contact_support_outlined, 'FAQs', () {}),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildItem(Icons.description_outlined, 'Submit A Ticket', () {}),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildItem(Icons.mail_outline, 'Email', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 22),
      title: CustomText(text: title, fontSize: 15, textColor: Colors.black),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
      onTap: onTap,
    );
  }
}
