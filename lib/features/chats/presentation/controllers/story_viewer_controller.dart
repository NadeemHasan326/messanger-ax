import 'dart:async';

import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_user_stories.dart';

class StoryViewerController extends GetxController {
  StoryViewerController({this.initialUserName});

  final String? initialUserName;

  static const storyDuration = Duration(seconds: 5);

  final packs = MockUserStories.packs;
  final userIndex = 0.obs;
  final storyIndex = 0.obs;
  final progress = 0.0.obs;
  final isPaused = false.obs;
  final replyController = TextEditingController();
  final likedKeys = <String>{}.obs;

  Timer? _ticker;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;

  UserStoryPack get currentPack => packs[userIndex.value];

  UserStoryItem get currentStory => currentPack.stories[storyIndex.value];

  int get storyCount => currentPack.stories.length;

  String get _currentStoryKey => '${userIndex.value}-${storyIndex.value}';

  bool get isCurrentLiked => likedKeys.contains(_currentStoryKey);

  @override
  void onInit() {
    super.onInit();
    final start = MockUserStories.indexOf(initialUserName ?? '');
    userIndex.value = start >= 0 ? start : 0;
    _startTimer();
  }

  void _startTimer() {
    _ticker?.cancel();
    _elapsed = Duration.zero;
    progress.value = 0;
    _startedAt = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (isPaused.value) return;
      final elapsed = DateTime.now().difference(_startedAt!) + _elapsed;
      final ratio = elapsed.inMilliseconds / storyDuration.inMilliseconds;
      if (ratio >= 1) {
        progress.value = 1;
        next();
        return;
      }
      progress.value = ratio;
    });
  }

  void pause() {
    if (isPaused.value) return;
    isPaused.value = true;
    if (_startedAt != null) {
      _elapsed += DateTime.now().difference(_startedAt!);
    }
  }

  void resume() {
    if (!isPaused.value) return;
    isPaused.value = false;
    _startedAt = DateTime.now();
  }

  void next() {
    if (storyIndex.value < storyCount - 1) {
      storyIndex.value++;
      _startTimer();
      return;
    }
    _markCurrentPackViewed();
    if (userIndex.value < packs.length - 1) {
      userIndex.value++;
      storyIndex.value = 0;
      _startTimer();
      return;
    }
    close();
  }

  void previous() {
    if (storyIndex.value > 0) {
      storyIndex.value--;
      _startTimer();
      return;
    }
    if (userIndex.value > 0) {
      userIndex.value--;
      storyIndex.value = currentPack.stories.length - 1;
      _startTimer();
      return;
    }
    _startTimer();
  }

  void tapAt(double dx, double width) {
    if (dx < width * 0.3) {
      previous();
    } else {
      next();
    }
  }

  void openUserProfile() {
    pause();
    if (Get.isRegistered<UserProfileController>()) {
      Get.delete<UserProfileController>(force: true);
    }
    AppNavigation.push(
      AppRoutes.userProfile,
      arguments: currentPack.name,
    )?.then((_) => resume());
  }

  void sendReply() {
    final text = replyController.text.trim();
    if (text.isEmpty) return;
    replyController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    resume();
    AppToast.success(
      'Reply sent to ${currentPack.name}',
      position: AppToastPosition.top,
    );
  }

  void likeStory() {
    FocusManager.instance.primaryFocus?.unfocus();
    resume();
    if (isCurrentLiked) {
      likedKeys.remove(_currentStoryKey);
    } else {
      likedKeys.add(_currentStoryKey);
      AppToast.info(
        'Liked ${currentPack.name}',
        position: AppToastPosition.top,
      );
    }
    likedKeys.refresh();
  }

  void _markCurrentPackViewed() {
    if (!Get.isRegistered<ChatsController>()) return;
    Get.find<ChatsController>().markStatusViewed(currentPack.name);
  }

  void close() {
    _markCurrentPackViewed();
    AppNavigation.back();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    replyController.dispose();
    super.onClose();
  }
}
