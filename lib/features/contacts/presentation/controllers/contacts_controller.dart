import 'package:messanger_ax/exports.dart';

class ContactsController extends GetxController {
  final selectedFilter = 0.obs;
  final filters = const [
    FilterChipData('All'),
    FilterChipData('Team'),
    FilterChipData('Friends'),
    FilterChipData('Family'),
  ];

  final contacts = const [
    ContactItem(name: 'Alex Rivera', role: 'Product Manager', section: 'A'),
    ContactItem(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    ContactItem(name: 'Benjamin Lee', role: 'iOS Engineer', section: 'B'),
    ContactItem(name: 'Chloe Martinez', role: 'Marketing Lead', section: 'C'),
    ContactItem(name: 'Daniel Brooks', role: 'Backend Engineer', section: 'D'),
    ContactItem(name: 'Emma Thompson', role: 'Content Strategist', section: 'E'),
    ContactItem(name: 'Nina Williams', role: 'Product Designer', section: 'N'),
  ];

  void selectFilter(int index) => selectedFilter.value = index;

  Map<String, List<ContactItem>> get grouped {
    final map = <String, List<ContactItem>>{};
    for (final contact in contacts) {
      map.putIfAbsent(contact.section, () => []).add(contact);
    }
    return map;
  }

  void openContact(ContactItem contact) {
    AppNavigation.push(AppRoutes.contactDetail, arguments: contact);
  }
}
