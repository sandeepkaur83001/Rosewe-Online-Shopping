import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeleton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final SkeletonizerConfigData? config;

  const CustomSkeleton({
    super.key,
    required this.child,
    required this.isLoading,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1000),
      ),
      child: child,
    );
  }
}
