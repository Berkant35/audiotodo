import 'package:fluttertoast/fluttertoast.dart';

import '../init/theme/custom_colors.dart';

class Dialogs {
  static void showSuccess(String title) {
    Fluttertoast.showToast(msg: title, backgroundColor: CustomColors.blueColor);
  }

  static void showFailed(String title) {
    Fluttertoast.showToast(msg: title, backgroundColor: CustomColors.errorColor);
  }
}