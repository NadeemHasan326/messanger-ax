import 'package:messanger_ax/exports.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  /// Bumped whenever a tab becomes active so entrance animations replay.
  final entranceTokens = List<int>.filled(5, 0).obs;

  int entranceOf(int tabIndex) => entranceTokens[tabIndex];

  void changeTab(int index) {
    if (index < 0 || index >= entranceTokens.length) return;
    if (currentIndex.value != index) {
      currentIndex.value = index;
      entranceTokens[index]++;
      entranceTokens.refresh();
    }
  }
}
