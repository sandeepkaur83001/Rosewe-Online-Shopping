import 'package:rosewe_online_shopping/core/common_imports.dart';

class GlossyButton extends StatefulWidget {
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
  State<GlossyButton> createState() => _GlossyButtonState();
}

class _GlossyButtonState extends State<GlossyButton> {
  static DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(milliseconds: 1000)) {
      _lastTapTime = now;
      if (widget.onSubmit != null) {
        widget.onSubmit!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ?? Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 6),
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
                  borderRadius: BorderRadius.circular(widget.borderRadius),
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
                  text: widget.text,
                  fontWeight: widget.fontWeight,
                  fontSize: widget.fontSize,
                  textColor: widget.textColor,
                  maxLine: widget.maxLine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomButton extends StatefulWidget {
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
    this.elevation = 0,
    this.widthDecoration = 2,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.buttonColor = AppColors.custom_button_color,
    this.borderColor = Colors.transparent,
    this.shadowColor,
    this.textColor = AppColors.whiteColor,
    this.fontSize = 18,
    this.maxLine,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  static DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(milliseconds: 1000)) {
      _lastTapTime = now;
      if (widget.onSubmit != null) {
        widget.onSubmit!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        child: Material(
          shadowColor: widget.shadowColor,
          elevation: widget.elevation,
          color: Colors.transparent,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.borderColor,
                width: widget.widthDecoration,
              ),
              color: widget.buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            ),
            child: Center(
              child: CustomText(
                text: widget.text,
                fontWeight: widget.fontWeight,
                fontSize: widget.fontSize,
                textColor: widget.textColor,
                maxLine: widget.maxLine,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
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
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  static DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(milliseconds: 1000)) {
      _lastTapTime = now;
      if (widget.onSubmit != null) {
        widget.onSubmit!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        child: PhysicalModel(
          color: Colors.transparent, // No background fill
          elevation: widget.elevation,
          shadowColor: widget.shadowColor ?? Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: widget.borderColor, width: widget.widthDecoration),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            ),
            child: Center(
              child: CustomText(
                text: widget.text,
                fontWeight: widget.fontWeight,
                fontSize: widget.fontSize,
                textColor: widget.textColor,
                maxLine: widget.maxLine,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatefulWidget {
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
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  static DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(milliseconds: 1000)) {
      _lastTapTime = now;
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.borderColor,
              width: widget.widthDecoration,
            ),
            color: widget.buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imageString != null) ...[
                CustomImage(
                  widget.imageString!,
                  width: 22,
                  height: 22,
                  fit: BoxFit.fitHeight,
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CustomText(
                  text: widget.text,
                  fontWeight: widget.fontWeight,
                  fontSize: widget.fontSize,
                  textColor: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
