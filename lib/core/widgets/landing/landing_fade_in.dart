import 'package:messanger_ax/exports.dart';

/// Staggered fade/slide entrance used on landing tabs.
///
/// Rebuilds with a new [SlideFadeIn] key whenever [tabIndex] is selected so
/// content fades in instead of appearing instantly.
class LandingFadeIn extends StatelessWidget {
  const LandingFadeIn({
    super.key,
    required this.tabIndex,
    required this.delayMs,
    required this.child,
    this.direction = SlideDirection.fromRight,
    this.duration = const Duration(milliseconds: 650),
  });

  final int tabIndex;
  final int delayMs;
  final Widget child;
  final SlideDirection direction;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Obx(() {
      final token = main.entranceOf(tabIndex);
      return SlideFadeIn(
        key: ValueKey('landing-$tabIndex-$token-$delayMs-${direction.name}'),
        delay: Duration(milliseconds: delayMs),
        duration: duration,
        direction: direction,
        child: child,
      );
    });
  }
}
