import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kumas_topu/ui/auth/login_page.dart';
import 'package:kumas_topu/ui/landing_page.dart';
import 'package:kumas_topu/utilities/constants/app/url_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_route.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:kumas_topu/utilities/init/theme/custom_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'line/network/network_manager.dart';
import 'line/repository/repository/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.absolute.path);

  setupLocator();

  final urlConstants = locator<UrlConstants>();

  await urlConstants.getUrl().then((value) {
    NetworkManager.instance?.init(value!, {"key": "value"});
  });

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: KumasTopu()));
}

class KumasTopu extends StatelessWidget {
  const KumasTopu({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Kumas Topu',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        theme: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: CustomColors.customGreyColor,
                  disabledForegroundColor: CustomColors.customCardBackgroundColor,
                  backgroundColor: CustomColors.primaryColor
              ),
            ),
            primaryColor: CustomColors.primaryColor,
            secondaryHeaderColor: CustomColors.secondaryColor,
            progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: CustomColors.appBarColor),
            appBarTheme:
                const AppBarTheme(backgroundColor: CustomColors.appBarColor),
            scaffoldBackgroundColor: Colors.white),
        home: const LandingPage(),
      );
    });
  }
}
