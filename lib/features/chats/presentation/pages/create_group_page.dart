import 'package:messanger_ax/exports.dart';

class CreateGroupPage extends GetView<CreateGroupController> {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CreateGroupHeader(),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
              child: Obx(
                () => DisplayPicturePicker(
                  bytes: controller.avatarBytes.value,
                  placeholderIcon: Icons.groups_rounded,
                  onTap: controller.pickAvatar,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => AuthTextField(
                  label: 'Group Name',
                  hint: 'Design Team',
                  controller: controller.groupNameController,
                  textInputAction: TextInputAction.next,
                  errorText: controller.groupNameError.value,
                  onChanged: controller.onGroupNameChanged,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            LandingSearchBar(
              hint: 'Search members',
              showFilter: false,
              controller: controller.searchController,
              onChanged: controller.onQueryChanged,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => Text(
                  '${controller.selectedMembers.length} selected · min 2 required',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                final grouped = controller.groupedMembers;
                final sections = grouped.keys.toList()..sort();
                if (sections.isEmpty) {
                  return Center(
                    child: Text(
                      'No members found',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softShadow,
                        blurRadius: 16.r,
                        offset: Offset(0, -4.h),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
                    children: [
                      for (final letter in sections) ...[
                        Text(
                          letter,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ...grouped[letter]!.map(
                          (member) => _MemberTile(
                            member: member,
                            selected: controller.isSelected(member),
                            onTap: () => controller.toggleMember(member),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Obx(
                () {
                  final enabled = controller.groupName.value.isNotEmpty &&
                      controller.selectedMembers.length >= 2;
                  return AuthPrimaryButton(
                    label: 'Create Group',
                    isLoading: controller.isLoading.value,
                    onPressed: enabled ? controller.createGroup : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateGroupHeader extends StatelessWidget {
  const _CreateGroupHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 20.w, 12.h),
      child: Row(
        children: [
          const AppBackButton(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Group',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.15,
                  ),
                ),
                Text(
                  'Add a name and pick members',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.selected,
    required this.onTap,
  });

  final GroupMember member;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            UserAvatar(name: member.name),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    member.role,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.divider,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, size: 16.sp, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
