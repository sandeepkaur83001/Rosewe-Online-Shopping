import 'package:rosewe_online_shopping/core/common_imports.dart';

class NetworkImageView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const NetworkImageView({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => CustomSkeleton(
          isLoading: true,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error_outline, color: Colors.grey),
        ),
      ),
    );
  }
}
