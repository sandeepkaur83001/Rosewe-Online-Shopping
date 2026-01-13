import 'package:flutter_base/util/common_imports.dart';
import 'package:flutter_base/util/top_banner.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool? resizeToAvoidBottomInset;
  final GlobalKey<TopBannerState>? topBannerKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const BaseScreen({
    super.key,
    this.topBannerKey,
    this.scaffoldKey,
    required this.child,
    this.resizeToAvoidBottomInset,
    this.color = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    Globals.screenDimensions(context);

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey, // assign key
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      body: SafeArea(
        child: Column(
          children: [
            if (topBannerKey != null) TopBanner(key: topBannerKey),

            Expanded(
              child: Builder(
                builder: (_) {
                  final state = topBannerKey?.currentState;

                  // If state is null do NOT disable screen
                  if (state == null) {
                    return child;
                  }

                  return ValueListenableBuilder<bool>(
                    valueListenable: state.isVisible,
                    builder: (_, __, childWidget) {
                      return IgnorePointer(
                        ignoring: state.shouldBlockUI,
                        child: childWidget,
                      );
                    },
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
