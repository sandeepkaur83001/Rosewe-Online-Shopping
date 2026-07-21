
import 'package:flutter/material.dart';

import 'custom_text.dart';

enum MessageType { info, warning, error, success }

class TopBanner extends StatefulWidget {
  const TopBanner({super.key});

  @override
  TopBannerState createState() => TopBannerState();
}

class TopBannerState extends State<TopBanner> {
  bool _visible = false;
  String _message = "";
  bool _loader = false;
  MessageType? _type;

  // Added notifier to control IgnorePointer in BaseScreen
  final ValueNotifier<bool> isVisible = ValueNotifier(false);

  double get _height => _visible ? 70 : 0;
  bool get shouldBlockUI => _visible && _loader;


  void showTopBanner({
    required MessageType type,
    String? message = "Loading ....",
    bool? showLoader = false,
  }) {
    _visible = true;
    _message = message!;
    _type = type;
    _loader = showLoader!;

    // Update notifier
    isVisible.value = true;

    setState(() {});

    // Auto-hide for types
    if (type != MessageType.info) {
      _autoHide(seconds: 2);
    }
  }

  void hideTopBanner() {
    _visible = false;
    // Update notifier
    isVisible.value = false;

    setState(() {});
  }

  /// Auto-hide helper
  void _autoHide({required int seconds}) {
    Future.delayed(Duration(seconds: seconds), () {
      if (mounted) hideTopBanner();
    });
  }

  Color getColor() {
    switch (_type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.info:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: getColor()),
      child: _visible
          ? Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 10),

                if (_loader)
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),

                if (_loader) const SizedBox(width: 12),

                Expanded(child: CustomText(text: _message)),
              ],
            )
          : null,
    );
  }
}
