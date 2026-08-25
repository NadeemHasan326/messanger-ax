import 'package:messanger_ax/exports.dart';

class InCallPage extends GetView<InCallController> {
  const InCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A1428),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B162C),
                AppColors.ink,
                Color(0xFF152A4A),
                Color(0xFF0A1428),
              ],
              stops: [0, 0.35, 0.72, 1],
            ),
          ),
          child: Stack(
            children: [
              const _AmbientGlow(
                alignment: Alignment(-0.85, -0.7),
                color: Color(0x552A6DE0),
                size: 220,
              ),
              const _AmbientGlow(
                alignment: Alignment(0.9, 0.15),
                color: Color(0x334DB6AC),
                size: 180,
              ),
              const _AmbientGlow(
                alignment: Alignment(-0.2, 0.85),
                color: Color(0x331A73E8),
                size: 260,
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: Row(
                        children: [
                          _TopIconButton(
                            icon: Icons.keyboard_arrow_down_rounded,
                            onTap: controller.hangUp,
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_rounded,
                                  size: 12.sp,
                                  color: AppColors.white.withValues(alpha: 0.85),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'End-to-end encrypted',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    _AvatarPulse(
                      name: session.name,
                      online: session.online,
                      isConnecting: controller.isConnecting,
                    ),
                    SizedBox(height: 22.h),
                    Text(
                      session.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(() {
                      final connecting = controller.isConnecting.value;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: Container(
                          key: ValueKey(connecting),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!connecting) ...[
                                Container(
                                  width: 7.w,
                                  height: 7.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                              ],
                              Text(
                                connecting
                                    ? 'Calling…'
                                    : controller.elapsedLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white.withValues(
                                    alpha: 0.88,
                                  ),
                                  letterSpacing: connecting ? 0 : 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Spacer(flex: 3),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 18.h),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 24.r,
                              offset: Offset(0, 10.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => _CircleAction(
                                icon: controller.isMuted.value
                                    ? Icons.mic_off_rounded
                                    : Icons.mic_rounded,
                                label: controller.isMuted.value
                                    ? 'Unmute'
                                    : 'Mute',
                                onTap: controller.toggleMute,
                                active: controller.isMuted.value,
                              ),
                            ),
                            _CircleAction(
                              icon: Icons.call_end_rounded,
                              label: 'End',
                              onTap: controller.hangUp,
                              background: AppColors.error,
                              iconColor: AppColors.white,
                              size: 72,
                              glow: true,
                            ),
                            Obx(
                              () => _CircleAction(
                                icon: controller.isSpeakerOn.value
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_down_rounded,
                                label: 'Speaker',
                                onTap: controller.toggleSpeaker,
                                active: controller.isSpeakerOn.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarPulse extends StatefulWidget {
  const _AvatarPulse({
    required this.name,
    required this.online,
    required this.isConnecting,
  });

  final String name;
  final bool online;
  final RxBool isConnecting;

  @override
  State<_AvatarPulse> createState() => _AvatarPulseState();
}

class _AvatarPulseState extends State<_AvatarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168.w,
      height: 168.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 2; i++)
                _PulseRing(
                  progress: (_controller.value + i * 0.5) % 1,
                ),
              child!,
            ],
          );
        },
        child: Container(
          width: 118.w,
          height: 118.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 28.r,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.18),
              width: 3.w,
            ),
          ),
          child: UserAvatar(
            name: widget.name,
            size: 112,
            showOnline: widget.online,
            onlineIndicatorSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.72 + (progress * 0.45);
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.35;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 140.w,
        height: 140.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withValues(alpha: opacity),
            width: 1.6.w,
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.14),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.white, size: 26.sp),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.label,
    this.background,
    this.iconColor,
    this.active = false,
    this.size = 58,
    this.glow = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  final Color? background;
  final Color? iconColor;
  final bool active;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final bg = background ??
        (active
            ? AppColors.white
            : AppColors.white.withValues(alpha: 0.14));
    final fg = iconColor ?? (active ? AppColors.ink : AppColors.white);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: glow
                  ? [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.45),
                        blurRadius: 18.r,
                        offset: Offset(0, 6.h),
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: fg, size: (size * 0.38).sp),
          ),
          if (label != null) ...[
            SizedBox(height: 10.h),
            Text(
              label!,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.88),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
