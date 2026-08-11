import 'package:rosewe_online_shopping/core/common_imports.dart';

class BackButtonCustom extends StatelessWidget {
  final Function()? onSubmit;
  final EdgeInsetsGeometry? padding;
  const BackButtonCustom({super.key, this.onSubmit, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 50.0, left: 24),
      child: InkWell(
        onTap:
            onSubmit ??
            () {
          
              RouteNavigate().safePop(context);
            },
        borderRadius: BorderRadius.circular(21),
        child: CustomImage(
          width: 42,
          height: 42,
          AssetConstants.back_button_icon,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
