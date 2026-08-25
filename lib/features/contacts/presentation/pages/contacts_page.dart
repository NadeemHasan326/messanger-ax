import 'package:messanger_ax/exports.dart';

class ContactsPage extends GetView<ContactsController> {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = controller.grouped;
    final sections = grouped.keys.toList()..sort();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          LandingHeader(
            title: 'Contacts',
            subtitle: 'All your connections',
            actionIcon: Icons.add_rounded,
            onAction: () => AppNavigation.push(AppRoutes.addContact),
          ),
          const LandingSearchBar(hint: 'Search contacts'),
          SizedBox(height: 14.h),
          Obx(
            () => FilterChipBar(
              items: controller.filters,
              selectedIndex: controller.selectedFilter.value,
              onSelected: controller.selectFilter,
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 36.w, 16.h),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final letter = sections[index];
                    final items = grouped[letter]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
                          child: Text(
                            letter,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ...items.map(
                          (contact) => _ContactTile(
                            contact: contact,
                            onTap: () => controller.openContact(contact),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  right: 6.w,
                  top: 20.h,
                  bottom: 20.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                        .split('')
                        .map(
                          (letter) => Text(
                            letter,
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                        .toList(),
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

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onTap});

  final ContactItem contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Row(
          children: [
            UserAvatar(name: contact.name),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    contact.role,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            _RoundAction(icon: Icons.call_outlined, onTap: () {}),
            SizedBox(width: 8.w),
            _RoundAction(icon: Icons.chat_bubble_outline_rounded, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.primary),
      ),
    );
  }
}
