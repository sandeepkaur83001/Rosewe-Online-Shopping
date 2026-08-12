import 'package:rosewe_online_shopping/core/common_imports.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: const CustomText(
          text: 'Privacy Policy',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward, color: Colors.grey),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CustomText(
                      text: 'Privacy Policy',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContentText(
                    'On http://www.Rosewe.com ( Rosewe.com), visitor privacy is of our serious concern. This privacy policy page describes what kind of personal information may be received and collected by Rosewe.com and how the information will be used.',
                  ),
                  _buildSectionTitle('I. COLLECTION OF PERSONAL DATA'),
                  _buildContentText(
                    'Information including user name, address, phone number, and email address, will be collected at the time of user registration on the Site.\n'
                    'If you are registering an account through social media platforms such as Facebook or Google, we may collect your e-mail address and public profile.\n'
                    'If you are registering as wholesaler, dropshipper or affiliate member, in addition to the information mentioned above, we may also collect information about your business, such as the your website, your customer’s name, address, etc.\n'
                    'If you make a payment, we collect personal data in connection with payment. This data includes your Paypal account, credit or debit card number and other card information, and other account and authentication information, as well as billing, shipping, and contact details.\n'
                    'If you contact our customer service, we may record your conversation with us and collect additional information to verify your identity.\n'
                    'We record users’ buying and browsing activities on our site including but not limited to IP addresses, browsing patterns, buyer behavioral patterns and equipment information. In addition, we gather statistical information about the Site and visitors to the Site including, but not limited to, IP addresses, browser software, operating system, software and hardware attributes, pages viewed, number of sessions and unique visitors.',
                  ),
                  _buildSectionTitle('II. USE OF PERSONAL DATA'),
                  _buildContentText(
                    'We collect and use your Personal Data for the following purposes:\n'
                    '--verifying your identity;\n'
                    '--processing your registration as a user, providing you with a log-in ID for the Site and maintaining and managing your registration;\n'
                    '--providing you with customer service and responding to your queries, feedback, claims or disputes;\n'
                    '--Offering and measuring targeted advertisements and services.',
                  ),
                  _buildSectionTitle('III. DISCLOSURE OF PERSONAL DATA'),
                  _buildContentText(
                    'We may disclose and transfer your Personal Data to our partners and to service providers engaged by us to assist us to provide services to you.\n'
                    '--payment service providers to assist with payment for transactions. The activities of payment service providers may be governed by their own privacy policies, not this Privacy Policy;\n'
                    '--credit risk assessment providers to conduct risk assessment on transactions to prevent fraud and other risk incidents;\n'
                    '--logistics partners for providing delivery service\n'
                    '--customer service to provide pre-sale and after-sale services',
                  ),
                  _buildSectionTitle('IV. RIGHTS REGARDING PERSONAL DATA'),
                  _buildContentText(
                    'We take reasonable steps to ensure that your personal data is accurate, complete, and up to date. You have the right to access, correct, update, or request deletion of your Personal Data.\n'
                    'Marketing Communications: You have the right to opt out of marketing communications we send you at any time. You can exercise this right by clicking on the “unsubscribe” link in the marketing emails we send you.\n'
                    'Service-Related Communications: We send administrative, account, or transaction-related emails (such as order confirmations, shipping updates, and policy changes). These communications are not promotional in nature, and you are not able to unsubscribe from them—otherwise, you may miss important updates regarding your account or orders.',
                  ),
                  _buildSectionTitle('V. COOKIES'),
                  _buildContentText(
                    'We use cookies and similar technologies to provide, protect, and improve our products and services, such as by personalizing content, offering and measuring advertisements, understanding user behavior, and providing a safer experience.\n'
                    'You can remove or reject cookies using your browser or device settings, but in some cases doing so may affect your ability to use our products and services.',
                  ),
                  _buildSectionTitle('VI. MINORS'),
                  _buildContentText(
                    'The Site and their contents are not targeted to minors (those under the age of 18) and we do not intend to sell any of our products or services to minors. If we learn that we have collected the personal data of a child under 16, or the equivalent minimum age depending on the jurisdiction, we will take steps to delete the data as soon as possible.',
                  ),
                  _buildSectionTitle('VII. SECURITY MEASURES'),
                  _buildContentText(
                    'We use reasonable security methods to prevent unauthorized access to safeguard and help prevent unauthorized access to your data, and to correctly use the data we collect. For registered users, some of your information can be viewed and edited through your account, which is protected by a password. It is important that you take precautions to protect against unauthorized access to your account credentials, and computer or other devices.',
                  ),
                  _buildSectionTitle('VIII. CONTACT US'),
                  _buildContentText(
                    'If you have any questions regarding this Privacy Statement or its implementation, here is how you can reach us: service@rosewe.com',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: CustomText(
        text: title,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContentText(String text) {
    return CustomText(
      text: text,
      fontSize: 14,
      textColor: Colors.black87,
      lineHeight: 1.5,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F7),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook),
              const SizedBox(width: 15),
              _socialIcon(Icons.play_circle_outline),
              const SizedBox(width: 15),
              _socialIcon(Icons.camera_alt_outlined),
              const SizedBox(width: 15),
              _socialIcon(Icons.video_library_outlined),
              const SizedBox(width: 15),
              _socialIcon(Icons.pin_drop_outlined),
            ],
          ),
          const SizedBox(height: 30),
          const CustomText(
            text: 'Subscribe For Discounts + Updates',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 120,
                color: Colors.black,
                child: const Center(
                  child: CustomText(
                    text: 'SUBSCRIBE',
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const CustomText(
            text: '*New users get Extra \$40 off Coupons',
            fontSize: 12,
            textColor: Colors.grey,
          ),
          const SizedBox(height: 30),
          _footerExpandable('Customer Service'),
          _footerExpandable('Help Center'),
          _footerExpandable('Quick Link'),
          _footerExpandable('Company'),
          _footerExpandable('Satisfaction Survey'),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flag_outlined, size: 18),
              const SizedBox(width: 8),
              const CustomText(
                text: 'Ship to: 1783 NOT SHIP, USDUS\$/English >',
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(8, (index) => Container(
              width: 40,
              height: 25,
              color: Colors.grey.shade300,
            )),
          ),
          const SizedBox(height: 30),
          const CustomText(
            text: '© 2005-2026 Rosewe.com. All Rights Reserved.',
            fontSize: 12,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _footerExpandable(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListTile(
        title: CustomText(text: title, fontSize: 14, fontWeight: FontWeight.w500),
        trailing: const Icon(Icons.add, size: 18),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
