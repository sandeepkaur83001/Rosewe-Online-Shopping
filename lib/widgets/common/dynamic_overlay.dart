import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/widgets/common/custom_loader.dart';

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
    logToConsole("DynamicOverlay: show called, message: $message, entry exists: ${_overlayEntry != null}");

    if (_overlayEntry != null) {
      _currentMessage = message;
      _overlayEntry?.markNeedsBuild();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    _currentMessage = message;
    _completer = Completer<void>();

    void insertOverlay() {
      if (!_shouldShow || _overlayEntry != null) {
        logToConsole("DynamicOverlay: insertOverlay aborted - shouldShow: $_shouldShow, entry: ${_overlayEntry != null}");
        return;
      }

      OverlayState? overlayState;
      try {
        // Try the Get.key (standard Navigator key in GetX)
        overlayState = Get.key.currentState?.overlay;
        
        // Fallbacks
        if (overlayState == null) {
          if (Get.overlayContext != null) {
            overlayState = Overlay.maybeOf(Get.overlayContext!);
          }
          overlayState ??= Overlay.maybeOf(Get.context!);
        }
      } catch (e) {
        logToConsole("DynamicOverlay: Exception finding overlayState: $e");
        overlayState = null;
      }
      
      if (overlayState == null) {
        logToConsole("DynamicOverlay: overlayState is STILL NULL, retrying next frame...");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          insertOverlay();
        });
        return;
      }

      logToConsole("DynamicOverlay: Inserting OverlayEntry...");
      _overlayEntry = OverlayEntry(
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5), // Increased opacity
                alignment: Alignment.center,
                child: isNoInternet
                    ? _buildNoInternet()
                    : CircularDotLoader(
                        label: _currentMessage ?? '',
                        size: 110,
                        backgroundColor: const Color(0xFF424242).withValues(alpha: 0.9), // More solid background
                      ),
              ),
            ),
          );
        },
      );

      try {
        overlayState.insert(_overlayEntry!);
        logToConsole("DynamicOverlay: OverlayEntry inserted successfully");
      } catch (e) {
        _overlayEntry = null;
        logToConsole("DynamicOverlay: Error during insertion: $e");
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
    logToConsole("DynamicOverlay: hide called, entry exists: ${_overlayEntry != null}");
    if (_overlayEntry != null) {
      try {
        _overlayEntry?.remove();
        logToConsole("DynamicOverlay: OverlayEntry removed");
      } catch (e) {
        logToConsole("DynamicOverlay: Error removing entry: $e");
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
