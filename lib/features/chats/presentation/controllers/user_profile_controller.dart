import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_user_profiles.dart';

class UserProfileController extends GetxController {
  UserProfileController({this.userName});

  final String? userName;

  late final UserProfile profile;
  final isFollowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    profile = MockUserProfiles.byName(userName ?? '');
  }

  void toggleFollow() {
    isFollowing.toggle();
    AppToast.info(
      isFollowing.value
          ? 'Following ${profile.name}'
          : 'Unfollowed ${profile.name}',
      position: AppToastPosition.top,
    );
  }

  void messageUser() {
    ChatNavigation.open(
      name: profile.name,
      online: profile.online,
    );
  }

  void onMoreAction(String action) {
    AppNavigation.back();
    AppToast.info(action, position: AppToastPosition.top);
  }
}
