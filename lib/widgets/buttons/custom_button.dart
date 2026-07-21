import 'package:flutter_base/core/common_imports.dart';

class GlossyButton extends StatelessWidget {
  final String text;
  final double height;
  final double elevation;
  final double width;
  final int? maxLine;
  final double borderRadius;
  final Color buttonColor;
  final Color borderColor;
  final Color? shadowColor;

  final double widthDecoration;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Function()? onSubmit;

  const GlossyButton({
    super.key,
    required this.text,
    this.onSubmit,
    this.height = 60,
    this.elevation = 7,
    this.widthDecoration = 2,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.buttonColor = AppColors.custom_button_color,
    this.borderColor = AppColors.custom_button_color,
    this.shadowColor,
    this.textColor = AppColors.whiteColor,
    this.fontSize = 18,
    this.maxLine,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onSubmit ?? () {},
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Colors.black.withValues(alpha: 0.2),
                offset: Offset(0, 6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Inner top white gradient shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Centered button content
              Center(
                child: CustomText(
                  text: text,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  textColor: textColor,
                  maxLine: maxLine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double elevation;
  final double width;
  final int? maxLine;
  final double borderRadius;
  final Color buttonColor;
  final Color borderColor;
  final Color? shadowColor;

  final double widthDecoration;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Function()? onSubmit;

  const CustomButton({
    super.key,
    required this.text,
    this.onSubmit,
    this.height = 60,
    this.elevation = 7,
    this.widthDecoration = 2,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.buttonColor = AppColors.custom_button_color,
    this.borderColor = AppColors.custom_button_color,
    this.shadowColor,
    this.textColor = AppColors.whiteColor,
    this.fontSize = 18,
    this.maxLine,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onSubmit ?? () {},
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Material(
          shadowColor: shadowColor,
          elevation: elevation,
          color: Colors.transparent,
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: widthDecoration, // Set the border width to 5
              ),
              color: buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            child: Center(
              child: CustomText(
                text: text,
                fontWeight: fontWeight,
                fontSize: fontSize,
                textColor: textColor,
                maxLine: maxLine,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final double height;
  final double elevation;
  final double width;
  final int? maxLine;
  final double borderRadius;
  final Color buttonColor;
  final Color borderColor;
  final Color? shadowColor;

  final double widthDecoration;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Function()? onSubmit;

  const OutlineButton({
    super.key,
    required this.text,
    this.onSubmit,
    this.height = 60,
    this.elevation = 7,
    this.widthDecoration = 2,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.buttonColor = AppColors.custom_button_color,
    this.borderColor = AppColors.custom_button_color,
    this.shadowColor,
    this.textColor = AppColors.whiteColor,
    this.fontSize = 18,
    this.maxLine,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onSubmit ?? () {},
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: PhysicalModel(
          color: Colors.transparent, // No background fill
          elevation: elevation,
          shadowColor: shadowColor ?? Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: borderColor, width: widthDecoration),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            child: Center(
              child: CustomText(
                text: text,
                fontWeight: fontWeight,
                fontSize: fontSize,
                textColor: textColor,
                maxLine: maxLine,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double borderRadius;
  final Color buttonColor;
  final Color borderColor;
  final double widthDecoration;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final String? imageString;
  final Function()? onTap;

  const SocialButton({
    super.key,
    required this.text,
    this.height = 50,
    this.widthDecoration = 2,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.buttonColor = AppColors.custom_button_color,
    this.borderColor = AppColors.custom_button_color,
    this.textColor = AppColors.whiteColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.imageString,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 15,
    ), // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  borderColor, // Set the border color (optional, I set black)
              width: widthDecoration, // Set the border width to 5
            ),
            color: buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageString != null) ...[
                CustomImage(
                  imageString!,
                  width: 22,
                  height: 22,
                  fit: BoxFit.fitHeight,
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CustomText(
                  text: text,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  textColor: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
