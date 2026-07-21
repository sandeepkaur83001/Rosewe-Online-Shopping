import 'package:flutter_base/core/common_imports.dart';


class CustomTextField extends StatefulWidget {
  final String? errorMessage;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  bool allowedNumberOnly;
  final EdgeInsetsGeometry? prefixWidgetMargin;
  final EdgeInsetsGeometry? margin;
  int? inputTextLimit;
  final Color backgroundColor;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final double? hintTextSize;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;

  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.prefixWidget,
    this.errorMessage,
    this.suffixWidget,
    this.borderColor,
    this.fontWeight,
    this.margin,
    this.hintTextSize,
    this.prefixWidgetMargin,
    this.inputTextLimit,
    this.backgroundColor = AppColors.textFieldColor,
    this.keyboardType,
    this.allowedNumberOnly = false,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with WidgetsBindingObserver {
  bool _isObscure = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone) {
        KeyboardOverlay.showOverlay(context);
      }
    } else {
      KeyboardOverlay.removeOverlay();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor == AppColors.textFieldColor ? theme.cardColor : widget.backgroundColor;
    final textColor = widget.errorMessage != null ? AppColors.errorColor : theme.textTheme.bodyLarge?.color ?? AppColors.register_text_color;

    return Container(
      width: double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor != null ? (widget.borderColor!) : (widget.errorMessage != null ? AppColors.errorColorLight : bgColor), // Border color
          width: 2.0, // Border width (set to 2.0 in this case)
        ),
        color: widget.errorMessage != null ? AppColors.errorColorLight : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        focusNode: _focusNode,
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.inputTextLimit),
          widget.allowedNumberOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter,
        ],
        style: TextStyle(color: textColor, fontFamily: TextStyle().fontFamily, fontWeight: widget.fontWeight),
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        obscuringCharacter: "•",
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5), fontFamily: TextStyle().fontFamily, fontWeight: FontWeight.w500, fontSize: widget.hintTextSize),
          border: InputBorder.none,
          suffixIcon: widget.suffixWidget ??
              (widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                    
                        icon: Image.asset(
                          _isObscure ? AssetConstants.visibility : AssetConstants.visibility_off,
                          height: 25,
                          width: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    )
                  : null),
          prefixIcon: widget.prefixWidget != null
              ? Padding(
                  padding: widget.prefixWidgetMargin ?? EdgeInsets.zero,
                  child: widget.prefixWidget,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 15,
          ),
        ),
      ),
    );
  }

}

//ignore: must_be_immutable
class CustomTextFieldCenterText extends StatefulWidget {
  final String? errorMessage;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  bool allowedNumberOnly;
  bool readOnly;
  final EdgeInsetsGeometry? prefixWidgetMargin;
  final EdgeInsetsGeometry? margin;
  int? inputTextLimit;
  final Color backgroundColor;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final double? hintTextSize;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;

  CustomTextFieldCenterText({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.prefixWidget,
    this.errorMessage,
    this.suffixWidget,
    this.borderColor,
    this.fontWeight,
    this.margin,
    this.hintTextSize,
    this.prefixWidgetMargin,
    this.inputTextLimit,
    this.backgroundColor = AppColors.textFieldColor,
    this.keyboardType,
    this.allowedNumberOnly = false,
    this.readOnly = false,
    this.focusNode,
  });
  @override
  State<CustomTextFieldCenterText> createState() => _CustomTextFieldCenterTextState();
}

class _CustomTextFieldCenterTextState extends State<CustomTextFieldCenterText> with WidgetsBindingObserver {
  bool _isObscure = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone) {
        KeyboardOverlay.showOverlay(context);
      }
    } else {
      KeyboardOverlay.removeOverlay();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor == AppColors.textFieldColor ? theme.cardColor : widget.backgroundColor;
    final textColor = widget.errorMessage != null ? AppColors.errorColor : theme.textTheme.bodyLarge?.color ?? AppColors.register_text_color;

    return Container(
      width: double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor != null ? (widget.borderColor!) : (widget.errorMessage != null ? AppColors.errorColorLight : bgColor), // Border color
          width: 2.0, // Border width (set to 2.0 in this case)
        ),
        color: widget.errorMessage != null ? AppColors.errorColorLight : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        focusNode: _focusNode,
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: widget.readOnly,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.inputTextLimit),
          widget.allowedNumberOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter,
        ],
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontFamily: TextStyle().fontFamily, fontWeight: widget.fontWeight),
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        obscuringCharacter: "•",
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5), fontFamily: TextStyle().fontFamily, fontWeight: FontWeight.w500, fontSize: widget.hintTextSize),
          border: InputBorder.none,
          suffixIcon: widget.suffixWidget ??
              (widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                    
                        icon: Image.asset(
                          _isObscure ? AssetConstants.visibility : AssetConstants.visibility_off,
                          height: 25,
                          width: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    )
                  : null),
          prefixIcon: widget.prefixWidget != null
              ? Padding(
                  padding: widget.prefixWidgetMargin ?? EdgeInsets.zero,
                  child: widget.prefixWidget,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 15,
          ),
        ),
      ),
    );
  }
}
