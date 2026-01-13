import 'package:flutter_base/util/common_imports.dart';

class OrDividerLine extends StatelessWidget {
  const OrDividerLine({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppColors.dividerLineOrColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomText(
            text: "OR",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            textColor: AppColors.whiteColor,
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.dividerLineOrColor),
        ),
      ],
    );
  }
}
