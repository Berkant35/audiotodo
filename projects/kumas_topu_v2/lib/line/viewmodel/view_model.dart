import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/models/create_result_epc.dart';
import 'package:kumas_topu/models/encode_standarts.dart';
import 'package:kumas_topu/models/inventory_list.dart';
import 'package:kumas_topu/models/read_epc.dart';
import 'package:kumas_topu/models/serial_number.dart';

import '../../utilities/constants/app/enums.dart';
import '../../utilities/init/navigation/navigation_constants.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../global_providers.dart';
import '../repository/repository/repository_base.dart';

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
            .navigateToPageClear(path: NavigationConstants.mainPage);
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

  Future<EncodeStandarts?> getEncodeStandarts(WidgetRef ref) async {
    try {
      var result = await repository.getEncodeStandarts();
      if (result == null) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.loginPage);
        return null;
      } else {
        if (result.data!.length == 1) {
          var perStandart = PerStandart();
          perStandart.id = result.data!.first.id;
          perStandart.encodeName = result.data!.first.encodeName;
          ref
              .read(currentBarcodeStandartProvider.notifier)
              .changeState(perStandart);
        }
        return result;
      }
    } catch (e) {
      return null;
    } finally {}
  }

  Future<CreateResultEPC?> createEPCForMatch(WidgetRef ref) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);
      var result = await repository.createEPCForMatch(ref);
      return result;
    } catch (e) {
      return null;
    } finally {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<SerialNumber?> getSerialNumber(WidgetRef ref) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);
      var result = await repository.getSerialNumber(ref);
      return result;
    } catch (e) {
      return null;
    } finally {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<bool> addInventory(WidgetRef ref, String title,bool isShipment) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);
      var result = await repository.addInventory(title,isShipment);
      return result;
    } catch (e) {
      return false;
    } finally {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<InventoryList?> getInventoryList(bool isShipment) async {
    try {
      return await repository.getInventoryList(isShipment);
    } catch (e) {
      return null;
    }
  }

  Future<void> sendTags(WidgetRef ref, bool saveAndClose,bool isShipment) async {
    try {
      List<dynamic> tagList = [];

      var readList =
          ref.watch(currentInventoryProvider)!.readEpcList!;

      for (var readEpc in readList) {
        tagList.add(readEpc
            .toJson());
      }

      return await repository.sendTags(
          ref.read(currentInventoryProvider)!.inventory!,
          tagList,
          saveAndClose,isShipment);
    } catch (e) {
      return;
    }
  }

  changeToLoadingState(WidgetRef ref) {
    ref.read(stateManagerProvider.notifier).changeState(LoadingStates.loading);
  }

  changeLoadedToState(WidgetRef ref) =>
      ref.read(stateManagerProvider.notifier).changeState(LoadingStates.loaded);

/*final repository = Repository();

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

  Future<ResultInventory?> getResultOfInventories(String locationID) async {
    try {
      return await repository.getResultOfInventories(locationID);
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");
      return null;
    }
  }

  Future<void> matchEpcAndBarcodeNumber(
      BarcodeInfo barcodeInfo, WidgetRef ref,String locationID) async {
    try {
      debugPrint("View Model ${barcodeInfo.toString()}");
      await repository.matchEpcAndBarcodeNumber(
          barcodeInfo, locationID);
    } catch (e) {
      debugPrint("View Model Err: $e");
      //await repository.saveToken("");

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
        Dialogs.showFailed("Failed");
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

  Future<InventoryDetailModel?> getInventoryDetail(String inventoryID) async {
    try {
      var result = await repository.getInventoryDetail(inventoryID);

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
          if (item.status == "1") {
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

  Future<void> createInventory(WidgetRef ref, String locationID) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);
      var tagList = <TagList>[];

      ref.read(inventoryTagsProvider.notifier).expectedEpcList.forEach((epc) {
        tagList.add(TagList(
            epc: epc,
            readDate: ref.read(inventoryTagsProvider.notifier).readTime[epc]));
      });

      var newInventory =
          CreateInventory(location: locationID, tagList: tagList);

      return await repository.createdInventory(newInventory, ref);
    } catch (e) {
      debugPrint("$e ");
      return;
    } finally {}
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
  }*/
}
