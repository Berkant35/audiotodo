import 'package:audiotodo/utilities/components/dialogs/auth_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class FirebaseExceptions {
  static handleFirebaseException(String errorMessage, WidgetRef ref,{String? title}) {
    if (errorMessage.contains("email-already-in-use")) {
      AuthDialogs.createUserActionFailed(ref, S.current.email_already_in_use);
    } else if (errorMessage.contains("invalid-email")) {
      AuthDialogs.createUserActionFailed(ref, S.current.invalid_email_format);
    } else if (errorMessage.contains("weak-password")) {
      AuthDialogs.createUserActionFailed(
          ref, S.current.please_enter_a_strong_password);
    }else if(errorMessage.contains("The password is invalid")){
      AuthDialogs.createUserActionFailed(ref, S.current.wrong_password);
    } else {
      AuthDialogs.createUserActionFailed(ref, S.current.an_error_occurred);
    }
  }
}
