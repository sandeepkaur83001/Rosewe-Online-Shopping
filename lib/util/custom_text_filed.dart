import 'package:flutter_base/util/common_imports.dart';


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
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with WidgetsBindingObserver /*, KeyboardBackButtonMixin */ {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor != null ? (widget.borderColor!) : (widget.errorMessage != null ? AppColors.errorColorLight : widget.backgroundColor), // Border color
          width: 2.0, // Border width (set to 2.0 in this case)
        ),
        color: widget.errorMessage != null ? AppColors.errorColorLight : widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        // focusNode: focusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.inputTextLimit),
          widget.allowedNumberOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter,
        ],
        style: TextStyle(color: widget.errorMessage != null ? AppColors.errorColor : AppColors.register_text_color, fontFamily: TextStyle().fontFamily, fontWeight: widget.fontWeight),
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        obscuringCharacter: "•",
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.errorMessage != null ? AppColors.errorColor : AppColors.register_text_color, fontFamily: TextStyle().fontFamily, fontWeight: FontWeight.w500, fontSize: widget.hintTextSize),
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
  });
  @override
  State<CustomTextFieldCenterText> createState() => _CustomTextFieldCenterTextState();
}

class _CustomTextFieldCenterTextState extends State<CustomTextFieldCenterText> with WidgetsBindingObserver {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor != null ? (widget.borderColor!) : (widget.errorMessage != null ? AppColors.errorColorLight : widget.backgroundColor), // Border color
          width: 2.0, // Border width (set to 2.0 in this case)
        ),
        color: widget.errorMessage != null ? AppColors.errorColorLight : widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: widget.readOnly,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.inputTextLimit),
          widget.allowedNumberOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter,
        ],
        textAlign: TextAlign.center,
        style: TextStyle(color: widget.errorMessage != null ? AppColors.errorColor : AppColors.register_text_color, fontFamily: TextStyle().fontFamily, fontWeight: widget.fontWeight),
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        obscuringCharacter: "•",
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.errorMessage != null ? AppColors.errorColor : AppColors.register_text_color, fontFamily: TextStyle().fontFamily, fontWeight: FontWeight.w500, fontSize: widget.hintTextSize),
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
