import 'package:flutter/material.dart';
import 'package:kumas_topu/ui/auth/login_page.dart';
import 'package:kumas_topu/ui/encode/match_with_rfid.dart';
import 'package:kumas_topu/ui/main_page.dart';
import 'package:kumas_topu/ui/encode/encode_main.dart';
import 'package:kumas_topu/ui/settings/settings_page.dart';

import '../../../ui/inventory/inventory_main.dart';
import 'navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.mainPage:
        return normalNavigate(const MainPage());
      case NavigationConstants.loginPage:
        return normalNavigate(const LoginPage());
      case NavigationConstants.settingsPage:
        return normalNavigate(const SettingsPage());
      case NavigationConstants.encodeMainPage:
        return normalNavigate(const EncodeMain());
      case NavigationConstants.matchWithRFIDPage:
        return normalNavigate(const MatchWithRFID());
      case NavigationConstants.inventoryMainPage:
        return normalNavigate(const InventoryMain());

      default:
        return MaterialPageRoute(
          builder: (context) => const MainPage(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
