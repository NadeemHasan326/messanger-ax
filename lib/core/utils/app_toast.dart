import 'dart:async';

import 'package:messanger_ax/exports.dart';

class AppToast {
  AppToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;
  static GlobalKey<AppToastOverlayState>? _overlayKey;

  static void show(
    String message, {
    AppToastType type = AppToastType.info,
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismiss(immediate: true);

    final overlay = _overlayState;
    if (overlay == null) return;

    _overlayKey = GlobalKey<AppToastOverlayState>();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AppToastOverlay(
        key: _overlayKey,
        message: message,
        type: type,
        position: position,
        onDismissed: () {
          if (_entry == entry) {
            entry.remove();
            _entry = null;
            _overlayKey = null;
          }
        },
      ),
    );

    _entry = entry;
    overlay.insert(entry);

    _timer = Timer(duration, () => _dismiss());
  }

  /// Resolves the root navigator overlay without relying on route [BuildContext].
  static OverlayState? get _overlayState {
    final navigatorOverlay = Get.key.currentState?.overlay;
    if (navigatorOverlay != null && navigatorOverlay.mounted) {
      return navigatorOverlay;
    }

    final context = Get.overlayContext ?? Get.context;
    if (context == null) return null;

    return Overlay.maybeOf(context, rootOverlay: true);
  }

  static void success(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    show(message, type: AppToastType.success, position: position);
  }

  static void error(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    show(message, type: AppToastType.error, position: position);
  }

  static void info(
    String message, {
    AppToastPosition position = AppToastPosition.top,
  }) {
    show(message, type: AppToastType.info, position: position);
  }

  static void warning(
    String message, {
    AppToastPosition position = AppToastPosition.top,
  }) {
    show(message, type: AppToastType.warning, position: position);
  }

  static void _dismiss({bool immediate = false}) {
    _timer?.cancel();
    _timer = null;

    final state = _overlayKey?.currentState;
    if (state != null && !immediate) {
      state.dismiss();
      return;
    }

    _entry?.remove();
    _entry = null;
    _overlayKey = null;
  }
}
