import 'package:cross_point/main.dart';
import 'package:cross_point/ui/auth/login_page.dart';
import 'package:cross_point/ui/base/inventory_list_of_location_page.dart';
import 'package:cross_point/ui/base/inventory_of_items.dart';
import 'package:cross_point/ui/base/location_search.dart';
import 'package:cross_point/ui/base/new_inventory.dart';
import 'package:flutter/material.dart';

import '../../ui/base/base.dart';
import 'navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  //BeMemberOfTakev
  Route<dynamic> generateRoute(RouteSettings args) {
    ("Generate Route args:->  ${args.arguments}");
    ("Generate Route  ${args.arguments}");

    switch (args.name) {
      case NavigationConstants.newInventoryPage:
        return normalNavigate(const NewInventory());
      case NavigationConstants.loginPage:
        return normalNavigate(const LoginPage());
      case NavigationConstants.basePage:
        return normalNavigate(const BasePage());
      case NavigationConstants.locationSearchPage:
        return normalNavigate(const LocationSearch());
      case NavigationConstants.inventoryListOfLocationPage:
        Map<String, String?> locationMap =
        args.arguments as Map<String, String?>;

        return normalNavigate(InventoryListOfLocationPage(
            locationName: locationMap['locationName']!,
            locationID: locationMap["locationID"]!));

      case NavigationConstants.inventoryOfItems:
        Map<String, String?> locationMap =
            args.arguments as Map<String, String?>;

        return normalNavigate(InventoryOfItems(
            locationName: locationMap['locationName']!,
            locationID: locationMap["locationID"]!));
      default:
        return MaterialPageRoute(
          builder: (context) => const CrossPoint(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
