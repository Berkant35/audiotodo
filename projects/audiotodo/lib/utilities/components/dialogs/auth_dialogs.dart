import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/core/navigation/navigation_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../main.dart';

class AuthDialogs {
  static createUserActionSuccess(WidgetRef ref) => AwesomeDialog(
        context: ref.context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: S.current.create_user_success_dialog_title,
        desc: S.current.welcome_please_enter_with_login,
        btnOkOnPress: () => NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.authLoginPage),
      ).show();

  static createUserActionFailed(WidgetRef ref,String errorMessage,
      {String? title}) => AwesomeDialog(
        context: ref.context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: title ?? S.current.user_creation_failed,
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
}
