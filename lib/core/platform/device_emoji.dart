import 'dart:io';

import 'package:messanger_ax/exports.dart';

/// Bridges to the device emoji keyboard (iOS) or system emoji picker (Android).
class DeviceEmoji {
  DeviceEmoji._();

  static const channelName = 'messanger_ax/device_emoji';
  static const androidViewType = 'messanger_ax/device_emoji_picker';

  static const _channel = MethodChannel(channelName);

  static bool get usesInlinePicker => Platform.isAndroid;

  static void listen(void Function(String emoji) onEmoji) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'emojiPicked') {
        final emoji = call.arguments as String?;
        if (emoji != null && emoji.isNotEmpty) onEmoji(emoji);
      }
    });
  }

  static void stopListening() {
    _channel.setMethodCallHandler(null);
  }

  static Future<bool> showSystemPicker() async {
    if (!Platform.isIOS) return false;
    try {
      final opened = await _channel.invokeMethod<bool>('show');
      return opened ?? true;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> hide() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('hide');
    } on MissingPluginException {
      // Channel is only implemented on iOS.
    } on PlatformException {
      // Keyboard may already be dismissed.
    }
  }
}
