import 'package:messanger_ax/exports.dart';

/// Animated sun / moon switch for light and dark mode.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  static const _duration = Duration(milliseconds: 420);
  static const _curve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = ThemeController.to.isDark.value;

      return GestureDetector(
        onTap: ThemeController.to.toggle,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          width: 48.w,
          height: 26.h,
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF1B2A4A), Color(0xFF0D1B3E)]
                  : const [Color(0xFF7DD3FC), Color(0xFF38BDF8)],
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.primary : const Color(0xFF38BDF8))
                    .withValues(alpha: 0.28),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: AnimatedOpacity(
                    duration: _duration,
                    opacity: isDark ? 0 : 1,
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 10.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: AnimatedOpacity(
                    duration: _duration,
                    opacity: isDark ? 1 : 0,
                    child: Icon(
                      Icons.star_rounded,
                      size: 8.sp,
                      color: const Color(0xFFFDE68A),
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: _duration,
                curve: _curve,
                alignment:
                    isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 21.w,
                  height: 21.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFFFFBEB),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 4.r,
                        offset: Offset(0, 1.h),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutBack,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.wb_sunny_rounded,
                      key: ValueKey(isDark),
                      size: 12.sp,
                      color: isDark
                          ? const Color(0xFF1E3A5F)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
