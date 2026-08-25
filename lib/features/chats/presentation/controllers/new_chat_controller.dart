import 'package:messanger_ax/exports.dart';

class NewChatController extends GetxController {
  final query = ''.obs;
  late final TextEditingController searchController;

  final quickActions = const [
    QuickActionItem(
      label: 'New Group',
      subtitle: 'Create a team chat',
      icon: Icons.group_add_rounded,
      color: AppColors.primary,
      route: AppRoutes.createGroup,
    ),
    QuickActionItem(
      label: 'New Contact',
      subtitle: 'Add someone new',
      icon: Icons.person_add_alt_1_rounded,
      color: AppColors.avatarViolet,
      route: AppRoutes.addContact,
    ),
  ];

  final contacts = const [
    NewChatContact(
      name: 'Olivia Williams',
      role: 'Marketing Lead',
      section: 'O',
      online: true,
      recent: true,
    ),
    NewChatContact(
      name: 'Alex Rivera',
      role: 'Product Manager',
      section: 'A',
      online: true,
      recent: true,
    ),
    NewChatContact(
      name: 'Nina Williams',
      role: 'Product Designer',
      section: 'N',
      online: true,
      recent: true,
    ),
    NewChatContact(
      name: 'David Chen',
      role: 'Engineering Lead',
      section: 'D',
      online: true,
    ),
    NewChatContact(
      name: 'Emma Thompson',
      role: 'Content Strategist',
      section: 'E',
      online: true,
    ),
    NewChatContact(name: 'Liam Neeson', role: 'Sales Director', section: 'L'),
    NewChatContact(name: 'Noah Parker', role: 'Data Analyst', section: 'N'),
    NewChatContact(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    NewChatContact(
      name: 'Benjamin Lee',
      role: 'iOS Engineer',
      section: 'B',
      online: true,
    ),
    NewChatContact(
      name: 'Chloe Martinez',
      role: 'Marketing Lead',
      section: 'C',
    ),
    NewChatContact(
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

  List<NewChatContact> get filteredContacts {
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

  List<NewChatContact> get recentContacts =>
      contacts.where((c) => c.recent).toList();

  Map<String, List<NewChatContact>> get groupedContacts {
    final map = <String, List<NewChatContact>>{};
    for (final contact in filteredContacts) {
      map.putIfAbsent(contact.section, () => []).add(contact);
    }
    return map;
  }

  void onQuickAction(QuickActionItem action) {
    AppNavigation.push(action.route);
  }

  void startChat(NewChatContact contact) {
    ChatNavigation.open(name: contact.name, online: contact.online);
  }
}
