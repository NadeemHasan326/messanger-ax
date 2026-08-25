import 'package:messanger_ax/exports.dart';

class FilterChipBar extends StatefulWidget {
  const FilterChipBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.padding,
  });

  final List<FilterChipData> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry? padding;

  @override
  State<FilterChipBar> createState() => _FilterChipBarState();
}

class _FilterChipBarState extends State<FilterChipBar> {
  final _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant FilterChipBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    }
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ensureChipVisible(widget.selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _ensureChipVisible(int index) async {
    if (index < 0 || index >= _itemKeys.length) return;
    final ctx = _itemKeys[index].currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      duration: AppFilterChip.animDuration,
      curve: AppFilterChip.animCurve,
      alignment: 0.5,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
  }

  void _onTap(int index) {
    widget.onSelected(index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureChipVisible(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: widget.items.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          return KeyedSubtree(
            key: _itemKeys[index],
            child: AppFilterChip(
              data: widget.items[index],
              selected: index == widget.selectedIndex,
              onTap: () => _onTap(index),
            ),
          );
        },
      ),
    );
  }
}
