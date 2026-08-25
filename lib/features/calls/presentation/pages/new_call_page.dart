import 'package:messanger_ax/exports.dart';

class NewCallPage extends GetView<NewCallController> {
  const NewCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 20.w, 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Call',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          'Pick someone to call',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LandingSearchBar(
              hint: 'Search name or number',
              showFilter: false,
              controller: controller.searchController,
              onChanged: controller.onQueryChanged,
              autofocus: true,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final q = controller.query.value;
                if (q.isNotEmpty && controller.filteredContacts.isEmpty) {
                  return Center(
                    child: Text(
                      'No contacts for “$q”',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  );
                }
                return _CallContactList(controller: controller, showRecent: q.isEmpty);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallContactList extends StatelessWidget {
  const _CallContactList({
    required this.controller,
    required this.showRecent,
  });

  final NewCallController controller;
  final bool showRecent;

  @override
  Widget build(BuildContext context) {
    final grouped = controller.groupedContacts;
    final sections = grouped.keys.toList()..sort();

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
          if (showRecent && controller.recentContacts.isNotEmpty) ...[
            Text(
              'RECENT',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                color: AppColors.black.withValues(alpha: 0.8),
              ),
            ),
            ...controller.recentContacts.map(
              (contact) => _CallContactTile(
                contact: contact,
                onCall: () => controller.startCall(contact),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          Text(
            'ALL CONTACTS',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: AppColors.black.withValues(alpha: 0.8),
            ),
          ),
          for (final letter in sections) ...[
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
              child: Text(
                letter,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            ...grouped[letter]!.map(
              (contact) => _CallContactTile(
                contact: contact,
                onCall: () => controller.startCall(contact),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CallContactTile extends StatelessWidget {
  const _CallContactTile({
    required this.contact,
    required this.onCall,
  });

  final CallContact contact;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          UserAvatar(name: contact.name, showOnline: contact.online),
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
          GestureDetector(
            onTap: onCall,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.logoBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.call_rounded,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
