import 'package:marquee/marquee.dart';
import 'package:messanger_ax/exports.dart';

/// Shows static text when it fits; otherwise scrolls horizontally with [Marquee].
class AdaptiveMarqueeText extends StatelessWidget {
  const AdaptiveMarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.velocity = 28,
    this.blankSpace = 24,
    this.pauseAfterRound = const Duration(seconds: 2),
  });

  final String text;
  final TextStyle style;
  final double velocity;
  final double blankSpace;
  final Duration pauseAfterRound;

  bool _overflows(TextPainter painter, double maxWidth) {
    return painter.width > maxWidth + 0.5;
  }

  double get _lineHeight {
    final fontSize = style.fontSize ?? 14;
    return fontSize * (style.height ?? 1.25);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (!maxWidth.isFinite || maxWidth <= 0) {
          return Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        }

        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: double.infinity);

        if (!_overflows(painter, maxWidth)) {
          return Text(
            text,
            maxLines: 1,
            style: style,
          );
        }

        return SizedBox(
          height: _lineHeight,
          child: Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: blankSpace,
            velocity: velocity,
            pauseAfterRound: pauseAfterRound,
            startPadding: 0,
            accelerationDuration: const Duration(milliseconds: 600),
            accelerationCurve: Curves.ease,
            decelerationDuration: const Duration(milliseconds: 600),
            decelerationCurve: Curves.easeOut,
          ),
        );
      },
    );
  }
}
