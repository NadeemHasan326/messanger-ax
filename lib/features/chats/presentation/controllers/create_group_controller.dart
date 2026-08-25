import 'package:messanger_ax/exports.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final searchController = TextEditingController();

  final query = ''.obs;
  final selectedMembers = <String>{}.obs;
  final groupNameError = RxnString();
  final isLoading = false.obs;

  final members = const [
    GroupMember(name: 'Olivia Williams', role: 'Marketing Lead', section: 'O'),
    GroupMember(name: 'Alex Rivera', role: 'Product Manager', section: 'A'),
    GroupMember(name: 'Nina Williams', role: 'Product Designer', section: 'N'),
    GroupMember(name: 'David Chen', role: 'Engineering Lead', section: 'D'),
    GroupMember(name: 'Emma Thompson', role: 'Content Strategist', section: 'E'),
    GroupMember(name: 'Liam Neeson', role: 'Sales Director', section: 'L'),
    GroupMember(name: 'Noah Parker', role: 'Data Analyst', section: 'N'),
    GroupMember(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    GroupMember(name: 'Benjamin Lee', role: 'iOS Engineer', section: 'B'),
    GroupMember(name: 'Chloe Martinez', role: 'Marketing Lead', section: 'C'),
    GroupMember(name: 'Daniel Brooks', role: 'Backend Engineer', section: 'D'),
  ];

  final groupName = ''.obs;

  bool get canCreate =>
      groupName.value.isNotEmpty && selectedMembers.length >= 2;

  void onGroupNameChanged(String value) {
    groupName.value = value.trim();
    groupNameError.value = null;
  }

  @override
  void onClose() {
    groupNameController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) => query.value = value.trim();

  List<GroupMember> get filteredMembers {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return members;
    return members
        .where(
          (member) =>
              member.name.toLowerCase().contains(q) ||
              member.role.toLowerCase().contains(q),
        )
        .toList();
  }

  Map<String, List<GroupMember>> get groupedMembers {
    final map = <String, List<GroupMember>>{};
    for (final member in filteredMembers) {
      map.putIfAbsent(member.section, () => []).add(member);
    }
    return map;
  }

  void toggleMember(GroupMember member) {
    if (selectedMembers.contains(member.name)) {
      selectedMembers.remove(member.name);
    } else {
      selectedMembers.add(member.name);
    }
  }

  bool isSelected(GroupMember member) => selectedMembers.contains(member.name);

  Future<void> createGroup() async {
    final name = groupNameController.text.trim();
    if (name.isEmpty) {
      groupNameError.value = 'Group name is required';
      return;
    }
    if (selectedMembers.length < 2) {
      AppToast.warning('Select at least 2 members');
      return;
    }

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;

    AppToast.success('Group "$name" created');
    AppNavigation.back();
  }
}
