import 'package:rosewe_online_shopping/core/common_imports.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double height;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: SizedBox(
        width: height,
        height: height / 2,
        child: Stack(
          children: [
            Container(
              width: height,
              height: height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 4),

                color: value
                    ? AppColors.custom_button_color
                    : AppColors.custom_button_color.withValues(alpha: 0.8),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              left: value ? height / 2 : 0.0,
              child: SizedBox(
                width: height / 2,
                height: height / 2,
                child: Center(
                  child: Container(
                    width: (height / 2) - 7,
                    height: (height / 2) - 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 4),
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
