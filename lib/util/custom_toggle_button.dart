// utils/widgets/custom_toggle_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_base/util/common_imports.dart'; // Adjust path as needed


class CustomToggleButton extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final double height;
  final double borderRadius;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const CustomToggleButton({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 48,
    this.borderRadius = 14,
    this.selectedColor = AppColors.custom_button_color,
    this.unselectedColor = const Color(0xFFF5F5F5),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF757575),
  });

  @override
  Widget build(BuildContext context) {
    assert(labels.length >= 2, 'At least 2 toggles required');

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: unselectedColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final isSelected = selectedIndex == index;
            final isFirst = index == 0;
            final isLast = index == labels.length - 1;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(index),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left:
                            isFirst ? Radius.circular(borderRadius) : Radius.zero,
                        right:
                            isLast ? Radius.circular(borderRadius) : Radius.zero,
                      ),
                    ),
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? selectedTextColor
                            : unselectedTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
