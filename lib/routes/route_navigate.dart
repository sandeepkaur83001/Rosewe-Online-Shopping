import 'package:rosewe_online_shopping/core/common_imports.dart';


class RouteNavigate {
  Future<void> navigateToReplacement(BuildContext context, Widget nextScreen) async {
    if (context.mounted) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      ).then((_) {
    
        // Call setState() here or handle this appropriately
      });
    }
  }

  Future<void> navigateToPushAndRemoveUntil(BuildContext context, Widget nextScreen) async {
    if (context.mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
        (route) => false,
      ).then((_) {
    
      });
    }
  }

  Future<dynamic> navigateToPush(
    BuildContext context,
    Widget nextScreen, [
    void Function()? onReturn,
  ]) async {
    if (context.mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
      if (onReturn != null) {
        onReturn();
      }
      return result;
    }
    return null;
  }

  Future<void> navigateToPushAnimateBottomSheet(
    BuildContext context,
    Widget nextScreen, [
    void Function()? setState,
  ]) async {
    if (context.mounted) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Start from bottom
            const end = Offset.zero; // End at normal position
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic)); // Add easing curve

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      ).then((_) {
        if (setState != null) {
          setState();
        }
      });
    }
  }

  Future<void> navigateToPushAnimate(
    BuildContext context,
    Widget nextScreen, [
    void Function()? setState,
  ]) async {
    if (context.mounted) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 600), // you can customize the duration
        ),
      ).then((_) {
        if (setState != null) {
          setState();
        }
      });
    }
  }

  void safePop(BuildContext context) {
    if (context.mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}
