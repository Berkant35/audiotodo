import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../models/notification_model.dart';
import '../../../models/version.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import '../../network/database/fb_db_manager.dart';

class NotificationManager extends StateNotifier<String?> {
  NotificationManager(String? state) : super(null);
  final db = FirebaseDbManager();

  changePushToken(String token) {
    state = token;
  }

  Future<Version?> getVersionFromCloud() async {
    try {
      return await db.getVersionFromCloud();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> initializeNotificationState(WidgetRef ref,String rootUserID) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission();

    messaging.getToken().then((pushToken) async {
      debugPrint("Push Token $pushToken");

      switch(ref.read(currentRole)){

        case Roles.none:
          // TODO: Handle this case.
          break;
        case Roles.admin:
          ref.read(currentBaseModelState).admin!.pushToken = pushToken;
          break;
        case Roles.accountant:
          ref.read(currentBaseModelState).accountant!.pushToken = pushToken;

          break;
        case Roles.customer:
          ref.read(currentBaseModelState).customer!.pushToken = pushToken;
          break;
        case Roles.expert:
          ref.read(currentBaseModelState).expert!.pushToken = pushToken;

          break;
        case Roles.doctor:
          ref.read(currentBaseModelState).doctor!.pushToken = pushToken;

          break;
        case Roles.worker:

          break;
      }

      if (pushToken != null) {
        changePushToken(pushToken);
        await updatePushToken(pushToken, rootUserID);
      }
    });

    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Triggered!");
      showNotificationFromFirebase(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    messaging.getAPNSToken().then((value) {});
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showNotificationFromFirebase(RemoteMessage event) {
    var context = NavigationService.instance.navigatorKey.currentState!.context;
    return ScaffoldMessenger.of(context).showSnackBar(snackView(event));
  }

  SnackBar snackView(RemoteMessage event) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: CustomColors.orangeColor,
      margin:  EdgeInsets.only(bottom: 70.h,right: 2.w,left: 2.w),
      content: SizedBox(
        height: 8.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              event.notification!.title!,
              style: ThemeValueExtension.subtitle
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              event.notification!.body!,
              style: ThemeValueExtension.subtitle2,
            )
          ],
        ),
      ),
      duration: const Duration(milliseconds: 5000),
    );
  }

  Future<void> sendPush(NotificationModel notificationModel) async {
    try {
      await db.sendPush(notificationModel);
    } catch (e) {
      debugPrint("Err(sendPush): $e");
    }
  }

  Future<void> updatePushToken(String pushToken, String rootUserID) async {
    try {
      return await db.updatePushToken(pushToken, rootUserID);
    } catch (e) {
      debugPrint("Err(sendPush): $e");
    }
  }
}
