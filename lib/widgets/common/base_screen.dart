import 'package:flutter_base/core/common_imports.dart';


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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: scaffoldKey, // assign key
        backgroundColor: color == AppColors.whiteColor ? Theme.of(context).scaffoldBackgroundColor : color,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      body: SafeArea(
        child: Column(
          children: [
            _buildNoInternetBar(),
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
    ));
  }

  Widget _buildNoInternetBar() {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final connectivityResult = snapshot.data;
        if (connectivityResult != null && connectivityResult.contains(ConnectivityResult.none)) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.red,
            child: const Center(
              child: CustomText(
                text: 'No Internet Connection',
                fontSize: 12,
                textColor: Colors.white,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
