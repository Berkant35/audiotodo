import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/models/barcode_info.dart';
import 'package:kumas_topu/models/create_result_epc.dart';
import 'package:kumas_topu/models/epc_detail.dart';
import 'package:kumas_topu/models/serial_number.dart';

import '../../../models/encode_standarts.dart';
import '../../../models/inventory_list.dart';
import '../../../models/login_success.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../local/local_base.dart';

import '../../local/local_manager.dart';
import '../../network/network_manager.dart';
import 'locator.dart';

class Repository extends LocaleBase {
  final localService = locator<LocaleService>();
  final networkManager = NetworkManager.instance;

  static Repository? _instance;



  static Repository? get instance {
    _instance ??= Repository._();
    return _instance;
  }

  Repository._();


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

  Future<EncodeStandarts?> getEncodeStandarts() async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          var items = await networkManager!.getEncodeStandartList(token);
          return items;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<CreateResultEPC?> createEPCForMatch(
    WidgetRef ref,
  ) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          var epcResult = await networkManager!.createEPCForMatch(
              ref.read(currentBarcodeInfoProvider).barcodeInfo!,
              ref.read(currentBarcodeStandartProvider),
              token);
          if (epcResult == null) {
            return epcResult;
          } else {
            var currentBarcodeInfo = ref.read(currentBarcodeInfoProvider);
            currentBarcodeInfo.epc = epcResult.data!.epc;
            currentBarcodeInfo.password = epcResult.data!.password;
            currentBarcodeInfo.userData = epcResult.data!.userBank;

            ref
                .read(currentBarcodeInfoProvider.notifier)
                .changeState(currentBarcodeInfo);

            return epcResult;
          }
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<SerialNumber?> getSerialNumber(WidgetRef ref) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          return await networkManager!.getSerialFromDatabase(token);
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<bool> addInventory(String title,bool isShipment ) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          return await networkManager!.addInventory(title, token,isShipment).then((value) {
            return value!.data!;
          });
        } else {
          return false;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<void> sendTags(
      Inventory inventory, List<dynamic> readEpcList, bool saveAndClose
      ,bool isShipment ) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          return await networkManager!
              .sendTags(token, inventory, readEpcList, saveAndClose,isShipment)
              .then((value) {});
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<InventoryList?> getInventoryList(bool isShipment ) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          return await networkManager!.getInventories(token,isShipment).then((value) {
            return value!;
          });
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<EpcDetail?> getCurrentDetailThenSet(String epc) async {
    try {
      return localService.getToken().then((token) async {
        if (token != null) {
          return await networkManager!.getEpcDetail(token,epc).then((value) {
            return value;
          });
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
