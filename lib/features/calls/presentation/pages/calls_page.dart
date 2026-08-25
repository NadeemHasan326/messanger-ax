import 'package:messanger_ax/exports.dart';

class CallsPage extends GetView<CallsController> {
  const CallsPage({super.key});

  void _openFilterSheet() {
    Get.bottomSheet(
      const _CallsFilterSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LandingFadeIn(
                tabIndex: 2,
                delayMs: 80,
                direction: SlideDirection.fromLeft,
                child: LandingHeader(
                  title: 'Calls',
                  subtitle: 'Stay in touch',
                  action: Obx(() {
                    final active =
                        controller.dateFilter.value != CallDateFilter.all;
                    return GestureDetector(
                      onTap: _openFilterSheet,
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: active
                                ? AppColors.primary
                                : AppColors.divider,
                            width: 1.2.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              size: 18.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Filter',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              LandingFadeIn(
                tabIndex: 2,
                delayMs: 180,
                direction: SlideDirection.fromTop,
                child: LandingSearchBar(
                  hint: 'Search calls...',
                  showFilter: false,
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                ),
              ),
              SizedBox(height: 16.h),
              LandingFadeIn(
                tabIndex: 2,
                delayMs: 280,
                direction: SlideDirection.fromRight,
                child: Obx(
                  () => FilterChipBar(
                    items: controller.tabs,
                    selectedIndex: controller.selectedTab.value,
                    onSelected: controller.selectTab,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: LandingFadeIn(
                  tabIndex: 2,
                  delayMs: 380,
                  direction: SlideDirection.fromBottomLeft,
                  child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softShadow,
                        blurRadius: 16.r,
                        offset: Offset(0, -4.h),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final items = controller.filtered;
                    if (items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_disabled_outlined,
                                size: 40.sp,
                                color: AppColors.icon,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No calls found',
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Try another filter or search term',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 100.h),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.divider,
                      ),
                      itemBuilder: (context, index) {
                        return _CallTile(call: items[index]);
                      },
                    );
                  }),
                ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20.w,
            bottom: 35.h,
            child: GestureDetector(
              onTap: () => AppNavigation.push(AppRoutes.newCall),
              child: Container(
                width: 53.w,
                height: 53.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primarySoft, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.buttonShadow,
                      blurRadius: 14.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_ic_call_rounded,
                  color: AppColors.white,
                  size: 26.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallsFilterSheet extends StatefulWidget {
  const _CallsFilterSheet();

  @override
  State<_CallsFilterSheet> createState() => _CallsFilterSheetState();
}

class _CallsFilterSheetState extends State<_CallsFilterSheet> {
  static const _options = <(CallDateFilter, String, String, IconData)>[
    (
      CallDateFilter.all,
      'All Calls',
      'Show all calls',
      Icons.phone_in_talk_outlined,
    ),
    (
      CallDateFilter.today,
      'Today',
      'Calls from today',
      Icons.today_rounded,
    ),
    (
      CallDateFilter.yesterday,
      'Yesterday',
      'Calls from yesterday',
      Icons.history_rounded,
    ),
    (
      CallDateFilter.thisWeek,
      'This Week',
      'Calls from this week',
      Icons.date_range_rounded,
    ),
  ];

  late CallDateFilter _draft;

  CallsController get _controller => Get.find<CallsController>();

  @override
  void initState() {
    super.initState();
    _draft = _controller.dateFilter.value;
  }

  void _apply() {
    _controller.setDateFilter(_draft);
    Get.back();
  }

  void _clear() {
    setState(() => _draft = CallDateFilter.all);
    _controller.clearDateFilter();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Calls',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            ..._options.map((option) {
              final (filter, title, subtitle, icon) = option;
              final selected = _draft == filter;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () => setState(() => _draft = filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.06)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.divider,
                        width: 1.2.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : AppColors.chipBg,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            icon,
                            size: 20.sp,
                            color: selected
                                ? AppColors.primary
                                : AppColors.icon,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                subtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.primary
                                : AppColors.surface,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.checkboxBorder,
                              width: 1.6.w,
                            ),
                          ),
                          child: selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 14.sp,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Apply Filter',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: _clear,
              child: Text(
                'Clear Filter',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  const _CallTile({required this.call});

  final CallItem call;

  @override
  Widget build(BuildContext context) {
    final missed = call.type == CallType.missed;
    final label = switch (call.type) {
      CallType.incoming => 'Incoming',
      CallType.outgoing => 'Outgoing',
      CallType.missed => 'Missed',
    };
    final arrow = switch (call.type) {
      CallType.incoming => Icons.call_received_rounded,
      CallType.outgoing => Icons.call_made_rounded,
      CallType.missed => Icons.call_missed_rounded,
    };
    final accent = missed ? AppColors.error : AppColors.success;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          UserAvatar(name: call.name, size: 48),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  call.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: missed ? AppColors.error : AppColors.navy,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(arrow, size: 11.sp, color: accent),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        '$label · ${call.time}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _RoundAction(
            icon: Icons.call_rounded,
            color: AppColors.primary,
            background: AppColors.logoBg,
            onTap: () => CallNavigation.start(name: call.name),
          ),
          SizedBox(width: 8.w),
          _RoundAction(
            icon: Icons.info_outline_rounded,
            color: AppColors.icon,
            background: AppColors.chipBg,
            onTap: () => AppToast.info('Call details coming soon'),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Icon(icon, size: 18.sp, color: color),
      ),
    );
  }
}
