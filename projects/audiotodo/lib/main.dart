import 'package:audiotodo/core/theme/theme.dart';
import 'package:audiotodo/ui/authentication/auth_login.dart';
import 'package:audiotodo/ui/landing/landing_page.dart';
import 'package:audiotodo/ui/sandbox_page.dart';
import 'package:audiotodo/utilities/constants/app/application_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/navigation/navigation_route.dart';
import 'core/navigation/navigation_service.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: AudioToDo()));

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

class AudioToDo extends StatelessWidget {
  const AudioToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: ApplicationConstants.appTitle,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: CustomTheme.themeData,

        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      );
    });
  }
}
