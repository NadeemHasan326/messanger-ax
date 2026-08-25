import 'package:messanger_ax/exports.dart';

class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationBadge,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int? notificationBadge;

  static const _items = [
    _NavSpec(
      label: 'Chats',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
    _NavSpec(
      label: 'Search',
      icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded,
    ),
    _NavSpec(
      label: 'Calls',
      icon: Icons.call_outlined,
      activeIcon: Icons.call_rounded,
    ),
    _NavSpec(
      label: 'Alerts',
      icon: Icons.notifications_none_rounded,
      activeIcon: Icons.notifications_rounded,
    ),
    _NavSpec(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.10),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < _items.length; i++)
            _FloatingNavItem(
              spec: _items[i],
              selected: currentIndex == i,
              badge: i == 3 ? notificationBadge : null,
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.spec,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final _NavSpec spec;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  static const _animationDuration = Duration(milliseconds: 250);
  static const _animationCurve = Curves.easeInOutCubic;
  static const _iconSlotSize = 44.0;
  static const _activeIconSlotSize = 28.0;
  static const _labelSlotWidth = 50.0;
  static const _iconTextGap = 2.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        height: _iconSlotSize.h,
        padding: EdgeInsets.symmetric(horizontal: selected ? 8.w : 0),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.logoBg
              : AppColors.surface.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: _animationDuration,
              curve: _animationCurve,
              width: selected ? _activeIconSlotSize.w : _iconSlotSize.w,
              height: _iconSlotSize.h,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: _animationDuration,
                    switchInCurve: _animationCurve,
                    switchOutCurve: _animationCurve,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Icon(
                      selected ? spec.activeIcon : spec.icon,
                      key: ValueKey<bool>(selected),
                      size: 22.sp,
                      color: selected ? AppColors.primary : AppColors.icon,
                    ),
                  ),
                  if (badge != null && badge! > 0)
                    Positioned(
                      right: 6.w,
                      top: 8.h,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.centerLeft,
                duration: _animationDuration,
                curve: _animationCurve,
                widthFactor: selected ? 1 : 0,
                child: SizedBox(
                  width: _labelSlotWidth.w,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _iconTextGap.w,
                      right: 2.w,
                    ),
                    child: Text(
                      spec.label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
