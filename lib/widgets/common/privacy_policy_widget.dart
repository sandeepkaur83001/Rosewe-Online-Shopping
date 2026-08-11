import 'package:rosewe_online_shopping/core/common_imports.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: CustomText(
        text: "privacy policy",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        align: TextAlign.center,
        textColor: AppColors.whiteColor,
        isUnderline: true,
      ),
    );
  }
}
