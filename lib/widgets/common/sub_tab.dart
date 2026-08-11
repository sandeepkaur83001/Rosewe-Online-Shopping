import 'package:rosewe_online_shopping/core/common_imports.dart';

class SubTab extends StatelessWidget {
  final String title;
  final Function() onTap;
  final String iconPath;
  final Color? backgroundColor;
  final Color? colorWidget;
  final Color? colorText;

  const SubTab({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconPath,
    this.backgroundColor,
    this.colorWidget,
    this.colorText = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.custom_button_color,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              CustomImage(color: colorWidget, iconPath, height: 25, width: 25),
              SizedBox(width: 10),
              Expanded(
                child: CustomText(
                  text: title,
                  textColor: colorText!,
                  fontSize: 17,
                ),
              ),
              CustomImage(color: colorWidget, AssetConstants.back_button_icon),
            ],
          ),
        ),
      ),
    );
  }
}
