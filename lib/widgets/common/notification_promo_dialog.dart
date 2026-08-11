import 'package:rosewe_online_shopping/core/common_imports.dart';

class NotificationPromoDialog extends StatelessWidget {
  const NotificationPromoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const CustomText(
            text: 'Turn on notifications to stay up to date',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            align: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _benefitRow("assets/images/dress_icon.png", 'Access promotions and the latest trends before anyone else'),
          const SizedBox(height: 20),
          _benefitRow("assets/images/coupon_icon.png", 'Find out about exclusive events, pre-order and new launches'),
          const SizedBox(height: 20),
          _benefitRow("assets/images/involpe_icon.png", 'Receive recommendations and notifications about your purchases'),
          const SizedBox(height: 40),
          CustomButton(
            text: 'TURN ON',
            buttonColor: AppColors.blackColor,
            textColor: AppColors.whiteColor,
            borderColor: Colors.transparent,
            borderRadius: 0,
            elevation: 0,
            onSubmit: () => Navigator.pop(context),
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Skip',
              fontSize: 16,
              textColor: AppColors.grayShade,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _benefitRow(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon,fit: BoxFit.contain,height: 60,width: 60, ),
        const SizedBox(width: 15),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: 14,
            textColor: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
