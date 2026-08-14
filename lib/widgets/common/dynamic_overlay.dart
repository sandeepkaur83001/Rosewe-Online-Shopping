import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';

class DynamicOverlay {
  static Completer<void>? _completer;
  static bool _blocked = false;
  static String? _currentMessage;
  static OverlayEntry? _overlayEntry;
  static bool _shouldShow = false;

  DynamicOverlay._();

  static void block() {
    _blocked = true;
  }

  static void unblock() {
    _blocked = false;
  }

  static void show({
    String? message = 'Loading...',
    bool isNoInternet = false,
  }) {
    if (_blocked) return;
    _shouldShow = true;

    if (_overlayEntry != null) {
      _currentMessage = message;
      _overlayEntry?.markNeedsBuild();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    _currentMessage = message;
    _completer = Completer<void>();

    void insertOverlay() {
      if (!_shouldShow || _overlayEntry != null) return;

      OverlayState? overlayState;
      try {
        overlayState = Get.overlayContext != null ? Overlay.maybeOf(Get.overlayContext!) : null;
      } catch (e) {
        overlayState = null;
      }
      
      if (overlayState == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          insertOverlay();
        });
        return;
      }

      _overlayEntry = OverlayEntry(
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: isNoInternet
                    ? _buildNoInternet()
                    : _buildLoader(_currentMessage),
              ),
            ),
          );
        },
      );

      try {
        overlayState.insert(_overlayEntry!);
      } catch (e) {
        _overlayEntry = null;
        debugPrint("Error inserting DynamicOverlay: $e");
      }
    }

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        insertOverlay();
      });
    } else {
      insertOverlay();
    }
  }

  static Widget _buildNoInternet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpinKitWave(
            color: Colors.white,
            size: 50.0,
            itemCount: 5,
          ),
          const SizedBox(height: 24),
          const CustomText(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            textColor: Colors.white,
            text: 'No Internet Connection',
          ),
          const SizedBox(height: 8),
          const CustomText(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            textColor: Colors.white,
            align: TextAlign.center,
            text: "Please check your internet connection and try again.",
          ),
        ],
      ),
    );
  }

  static Widget _buildLoader(String? message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpinKitFadingCircle(
            color: AppColors.custom_button_color,
            size: 60.0,
          ),
          if (message != null && message.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static void hide() {
    _shouldShow = false;
    if (_overlayEntry != null) {
      try {
        _overlayEntry?.remove();
      } catch (e) {
        debugPrint("Error removing DynamicOverlay: $e");
      }
      _overlayEntry = null;
      _currentMessage = null;

      if (_completer != null && !_completer!.isCompleted) {
        _completer?.complete();
      }
      _completer = null;
    }
  }

  static bool isShowing() => _overlayEntry != null;

  static Future<void> waitUntilHidden() async {
    final completer = _completer;
    if (completer == null || completer.isCompleted) return;
    await completer.future;
  }
}
