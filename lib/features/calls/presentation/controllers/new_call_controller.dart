import 'package:messanger_ax/exports.dart';

class NewCallController extends GetxController {
  final query = ''.obs;
  late final TextEditingController searchController;

  final contacts = const [
    CallContact(
      name: 'Olivia Williams',
      role: 'Marketing Lead',
      section: 'O',
      online: true,
      recent: true,
    ),
    CallContact(
      name: 'Alex Rivera',
      role: 'Product Manager',
      section: 'A',
      online: true,
      recent: true,
    ),
    CallContact(
      name: 'Nina Williams',
      role: 'Product Designer',
      section: 'N',
      online: true,
      recent: true,
    ),
    CallContact(
      name: 'David Chen',
      role: 'Engineering Lead',
      section: 'D',
      online: true,
    ),
    CallContact(
      name: 'Emma Thompson',
      role: 'Content Strategist',
      section: 'E',
      online: true,
    ),
    CallContact(
      name: 'Liam Neeson',
      role: 'Sales Director',
      section: 'L',
    ),
    CallContact(
      name: 'Noah Parker',
      role: 'Data Analyst',
      section: 'N',
    ),
    CallContact(
      name: 'Ava Thompson',
      role: 'UX Designer',
      section: 'A',
    ),
    CallContact(
      name: 'Benjamin Lee',
      role: 'iOS Engineer',
      section: 'B',
      online: true,
    ),
    CallContact(
      name: 'Chloe Martinez',
      role: 'Marketing Lead',
      section: 'C',
    ),
    CallContact(
      name: 'Daniel Brooks',
      role: 'Backend Engineer',
      section: 'D',
    ),
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

  void onQueryChanged(String value) => query.value = value.trim();

  List<CallContact> get filteredContacts {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return contacts;
    return contacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.role.toLowerCase().contains(q),
        )
        .toList();
  }

  List<CallContact> get recentContacts =>
      contacts.where((c) => c.recent).toList();

  Map<String, List<CallContact>> get groupedContacts {
    final map = <String, List<CallContact>>{};
    for (final contact in filteredContacts) {
      map.putIfAbsent(contact.section, () => []).add(contact);
    }
    return map;
  }

  void startCall(CallContact contact) {
    CallNavigation.start(name: contact.name, online: contact.online);
  }
}
