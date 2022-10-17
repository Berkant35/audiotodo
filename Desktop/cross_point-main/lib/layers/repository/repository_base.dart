import 'package:cross_point/layers/models/login_success.dart';
import 'package:cross_point/utilities/navigation/navigation_constants.dart';
import 'package:cross_point/utilities/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/local_base.dart';
import '../local/local_manager.dart';
import '../models/created_inventory.dart';
import '../models/items.dart';
import '../models/location_model.dart';
import '../network/network_manager.dart';
import 'locator.dart';

class Repository extends LocaleBase {
  final localService = locator<LocaleService>();
  final networkManager = NetworkManager.instance;

  @override
  Future<String?> getToken() async {
    return await localService.getToken();
  }

  @override
  Future<bool> saveToken(String token) async {
    var result = await localService.saveToken(token);
    return result;
  }

  Future<LoginSuccess?> login(String email, String password) async {
    try {
      var result = await networkManager!.login(email, password);
      if (result != null) {
        var isSaved = await saveToken(result.accessToken!);
        if (isSaved) {
          return result;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<Locations?> getLocations() async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          var locations = await networkManager!.getLocations(token);
          if (locations == null) {
            NavigationService.instance
                .navigateToPage(path: NavigationConstants.loginPage);
            localService.saveToken("").then((value) {
              return null;
            });
          } else {
            return locations;
          }
        } else {
          NavigationService.instance
              .navigateToPage(path: NavigationConstants.loginPage);
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<Items?> getItems(String locationID) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          var items = await networkManager!.getItems(token,locationID);
          if (items == null) {
            NavigationService.instance
                .navigateToPage(path: NavigationConstants.loginPage);
            localService.saveToken("").then((value) {
              return null;
            });
          } else {
            return items;
          }
        } else {
          NavigationService.instance
              .navigateToPage(path: NavigationConstants.loginPage);
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
  Future<void> createdInventory(CreateInventory inventory,WidgetRef ref) async {
    try {
      return await getToken().then((value) async {
        inventory.token = value;
        return await networkManager!
            .createInventory(value!, inventory,ref)
            .then((value) {
          return value;
        });
      });
    } catch (e) {
      (e.toString());
      return;
    }
  }
}
