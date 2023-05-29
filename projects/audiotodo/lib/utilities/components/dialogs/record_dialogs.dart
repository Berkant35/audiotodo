import 'package:audiotodo/utilities/constants/exceptions/record_exceptions.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class RecordDialogs {
  static notAvailableDialog(WidgetRef ref) => AwesomeDialog(
        context: ref.context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: S.current.something_went_wrong,
        desc: S.current.please_give_feed_back,
        btnCancelOnPress: () => RecordExceptions.handleRecordException(
            "Not Available Speech To Text!", ref),
      ).show();
}
