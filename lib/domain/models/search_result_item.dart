import 'package:messanger_ax/core/constants/app_enums.dart';

class SearchResultItem {
  const SearchResultItem({
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String title;
  final String subtitle;
  final SearchResultType type;
}
