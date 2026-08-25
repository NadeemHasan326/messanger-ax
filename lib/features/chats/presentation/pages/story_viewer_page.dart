import 'package:messanger_ax/exports.dart';

class StoryViewerPage extends GetView<StoryViewerController> {
  const StoryViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        final pack = controller.currentPack;
        final story = controller.currentStory;
        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: story.colors,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
                    child: _ProgressRow(
                      count: controller.storyCount,
                      currentIndex: controller.storyIndex.value,
                      progress: controller.progress.value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 0),
                    child: _StoryHeader(
                      name: pack.name,
                      timeAgo: story.timeAgo,
                      online: pack.online,
                      onClose: controller.close,
                      onOpenProfile: controller.openUserProfile,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onTapDown: (details) => controller.tapAt(
                            details.localPosition.dx,
                            constraints.maxWidth,
                          ),
                          onLongPressStart: (_) => controller.pause(),
                          onLongPressEnd: (_) => controller.resume(),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.w),
                            child: Center(
                              child: Text(
                                story.caption,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const _StoryReplyBar(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.count,
    required this.currentIndex,
    required this.progress,
  });

  final int count;
  final int currentIndex;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final value = index < currentIndex
            ? 1.0
            : index == currentIndex
                ? progress.clamp(0.0, 1.0)
                : 0.0;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 3.h,
                backgroundColor: AppColors.white.withValues(alpha: 0.28),
                color: AppColors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({
    required this.name,
    required this.timeAgo,
    required this.online,
    required this.onClose,
    required this.onOpenProfile,
  });

  final String name;
  final String timeAgo;
  final bool online;
  final VoidCallback onClose;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onOpenProfile,
          child: UserAvatar(
            name: name,
            size: 44,
            showOnline: online,
            onlineIndicatorSize: 10,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: GestureDetector(
            onTap: onOpenProfile,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  timeAgo,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: AppColors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: Icon(Icons.close_rounded, color: AppColors.white, size: 24.sp),
        ),
      ],
    );
  }
}

class _StoryReplyBar extends GetView<StoryViewerController> {
  const _StoryReplyBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  controller.pause();
                } else {
                  controller.resume();
                }
              },
              child: TextField(
                controller: controller.replyController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendReply(),
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                  filled: true,
                  fillColor: AppColors.white.withValues(alpha: 0.14),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.r),
                    borderSide: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.r),
                    borderSide: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.r),
                    borderSide: const BorderSide(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          const _FavoriteButton(),
          SizedBox(width: 6.w),
          _RoundAction(
            icon: Icons.send_rounded,
            onTap: controller.sendReply,
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton();

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.45).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.45, end: 0.85).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
        weight: 40,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward(from: 0);
    Get.find<StoryViewerController>().likeStory();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryViewerController>();
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Obx(() {
          final liked = controller.isCurrentLiked;
          return Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.14),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.28),
              ),
            ),
            child: Icon(
              liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: liked ? AppColors.error : AppColors.white,
              size: 20.sp,
            ),
          );
        }),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.14),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.28)),
        ),
        child: Icon(icon, color: AppColors.white, size: 20.sp),
      ),
    );
  }
}
