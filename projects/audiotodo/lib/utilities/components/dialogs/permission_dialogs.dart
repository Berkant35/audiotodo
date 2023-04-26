import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';

class PermissionDialogs {
  static mustGoToSettings(WidgetRef ref) => AwesomeDialog(
        context: ref.context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'İzinleriniz eksik!',
        desc:
            'Uygulamanın tüm özelliklerini kullanmak için tüm izinlerin açık olması gerekiyor.',
        btnOkOnPress: () {
          openAppSettings();
        },
        btnCancelOnPress: () => logger.e("Denied Permission!"),
      ).show();
}
