import 'package:rosewe_online_shopping/core/common_imports.dart';

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
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final String? fontFamily;

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
    this.letterSpacing,
    this.fontStyle,
    this.decoration,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor == AppColors.register_text_color ? Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.register_text_color : textColor;

    final baseDecoration = decoration ?? TextDecoration.combine([
      if (isLineThrough == true) TextDecoration.lineThrough,
      if (isUnderline == true) TextDecoration.underline,
    ]);

    TextStyle style = TextStyle(
      decoration: baseDecoration,
      decorationColor: effectiveTextColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      height: lineHeight,
      color: effectiveTextColor,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      fontFamily: fontFamily ?? 'Humanist521',
    );

    if (fontFamily != null) {
      try {
        style = GoogleFonts.getFont(fontFamily!, textStyle: style);
      } catch (e) {
        style = style.copyWith(fontFamily: fontFamily);
      }
    }

    if (isAutoSize == true) {
      return AutoSizeText(
        text,
        maxLines: maxLine,
        textAlign: align,
        softWrap: softWrap,
        minFontSize: 8,
        style: style,
        overflow: overflow ?? TextOverflow.visible,
      );
    } else {
      return Text(
        text,
        maxLines: maxLine,
        textAlign: align,
        softWrap: softWrap,
        style: style,
        overflow: overflow ?? TextOverflow.visible,
      );
    }
  }
}
