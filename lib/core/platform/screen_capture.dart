import 'package:messanger_ax/exports.dart';

/// Blocks screenshots (Android) and reports capture events.
class ScreenCapture {
  ScreenCapture._();

  static const channelName = 'messanger_ax/screen_capture';
  static const _channel = MethodChannel(channelName);

  static void Function()? _onScreenshot;

  static void listen(void Function() onScreenshot) {
    _onScreenshot = onScreenshot;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'screenshotTaken') {
        _onScreenshot?.call();
      }
    });
  }

  static void stopListening() {
    _onScreenshot = null;
    _channel.setMethodCallHandler(null);
  }

  static Future<void> setBlocked(bool blocked) async {
    try {
      await _channel.invokeMethod<void>('setBlocked', blocked);
    } on MissingPluginException {
      // Channel is unimplemented on some desktop targets.
    } on PlatformException {
      // Window flag may already match the requested state.
    }
  }
}
