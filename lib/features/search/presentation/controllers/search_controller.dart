import 'package:messanger_ax/exports.dart';

class SearchPageController extends GetxController {
  final query = ''.obs;
  late final TextEditingController textController;

  final recent = <String>[
    'Olivia Williams',
    'Design Team',
    'Product Sync',
  ].obs;

  final _catalog = const [
    SearchResultItem(
      title: 'Olivia Williams',
      subtitle: 'Can we sync on the launch plan?',
      type: SearchResultType.chat,
    ),
    SearchResultItem(
      title: 'Design Team',
      subtitle: 'New mockups are ready for review',
      type: SearchResultType.chat,
    ),
    SearchResultItem(
      title: 'Product Sync',
      subtitle: 'Standup moved to 11:30',
      type: SearchResultType.chat,
    ),
    SearchResultItem(
      title: 'Alex Rivera',
      subtitle: 'Product Manager',
      type: SearchResultType.contact,
    ),
    SearchResultItem(
      title: 'Emma Thompson',
      subtitle: 'Content Strategist',
      type: SearchResultType.contact,
    ),
    SearchResultItem(
      title: 'Nina Williams',
      subtitle: 'Product Designer',
      type: SearchResultType.contact,
    ),
    SearchResultItem(
      title: 'Liam Neeson',
      subtitle: 'Outgoing · Yesterday',
      type: SearchResultType.call,
    ),
    SearchResultItem(
      title: 'Noah Parker',
      subtitle: 'Missed · Sunday',
      type: SearchResultType.call,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) => query.value = value.trim();

  void clearQuery() {
    textController.clear();
    query.value = '';
  }

  void clearHistory() => recent.clear();

  void applyRecent(String value) {
    textController.text = value;
    textController.selection = TextSelection.collapsed(offset: value.length);
    query.value = value;
  }

  List<SearchResultItem> get results {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return const [];
    return _catalog
        .where(
          (item) =>
              item.title.toLowerCase().contains(q) ||
              item.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }
}
