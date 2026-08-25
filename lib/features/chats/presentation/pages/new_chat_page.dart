import 'package:messanger_ax/exports.dart';

class NewChatPage extends GetView<NewChatController> {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _NewChatHeader(),
            LandingSearchBar(
              hint: 'Search name or number',
              showFilter: false,
              controller: controller.searchController,
              onChanged: controller.onQueryChanged,
              autofocus: true,
            ),
            SizedBox(height: 18.h),
            _QuickActionsRow(
              actions: controller.quickActions,
              onTap: controller.onQuickAction,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final q = controller.query.value;
                if (q.isNotEmpty && controller.filteredContacts.isEmpty) {
                  return _EmptySearchState(query: q);
                }
                return _ContactListBody(controller: controller, showRecent: q.isEmpty);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewChatHeader extends StatelessWidget {
  const _NewChatHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  'New Chat',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.15,
                  ),
                ),
                Text(
                  'Pick someone to message',
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

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.actions,
    required this.onTap,
  });

  final List<QuickActionItem> actions;
  final ValueChanged<QuickActionItem> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _QuickActionCard.cardHeight.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              _QuickActionCard(
                action: actions[i],
                onTap: () => onTap(actions[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.action,
    required this.onTap,
  });

  final QuickActionItem action;
  final VoidCallback onTap;

  static const cardHeight = 98.0;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.navy,
      height: 1.2,
    );
    final subtitleStyle = GoogleFonts.poppins(
      fontSize: 10.sp,
      color: AppColors.muted,
      height: 1.2,
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: cardHeight.h,
        width: 130.w,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.softShadow,
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(action.icon, color: action.color, size: 20.sp),
                ),
                const Spacer(),
                AdaptiveMarqueeText(
                  text: action.label,
                  style: labelStyle,
                ),
                SizedBox(height: 2.h),
                AdaptiveMarqueeText(
                  text: action.subtitle,
                  style: subtitleStyle,
                  velocity: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactListBody extends StatelessWidget {
  const _ContactListBody({
    required this.controller,
    required this.showRecent,
  });

  final NewChatController controller;
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
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 36.w, 24.h),
            children: [
              if (showRecent && controller.recentContacts.isNotEmpty) ...[
                const _SectionLabel(title: 'RECENT'),
                ...controller.recentContacts.map(
                  (contact) => _ContactTile(
                    contact: contact,
                    onChat: () => controller.startChat(contact),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
              const _SectionLabel(title: 'ALL CONTACTS'),
              for (final letter in sections) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
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
                  (contact) => _ContactTile(
                    contact: contact,
                    onChat: () => controller.startChat(contact),
                  ),
                ),
              ],
            ],
          ),
          if (showRecent)
            Positioned(
              right: 6.w,
              top: 20.h,
              bottom: 20.h,
              child: IgnorePointer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                      .split('')
                      .map(
                        (letter) => Text(
                          letter,
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: grouped.containsKey(letter)
                                ? AppColors.primary
                                : AppColors.hint,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: AppColors.black.withValues(alpha: 0.8),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
    required this.onChat,
  });

  final NewChatContact contact;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onChat,
              borderRadius: BorderRadius.circular(12.r),
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
                ],
              ),
            ),
          ),
          _RoundAction(
            icon: Icons.chat_bubble_outline_rounded,
            onTap: onChat,
          ),
        ],
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

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_search_rounded, size: 42.sp, color: AppColors.icon),
              SizedBox(height: 12.h),
              Text(
                'No contacts for “$query”',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Try a different name or add a new contact',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
