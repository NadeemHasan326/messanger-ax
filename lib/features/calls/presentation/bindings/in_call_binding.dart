import 'package:messanger_ax/exports.dart';

class InCallBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final session = args is CallSession
        ? args
        : const CallSession(name: 'Unknown');
    Get.put(InCallController(session: session));
  }
}
