import 'package:messanger_ax/exports.dart';

/// Fades in while sliding from a start offset into place.
class SlideFadeIn extends StatefulWidget {
  const SlideFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.offsetX = 40,
    this.offsetY = 0,
    this.direction,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Start distance on X (used when [direction] is null).
  final double offsetX;

  /// Start distance on Y (used when [direction] is null).
  final double offsetY;

  /// Preferred way to set slide origin. Overrides [offsetX]/[offsetY].
  final SlideDirection? direction;

  static Offset offsetFor(
    SlideDirection direction, {
    double distance = 36,
  }) {
    return switch (direction) {
      SlideDirection.fromRight => Offset(distance, 0),
      SlideDirection.fromLeft => Offset(-distance, 0),
      SlideDirection.fromTop => Offset(0, -distance),
      SlideDirection.fromBottom => Offset(0, distance),
      SlideDirection.fromTopLeft => Offset(-distance, -distance),
      SlideDirection.fromTopRight => Offset(distance, -distance),
      SlideDirection.fromBottomLeft => Offset(-distance, distance),
      SlideDirection.fromBottomRight => Offset(distance, distance),
    };
  }

  @override
  State<SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<SlideFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);

    final begin = widget.direction != null
        ? SlideFadeIn.offsetFor(widget.direction!)
        : Offset(widget.offsetX, widget.offsetY);

    _slide = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(curved);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _slide.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
