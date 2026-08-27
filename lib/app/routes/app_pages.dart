import 'package:messanger_ax/exports.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.signIn;

  static final List<GetPage<dynamic>> routes = [
    _page(
      name: AppRoutes.signIn,
      page: SignInPage.new,
      binding: SignInBinding(),
    ),
    _page(
      name: AppRoutes.forgotPassword,
      page: ForgotPasswordPage.new,
      binding: ForgotPasswordBinding(),
    ),
    _page(
      name: AppRoutes.createAccount,
      page: CreateAccountPage.new,
      binding: CreateAccountBinding(),
    ),
    _page(
      name: AppRoutes.verifyEmail,
      page: OtpVerificationPage.new,
      binding: OtpVerificationBinding(),
    ),
    _page(
      name: AppRoutes.home,
      page: MainShellPage.new,
      binding: MainBinding(),
    ),
    _page(
      name: AppRoutes.contactDetail,
      page: ContactDetailPage.new,
    ),
    _page(
      name: AppRoutes.newChat,
      page: NewChatPage.new,
      binding: NewChatBinding(),
    ),
    _page(
      name: AppRoutes.addContact,
      page: AddContactPage.new,
      binding: AddContactBinding(),
    ),
    _page(
      name: AppRoutes.createGroup,
      page: CreateGroupPage.new,
      binding: CreateGroupBinding(),
    ),
    _page(
      name: AppRoutes.createChannel,
      page: CreateChannelPage.new,
      binding: CreateChannelBinding(),
    ),
    _page(
      name: AppRoutes.channels,
      page: ChannelsPage.new,
      binding: ChannelsBinding(),
    ),
    _page(
      name: AppRoutes.addStory,
      page: AddStoryPage.new,
      binding: AddStoryBinding(),
    ),
    _page(
      name: AppRoutes.storyViewer,
      page: StoryViewerPage.new,
      binding: StoryViewerBinding(),
      transition: Transition.fadeIn,
    ),
    _page(
      name: AppRoutes.userProfile,
      page: UserProfilePage.new,
      binding: UserProfileBinding(),
    ),
    _page(
      name: AppRoutes.channelInfo,
      page: ChannelInfoPage.new,
      binding: ChannelInfoBinding(),
    ),
    _page(
      name: AppRoutes.chat,
      page: ChatPage.new,
      binding: ChatBinding(),
    ),
    _page(
      name: AppRoutes.newCall,
      page: NewCallPage.new,
      binding: NewCallBinding(),
    ),
    _page(
      name: AppRoutes.inCall,
      page: InCallPage.new,
      binding: InCallBinding(),
      transition: Transition.fadeIn,
    ),
    _page(
      name: AppRoutes.account,
      page: AccountPage.new,
      binding: AccountBinding(),
    ),
    _page(
      name: AppRoutes.privacySecurity,
      page: PrivacySecurityPage.new,
      binding: PrivacySecurityBinding(),
    ),
    _page(
      name: AppRoutes.inviteFriends,
      page: InviteFriendsPage.new,
      binding: InviteFriendsBinding(),
    ),
  ];

  static GetPage<void> _page({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    Transition? transition,
  }) {
    return GetPage<void>(
      name: name,
      page: () => Obx(() {
        ThemeController.to.isDark.value;
        return page();
      }),
      binding: binding,
      transition: transition ?? AppNavigation.pushTransition,
      transitionDuration: AppNavigation.transitionDuration,
      showCupertinoParallax: true,
      popGesture: GetPlatform.isIOS || GetPlatform.isMacOS,
    );
  }
}
