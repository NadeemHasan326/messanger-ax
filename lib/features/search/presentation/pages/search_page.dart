import 'package:messanger_ax/exports.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LandingFadeIn(
            tabIndex: 1,
            delayMs: 80,
            direction: SlideDirection.fromTopRight,
            child: LandingHeader(
              title: 'Search',
              subtitle: 'Find chats, people & calls',
            ),
          ),
          LandingFadeIn(
            tabIndex: 1,
            delayMs: 180,
            direction: SlideDirection.fromBottomLeft,
            child: LandingSearchBar(
              hint: 'Search chats, contacts...',
              showFilter: false,
              showMic: true,
              onMicTap: () => AppToast.info('Voice search coming soon'),
              autofocus: false,
              controller: controller.textController,
              onChanged: controller.onQueryChanged,
            ),
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: LandingFadeIn(
              tabIndex: 1,
              delayMs: 280,
              direction: SlideDirection.fromBottomRight,
              child: Obx(() {
              final q = controller.query.value;
              if (q.isEmpty) {
                return _RecentSearches(
                  recent: controller.recent.toList(),
                  onTap: controller.applyRecent,
                  onClear: controller.clearHistory,
                );
              }

              final results = controller.results;
              if (results.isEmpty) {
                return _EmptyState(query: q);
              }

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                itemCount: results.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final item = results[index];
                  return _SearchResultTile(item: item);
                },
              );
            }),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.recent,
    required this.onTap,
    required this.onClear,
  });

  final List<String> recent;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'RECENT',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.muted,
                ),
              ),
            ),
            if (recent.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Clear',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        if (recent.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Text(
              'No recent searches',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.muted,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: recent
                .map(
                  (term) => GestureDetector(
                    onTap: () => onTap(term),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 16.sp,
                            color: AppColors.icon,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            term,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 42.sp,
              color: AppColors.icon,
            ),
            SizedBox(height: 12.h),
            Text(
              'No results for “$query”',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Try a different name or keyword',
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
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.item});

  final SearchResultItem item;

  IconData get _icon => switch (item.type) {
        SearchResultType.chat => Icons.chat_bubble_outline_rounded,
        SearchResultType.contact => Icons.person_outline_rounded,
        SearchResultType.call => Icons.call_outlined,
      };

  String get _typeLabel => switch (item.type) {
        SearchResultType.chat => 'Chat',
        SearchResultType.contact => 'Contact',
        SearchResultType.call => 'Call',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          UserAvatar(name: item.title),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            children: [
              Icon(_icon, size: 18.sp, color: AppColors.primary),
              SizedBox(height: 2.h),
              Text(
                _typeLabel,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
