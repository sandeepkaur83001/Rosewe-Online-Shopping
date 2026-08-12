import 'package:rosewe_online_shopping/core/common_imports.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
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
          text: 'Terms of Use',
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
                      text: 'Terms of Use',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContentText(
                    'Welcome to our site! This document is a legally binding agreement between you as the user(s) of the site (referred to as "you", "your" or "User" hereinafter) and rosewe.com -- owner of the site rosewe.com.',
                  ),
                  _buildSectionTitle('1. Applicable law'),
                  _buildContentText(
                    '(1) Welcome to the website of rosewe.com. rosewe.com is operated by Hongkong Yuzhen E-Commerce Co., Limited. We provide its services to you subject to the notices, terms, and conditions set forth in this agreement (the "Agreement"). In addition, when you use any rosewe.com service (e.g., Customer Reviews), you will be subject to the rules, guidelines, policies, terms, and conditions applicable to such services, and they are incorporated into this Agreement by this reference. rosewe.com reserves the right to change this site and these terms and conditions at any time.\nThis site is created and controlled by Rosewe. The laws of HK shall apply in respect of all Terms & Conditions Notice and disclaimers.',
                  ),
                  _buildSectionTitle('2. Application and Acceptance of the Terms'),
                  _buildContentText(
                    '(1) Your use of Rosewe.com\'s services, and products (collectively the as the "Services" hereinafter) is subject to the terms and conditions contained in this document as well as the Privacy Policy and any other rules and policies of Rosewe.com that may be published by Rosewe.com from time to time. This document and such other rules and policies of Rosewe.com are collectively referred to below as the "Terms". By accessing Rosewe.com or using the Services, you agree to accept and be bound by the Terms. Please do not use the Services or Rosewe.com if you do not accept all of the Terms.\n(3) You acknowledge and agree that Rosewe.com may amend any Terms at any time by posting the relevant amended and restated Terms on Rosewe.com. By continuing to use the Services or Rosewe.com, you agree that the amended Terms will apply to you.',
                  ),
                  _buildSectionTitle('3. Users Generally'),
                  _buildContentText(
                    '(1) As a condition of your access to and use of Rosewe.com or Services, you agree that you will comply with all applicable laws and regulations when using Rosewe.com or Services.\n(2) You must read Rosewe.com\'s Privacy Policy which governs the protection and use of personal information about Users in the possession of Rosewe.com and our affiliates. You accept the terms of the Privacy Policy and agree to the use of the personal information about you in accordance with the Privacy Policy.\n(3) You agree not to undertake any action to undermine the integrity of the computer systems or networks of Rosewe.com and/or any other User nor to gain unauthorized access to such computer systems or networks.\n(4) You agree not to take any advantage in using the information listed on Rosewe.com or received from any representatives of Rosewe.com in the activities including: setting price levels, or quotations of products and services which are not purchased from Rosewe.com, preparing website contents, writing contract or agreements which are without Rosewe.com\'s participation.',
                  ),
                  _buildSectionTitle('4. Products and Prices'),
                  _buildContentText(
                    '(1) Since we are continuously developing and upgrading our products and service, any technical, non-technical specification, including but not limited to web pages, reports tables, figures, images, videos or audios of any of products of Rosewe.com may be altered or completely changed in formats and contents without a prior notification either online or offline.\n(2) Prices listed on Rosewe.com or provided by any representatives of Rosewe.com are subject to change without a prior notice.',
                  ),
                  _buildSectionTitle('5. Limitation of Liability'),
                  _buildContentText(
                    '(1) Any material downloaded or otherwise obtained through Rosewe.com is done at each User\'s sole discretion and risk and each User is solely responsible for any damage to Rosewe.com\'s computer system or loss of data that may result from the download of any such material.',
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
          // Simple placeholder for payment icons
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
