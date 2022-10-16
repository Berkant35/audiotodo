import 'dart:io';

import 'package:cross_point/ui/landing_page.dart';
import 'package:cross_point/utilities/constants/url_constants.dart';
import 'package:cross_point/utilities/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'layers/network/network_manager.dart';
import 'layers/repository/locator.dart';
import 'utilities/navigation/navigation_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.absolute.path);

  setupLocator();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  final urlConstants = locator<UrlConstants>();

  await urlConstants.getUrl().then((value) {
    NetworkManager.instance?.init(value!, {"key": "value"});
  });

  runApp(const ProviderScope(child: CrossPoint()));
}

class CrossPoint extends ConsumerWidget {
  const CrossPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: "Cross Point",
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      );
    });
  }
}
