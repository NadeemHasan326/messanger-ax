import 'package:messanger_ax/exports.dart';

class AppToastOverlay extends StatefulWidget {
  const AppToastOverlay({
    super.key,
    required this.message,
    required this.type,
    required this.position,
    required this.onDismissed,
  });

  final String message;
  final AppToastType type;
  final AppToastPosition position;
  final VoidCallback onDismissed;

  @override
  State<AppToastOverlay> createState() => AppToastOverlayState();
}

class AppToastOverlayState extends State<AppToastOverlay>
    with SingleTickerProviderStateMixin {
  static const _showDuration = Duration(milliseconds: 380);
  static const _hideDuration = Duration(milliseconds: 280);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _showDuration,
      reverseDuration: _hideDuration,
    );
    final begin = widget.position == AppToastPosition.top
        ? const Offset(0, -1.15)
        : const Offset(0, 1.15);
    _slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_isClosing || !mounted) return;
    _isClosing = true;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  _ToastStyle get _style => switch (widget.type) {
        AppToastType.success => const _ToastStyle(
            accent: AppColors.success,
            icon: Icons.check_circle_rounded,
          ),
        AppToastType.error => const _ToastStyle(
            accent: AppColors.error,
            icon: Icons.error_outline_rounded,
          ),
        AppToastType.warning => const _ToastStyle(
            accent: AppColors.warning,
            icon: Icons.warning_amber_rounded,
          ),
        AppToastType.info => const _ToastStyle(
            accent: AppColors.primary,
            icon: Icons.info_outline_rounded,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final topAligned = widget.position == AppToastPosition.top;

    return IgnorePointer(
      ignoring: _isClosing,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Align(
            alignment: topAligned ? Alignment.topCenter : Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, topAligned ? 12.h : 0, 16.w, topAligned ? 0 : 20.h),
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: GestureDetector(
                    onTap: dismiss,
                    onVerticalDragEnd: (details) {
                      final velocity = details.primaryVelocity ?? 0;
                      if (topAligned && velocity < -120) dismiss();
                      if (!topAligned && velocity > 120) dismiss();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: style.accent.withValues(alpha: 0.18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: 0.10),
                            blurRadius: 24.r,
                            offset: Offset(0, 8.h),
                          ),
                          BoxShadow(
                            color: style.accent.withValues(alpha: 0.12),
                            blurRadius: 16.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    style.accent.withValues(alpha: 0.18),
                                    style.accent.withValues(alpha: 0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(13.r),
                              ),
                              child: Icon(
                                style.icon,
                                color: style.accent,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                widget.message,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.close_rounded,
                              size: 18.sp,
                              color: AppColors.icon,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastStyle {
  const _ToastStyle({
    required this.accent,
    required this.icon,
  });

  final Color accent;
  final IconData icon;
}
