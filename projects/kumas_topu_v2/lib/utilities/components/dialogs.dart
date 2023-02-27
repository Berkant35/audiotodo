import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';

import '../init/theme/custom_colors.dart';

class Dialogs {
  static FToast? fToast;

  static void showSuccess(String title) {
    initialize();


    Fluttertoast.showToast(msg: title,backgroundColor: CustomColors.blueColor);
  }

  static void showFailed(String title) {
    initialize();

    Fluttertoast.showToast(msg: title,backgroundColor: CustomColors.errorColor);
  }

  static void initialize() {
    fToast ??= FToast();
    fToast!.init(NavigationService.instance.navigatorKey.currentState!.context);
    fToast!.removeCustomToast();
    fToast!.removeQueuedCustomToasts();
  }
}
