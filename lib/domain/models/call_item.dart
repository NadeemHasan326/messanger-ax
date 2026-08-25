import 'package:messanger_ax/core/constants/app_enums.dart';

class CallItem {
  const CallItem({
    required this.name,
    required this.type,
    required this.time,
  });

  final String name;
  final CallType type;
  final String time;
}
