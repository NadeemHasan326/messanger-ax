/// Central import barrel for the whole app.
///
/// Every other library should import only this file:
/// `import 'package:messanger_ax/exports.dart';`
library;

// ---------------------------------------------------------------------------
// External packages
// ---------------------------------------------------------------------------
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/gestures.dart';
export 'package:flutter/foundation.dart' show Factory;
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:get/get.dart';
export 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------
export 'app/app.dart';
export 'app/di/injection.dart';
export 'app/routes/app_pages.dart';
export 'app/routes/app_routes.dart';
export 'app/themes/app_theme.dart';

// ---------------------------------------------------------------------------
// Core
// ---------------------------------------------------------------------------
export 'core/constants/app_assets.dart';
export 'core/constants/app_constants.dart';
export 'core/constants/app_enums.dart';
export 'core/errors/exceptions.dart';
export 'core/errors/failures.dart';
export 'core/navigation/app_navigation.dart';
export 'core/network/api_client.dart';
export 'core/theme/app_colors.dart';
export 'core/theme/chat_wallpaper_style.dart';
export 'core/theme/theme_controller.dart';
export 'core/utils/app_toast.dart';
export 'core/utils/typedefs.dart';
export 'core/platform/device_emoji.dart';
export 'core/platform/screen_capture.dart';
export 'domain/models/models.dart';
export 'core/widgets/landing/app_filter_chip.dart';
export 'core/widgets/landing/filter_chip_bar.dart';
export 'core/widgets/landing/landing_fade_in.dart';
export 'core/widgets/landing/landing_header.dart';
export 'core/widgets/landing/landing_search_bar.dart';
export 'core/widgets/landing/user_avatar.dart';
export 'core/widgets/adaptive_marquee_text.dart';
export 'core/widgets/app_back_button.dart';
export 'core/widgets/app_toast_overlay.dart';
export 'core/widgets/country_picker_bottom_sheet.dart';
export 'core/widgets/loading_indicator.dart';
export 'core/widgets/notification_toggle.dart';
export 'core/widgets/premium_confirm_dialog.dart';
export 'core/widgets/slide_fade_in.dart';
export 'core/widgets/theme_toggle.dart';

// ---------------------------------------------------------------------------
// Features — auth
// ---------------------------------------------------------------------------
export 'features/auth/presentation/bindings/create_account_binding.dart';
export 'features/auth/presentation/bindings/forgot_password_binding.dart';
export 'features/auth/presentation/bindings/otp_verification_binding.dart';
export 'features/auth/presentation/bindings/sign_in_binding.dart';
export 'features/auth/presentation/controllers/create_account_controller.dart';
export 'features/auth/presentation/controllers/forgot_password_controller.dart';
export 'features/auth/presentation/controllers/otp_verification_controller.dart';
export 'features/auth/presentation/controllers/sign_in_controller.dart';
export 'features/auth/presentation/pages/create_account_page.dart';
export 'features/auth/presentation/pages/forgot_password_page.dart';
export 'features/auth/presentation/pages/otp_verification_page.dart';
export 'features/auth/presentation/pages/sign_in_page.dart';
export 'features/auth/presentation/widgets/auth_app_bar.dart';
export 'features/auth/presentation/widgets/auth_phone_field.dart';
export 'features/auth/presentation/widgets/auth_primary_button.dart';
export 'features/auth/presentation/widgets/auth_text_field.dart';
export 'features/auth/presentation/widgets/brand_logo.dart';
export 'features/auth/presentation/widgets/otp_box.dart';
export 'features/auth/presentation/widgets/profile_avatar_picker.dart';

// ---------------------------------------------------------------------------
// Features — main / landing
// ---------------------------------------------------------------------------
export 'features/main/presentation/bindings/main_binding.dart';
export 'features/main/presentation/controllers/main_controller.dart';
export 'features/main/presentation/pages/main_shell_page.dart';
export 'features/main/presentation/widgets/floating_bottom_nav.dart';

export 'features/chats/presentation/bindings/add_story_binding.dart';
export 'features/chats/presentation/bindings/chat_binding.dart';
export 'features/chats/presentation/bindings/create_group_binding.dart';
export 'features/chats/presentation/bindings/new_chat_binding.dart';
export 'features/chats/presentation/bindings/story_viewer_binding.dart';
export 'features/chats/presentation/bindings/user_profile_binding.dart';
export 'features/chats/presentation/controllers/add_story_controller.dart';
export 'features/chats/presentation/controllers/chat_controller.dart';
export 'features/chats/presentation/controllers/chats_controller.dart';
export 'features/chats/presentation/controllers/create_group_controller.dart';
export 'features/chats/presentation/controllers/new_chat_controller.dart';
export 'features/chats/presentation/controllers/story_viewer_controller.dart';
export 'features/chats/presentation/controllers/user_profile_controller.dart';
export 'features/chats/presentation/navigation/chat_navigation.dart';
export 'features/chats/presentation/pages/add_story_page.dart';
export 'features/chats/presentation/pages/chat_page.dart';
export 'features/chats/presentation/pages/chats_page.dart';
export 'features/chats/presentation/pages/create_group_page.dart';
export 'features/chats/presentation/pages/new_chat_page.dart';
export 'features/chats/presentation/pages/story_viewer_page.dart';
export 'features/chats/presentation/pages/user_profile_page.dart';

export 'features/search/presentation/controllers/search_controller.dart';
export 'features/search/presentation/pages/search_page.dart';

export 'features/contacts/presentation/bindings/add_contact_binding.dart';
export 'features/contacts/presentation/controllers/add_contact_controller.dart';
export 'features/contacts/presentation/controllers/contacts_controller.dart';
export 'features/contacts/presentation/pages/add_contact_page.dart';
export 'features/contacts/presentation/pages/contact_detail_page.dart';
export 'features/contacts/presentation/pages/contacts_page.dart';

export 'features/calls/presentation/bindings/in_call_binding.dart';
export 'features/calls/presentation/bindings/new_call_binding.dart';
export 'features/calls/presentation/controllers/calls_controller.dart';
export 'features/calls/presentation/controllers/in_call_controller.dart';
export 'features/calls/presentation/controllers/new_call_controller.dart';
export 'features/calls/presentation/navigation/call_navigation.dart';
export 'features/calls/presentation/pages/calls_page.dart';
export 'features/calls/presentation/pages/in_call_page.dart';
export 'features/calls/presentation/pages/new_call_page.dart';

export 'features/notifications/presentation/controllers/notifications_controller.dart';
export 'features/notifications/presentation/pages/notifications_page.dart';

export 'features/profile/presentation/bindings/account_binding.dart';
export 'features/profile/presentation/bindings/invite_friends_binding.dart';
export 'features/profile/presentation/bindings/privacy_security_binding.dart';
export 'features/profile/presentation/controllers/account_controller.dart';
export 'features/profile/presentation/controllers/invite_friends_controller.dart';
export 'features/profile/presentation/controllers/privacy_security_controller.dart';
export 'features/profile/presentation/controllers/profile_controller.dart';
export 'features/profile/presentation/navigation/profile_navigation.dart';
export 'features/profile/presentation/pages/account_page.dart';
export 'features/profile/presentation/pages/invite_friends_page.dart';
export 'features/profile/presentation/pages/privacy_security_page.dart';
export 'features/profile/presentation/pages/profile_page.dart';
export 'features/profile/presentation/widgets/profile_settings_header.dart';
export 'features/profile/presentation/widgets/settings_group_card.dart';
export 'features/profile/presentation/widgets/settings_list_tile.dart';
export 'features/profile/presentation/widgets/settings_option_sheet.dart';
export 'features/profile/presentation/widgets/wallpaper_gallery_sheet.dart';
