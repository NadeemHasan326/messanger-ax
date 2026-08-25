import 'dart:async';

import 'package:messanger_ax/exports.dart';

class InCallController extends GetxController {
  InCallController({CallSession? session})
      : session = session ?? const CallSession(name: 'Unknown');

  final CallSession session;
  final isMuted = false.obs;
  final isSpeakerOn = false.obs;
  final isConnecting = true.obs;
  final elapsed = Duration.zero.obs;

  Timer? _connectTimer;
  Timer? _ticker;

  String get elapsedLabel {
    final total = elapsed.value.inSeconds;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    _connectTimer = Timer(const Duration(seconds: 2), () {
      isConnecting.value = false;
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsed.value = elapsed.value + const Duration(seconds: 1);
      });
    });
  }

  void toggleMute() => isMuted.toggle();

  void toggleSpeaker() => isSpeakerOn.toggle();

  void hangUp() {
    AppNavigation.back();
  }

  @override
  void onClose() {
    _connectTimer?.cancel();
    _ticker?.cancel();
    super.onClose();
  }
}
