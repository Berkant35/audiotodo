import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:osgb/god_mode.dart';
import 'package:osgb/line/network/database/fb_db_manager.dart';
import 'package:osgb/ui/landing_page.dart';
import 'package:osgb/utilities/constants/app/application_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_route.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:osgb/utilities/init/theme/custom_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase_options.dart';
var logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  String badge = "";

  if (Platform.isIOS)
  {
    badge = message.notification!.apple!.badge!;
  }
    else
  {
    badge = message.notification!.android!.count.toString();
  }

  FlutterAppBadger.updateBadgeCount(int.parse(badge));
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.absolute.path);

  runApp(const ProviderScope(child: Osgb()));

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

class Osgb extends ConsumerWidget {
  const Osgb({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'SU OSGB',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        theme: Theme.of(context).copyWith(
            primaryColor: CustomColors.primaryColor,
            secondaryHeaderColor: CustomColors.secondaryColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: CustomColors.primaryColor
            ),
            scaffoldBackgroundColor: Colors.white
        ),
        home: const LandingPage(),
      );
    });
  }
}
