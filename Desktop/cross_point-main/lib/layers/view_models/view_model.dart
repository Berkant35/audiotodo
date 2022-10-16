import 'package:cross_point/layers/network/network_manager.dart';
import 'package:cross_point/layers/repository/repository_base.dart';
import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/layers/view_models/login_state_manager.dart';
import 'package:cross_point/utilities/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/navigation/navigation_constants.dart';
import '../models/items.dart';
import '../models/location_model.dart';

class ViewModel extends StateNotifier<void> {
  ViewModel() : super({});
  final repository = Repository();

  Future<void> login(String email, String password, WidgetRef ref) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);
      var result = await repository.login(email, password);

      if (result != null) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.basePage);
      }
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return;
    } finally {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<bool> checkToken() async {
    try {
      var result = await repository.getToken();

      if (result != null && result != "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return false;
    }
  }

  Future<Locations?> getLocations() async {
    try {
      var result = await repository.getLocations();

      if (result == null) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.loginPage);
        return null;
      } else {
        return result;
      }
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return null;
    }
  }

  Future<Items?> getItems(String locationID, WidgetRef ref) async {
    try {
      var result = await repository.getItems(locationID);

      if (result == null) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.loginPage);
        return null;
      } else {
        for (var item in result.data!) {
          if(item.status == "1"){
            ref.read(inventoryTagsProvider.notifier).addWaitingTag(item.epc!);
          }
        }

        return result;
      }
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      var result = await repository.saveToken("");

      if (result) {
        NavigationService.instance
            .navigateToPage(path: NavigationConstants.loginPage);
      }
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return;
    }
  }
}
