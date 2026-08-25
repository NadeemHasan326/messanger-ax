import 'package:messanger_ax/exports.dart';

class CallsController extends GetxController {
  final selectedTab = 0.obs;
  final query = ''.obs;
  final dateFilter = CallDateFilter.all.obs;
  late final TextEditingController searchController;

  final tabs = const [
    FilterChipData('All'),
    FilterChipData('Missed'),
    FilterChipData('Voicemail'),
  ];

  final calls = const [
    CallItem(name: 'Olivia Williams', type: CallType.incoming, time: 'Today, 9:20 AM'),
    CallItem(name: 'Liam Neeson', type: CallType.outgoing, time: 'Today, 8:05 AM'),
    CallItem(name: 'Emma Thompson', type: CallType.missed, time: 'Yesterday'),
    CallItem(name: 'Noah Parker', type: CallType.incoming, time: 'Mon'),
    CallItem(name: 'Nina Williams', type: CallType.missed, time: 'Sun'),
  ];

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void selectTab(int index) => selectedTab.value = index;

  void onSearchChanged(String value) => query.value = value.trim();

  void setDateFilter(CallDateFilter filter) => dateFilter.value = filter;

  void clearDateFilter() => dateFilter.value = CallDateFilter.all;

  String get dateFilterLabel => switch (dateFilter.value) {
        CallDateFilter.all => 'All',
        CallDateFilter.today => 'Today',
        CallDateFilter.yesterday => 'Yesterday',
        CallDateFilter.thisWeek => 'This week',
      };

  List<CallItem> get filtered {
    var list = List<CallItem>.from(calls);

    if (selectedTab.value == 1) {
      list = list.where((c) => c.type == CallType.missed).toList();
    }

    switch (dateFilter.value) {
      case CallDateFilter.today:
        list = list
            .where((c) => c.time.toLowerCase().startsWith('today'))
            .toList();
      case CallDateFilter.yesterday:
        list = list
            .where((c) => c.time.toLowerCase().startsWith('yesterday'))
            .toList();
      case CallDateFilter.thisWeek:
        list = list.where((c) {
          final t = c.time.toLowerCase();
          return t.startsWith('today') ||
              t.startsWith('yesterday') ||
              t.startsWith('mon') ||
              t.startsWith('sun');
        }).toList();
      case CallDateFilter.all:
        break;
    }

    final q = query.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.time.toLowerCase().contains(q),
          )
          .toList();
    }

    return list;
  }
}
