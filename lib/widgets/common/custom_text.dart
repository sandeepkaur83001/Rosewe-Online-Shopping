import 'package:flutter_base/core/common_imports.dart';

class CustomText extends StatelessWidget {
  final FontWeight fontWeight;
  final double fontSize;
  final String text;
  final int? maxLine;
  final Color textColor;
  final TextAlign? align;
  final bool? isLineThrough;
  final TextOverflow? overflow;
  final bool? isUnderline;
  final double? lineHeight;
  final bool? isAutoSize;
  final bool? softWrap;

  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,
    this.maxLine,
    this.align,
    this.textColor = AppColors.register_text_color,
    this.isLineThrough,
    this.overflow,
    this.isUnderline,
    this.lineHeight,
    this.isAutoSize,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor == AppColors.register_text_color ? Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.register_text_color : textColor;

    if (isAutoSize == true) {
      return AutoSizeText(
        text,
        maxLines: maxLine,
        textAlign: align,
        softWrap: softWrap,
        minFontSize: 8,
        style: TextStyle(
          decoration: TextDecoration.combine([
            if (isLineThrough == true) TextDecoration.lineThrough,
            if (isUnderline == true) TextDecoration.underline,
          ]),
          decorationColor: effectiveTextColor,
          fontWeight: fontWeight,
          fontSize: fontSize ,
          height: lineHeight,
          color: effectiveTextColor,
        ),
        overflow: overflow ?? TextOverflow.visible,
      );
    } else {
      return Text(
        text,
        maxLines: maxLine,
        textAlign: align,
        softWrap: softWrap,
        style: TextStyle(
          decoration: TextDecoration.combine([
            if (isLineThrough == true) TextDecoration.lineThrough,
            if (isUnderline == true) TextDecoration.underline,
          ]),
          decorationColor: effectiveTextColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          height: lineHeight,
          color: effectiveTextColor,
        ),
        overflow: overflow ?? TextOverflow.visible,
      );
    }
  }
}

