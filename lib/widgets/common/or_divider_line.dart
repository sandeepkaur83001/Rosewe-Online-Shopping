import 'package:rosewe_online_shopping/core/common_imports.dart';

class OrDividerLine extends StatelessWidget {
  final String text;
  const OrDividerLine({super.key, this.text = "OR"});
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
            text: text,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            textColor: AppColors.grayShade,
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.dividerLineOrColor),
        ),
      ],
    );
  }
}
