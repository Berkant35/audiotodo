import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:kumas_topu/ui/auth/login_page.dart';
import 'package:kumas_topu/ui/encode/match_with_rfid.dart';
import 'package:kumas_topu/ui/inventory/do_inventory.dart';
import 'package:kumas_topu/ui/main_page.dart';
import 'package:kumas_topu/ui/encode/encode_main.dart';
import 'package:kumas_topu/ui/reviews/detail_of_product.dart';
import 'package:kumas_topu/ui/settings/settings_page.dart';

import '../../../ui/inventory/inventory_main.dart';
import '../../../ui/shipment/shipment_main.dart';
import 'navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.mainPage:
        return normalNavigate(const MainPage());
      case NavigationConstants.loginPage:
        return normalNavigate(const LoginPage());
      case NavigationConstants.settingsPage:
        Map<String,dynamic> map = args.arguments as Map<String,dynamic>;
        debugPrint(map['maxValue'].toString());
        return normalNavigate(SettingsPage(maxValue: map['maxValue']));
      case NavigationConstants.encodeMainPage:
        return normalNavigate(const EncodeMain());
      case NavigationConstants.matchWithRFIDPage:
        Map<String,dynamic> map = args.arguments as Map<String,dynamic>;
        return normalNavigate(MatchWithRFID(controller: map['controller']));
      case NavigationConstants.inventoryMainPage:
        return normalNavigate(const InventoryMain());
      case NavigationConstants.doInventoryPage:
        return normalNavigate(const DoInventory());
      case NavigationConstants.shipmentMainPage:
        return normalNavigate(const ShipmentMain());
      case NavigationConstants.detailOfProductPage:
        return normalNavigate(const DetailOfProduct());
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
