import 'package:rosewe_online_shopping/core/common_imports.dart';

class NetworkImageView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Alignment alignment;

  const NetworkImageView({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => placeholder ?? CustomSkeleton(
        isLoading: true,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      errorWidget: (context, url, error) => placeholder ?? Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Image.asset("assets/images/rosewe_logo_clean.png", color: Colors.white.withOpacity(0.1),
            colorBlendMode: BlendMode.modulate,),
        ),
      ),
    );

    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }

    return image;
  }
}
