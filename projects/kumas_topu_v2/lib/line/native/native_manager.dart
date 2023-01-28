import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/models/encode_status.dart';
import 'package:kumas_topu/utilities/components/dialogs.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';

import '../../models/barcode_info.dart';
import '../../models/rfid_device.dart';
import '../../models/uhf_tag_info.dart';
import '../../utilities/constants/app/enums.dart';
import '../global_providers.dart';
import '../viewmodel/scan_stop_manager.dart';

part 'native_interface.dart';

class NativeManager extends NativeInterface {
  @override
  Future<RFIDDevice?> connectRFIDDevice() async {
    try {
      var result = await _methodChannel.invokeMethod(InvokeMethods.init.name);
      debugPrint("Result: $result");
      if (result.toString() == RFIDStatus.connected.name.toUpperCase()) {
        RFIDDevice rfidDevice = RFIDDevice(result);
        return rfidDevice;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isJsonString(str) {
    try {
      json.decode(str);
    } catch (e) {
      return false;
    }
    return true;
  }

  ///Java'da gerçekleşen status durumun dinliyoruz bu fonksiyon ile
  @override
  Future<void> listenAndSetScanToMatchStatus(WidgetRef ref) async {
    _scanToMatchEventChannel
        .receiveBroadcastStream(
            BroadCastStates.scanToMatchAndGetTagWithBarcodeNumber.name)
        .listen((event) {
      if (isJsonString(event.toString())) {
        var object = json.decode(event.toString());
        if (object is Map<String, dynamic>) {
          ref
              .read(currentBarcodeInfoProvider.notifier)
              .changeState(BarcodeInfo.fromJson(object));
        }
      } else {
        /*ref.read(scanToMatchProvider.notifier).changeState(
            AllFunc.getScanToMatchStatusEnumValue(event.toString()));*/
      }
    });
  }

  @override
  Future<void> setStatusOfScanToMatchStatus(
      ScanToMatchStatus scanToMatchStatus) async {
    debugPrint("SCAN TO MATCH STATUS to nativee.... ${scanToMatchStatus.name}");
    await _methodChannel.invokeMethod(InvokeMethods.setScanToMatchStatus.name,
        {"status": scanToMatchStatus.name});
  }

  @override
  Future<void> inventoryAndThenGetTags(WidgetRef ref) async {
    _inventoryEventChannel
        .receiveBroadcastStream(BroadCastStates.inventoryAndGetTag.name)
        .listen((event) {
      //Clear Option
      if (event.toString() == '-1') {
        if (ref.read(scanStopStateProvider) == ScanModes.scan) {
          ref.read(scanStopStateProvider.notifier).changeState(ScanModes.stop);
        }
      } else if(event.toString() == "1"){
        if (ref.read(scanStopStateProvider) == ScanModes.stop ||
            ref.read(scanStopStateProvider) == ScanModes.idle) {
          ref.read(scanStopStateProvider.notifier).changeState(ScanModes.scan);
        }

        //UHFTagInfo perTag = UHFTagInfo.fromJson(jsonDecode(event));

        debugPrint("Flutter: $event");
      }
    });
  }

  @override
  Future<void> initInventory() async {
    await _methodChannel.invokeMethod(InvokeMethods.initInventory.name);
  }

  @override
  Future<void> startScan() async {
    await _methodChannel.invokeMethod(InvokeMethods.continueInventory.name);
  }

  @override
  Future<void> stopScan() async {
    await _methodChannel.invokeMethod(InvokeMethods.stopInventory.name);
  }

  @override
  Future<void> clear() async {
    await _methodChannel.invokeMethod(InvokeMethods.clearInventory.name);
  }

  @override
  Future<void> playSound() async {
    await _methodChannel.invokeMethod(InvokeMethods.playSound.name);
  }

  @override
  Future<int> getPower() async {
    var result = await _methodChannel.invokeMethod(InvokeMethods.getPower.name);
    result ??= 5;
    return int.parse(result);
  }

  @override
  Future<void> setPower(String value) async {
    await _methodChannel
        .invokeMethod(InvokeMethods.setPower.name, {"powerValue": value});
  }

  @override
  Future<void> scanBarcode(WidgetRef ref,bool isGoToFirstPage) async {
    var result =
        await _methodChannel.invokeMethod(InvokeMethods.scanBarcode.name);

    debugPrint('$result <-Flutter');
    //var barcodeJson = json.decode(result.toString());

    var barcodeInfo = BarcodeInfo(barcodeInfo: result);

    ref.read(currentBarcodeInfoProvider.notifier).changeState(barcodeInfo);

    scanBarcode(ref,false);
  }

  Future<void> scanBarcodeButton(WidgetRef ref) async {
    var result = await _methodSupportChannel
        .invokeMethod(InvokeMethods.scanBarcodeButton.name);

    debugPrint('$result <-Flutter');
    //var barcodeJson = json.decode(result.toString());
    var barcodeInfo = BarcodeInfo(barcodeInfo: result);
    ref.read(currentBarcodeInfoProvider.notifier).changeState(barcodeInfo);
    scanBarcode(ref,false);
  }

  @override
  Future<void> singleInventory() async {
    await _methodChannel.invokeMethod(InvokeMethods.singleInventory.name);
  }



  @override
  Future<bool> barcodeModeOn(WidgetRef ref) async {
    var result =
        await _methodChannel.invokeMethod(InvokeMethods.barcodeModeOn.name);
    if (result == "CONNECTED") {
      Dialogs.showSuccess("Barkod Aktif!");
      scanBarcode(ref,false);
      return true;
    } else {
      Dialogs.showFailed("Barkoda Bağlanılamadı!");
      return false;
    }
  }

  Future<void> listenTriggerForWriteMode(WidgetRef ref, String epc) async {
    await _methodChannel
        .invokeMethod(InvokeMethods.writeEpc.name, {"epc": epc});

    _eventChannel
        .receiveBroadcastStream(BroadCastStates.listenTriggerForWrite.name)
        .listen((event) {
          debugPrint(event.toString()+'<---event');
      if (event == TriggerPressStatus.PRESSING.name) {
        ref
            .read(loginButtonStateProvider.notifier)
            .changeState(LoadingStates.loading);
      } else if (event == TriggerPressStatus.IDLE.name) {
        ref
            .read(loginButtonStateProvider.notifier)
            .changeState(LoadingStates.loaded);
      } else if (event == TriggerPressStatus.STOPPED.name) {
        ref
            .read(loginButtonStateProvider.notifier)
            .changeState(LoadingStates.loaded);
      } else {
        var getResult = showDialogFromSuccessOrWrite(event);

        if (getResult) {
          ref
              .read(viewModelStateProvider.notifier)
              .repository
              .localService
              .getToken()
              .then((token) {
            if (token != null) {
              ref
                  .read(viewModelStateProvider.notifier)
                  .repository
                  .networkManager!
                  .encodeStatusOK(epc, "1", token)
                  .then((value) {
                goFirstPage(value, ref);
              });
            }
          });
        }
      }
    });
  }

  Future<void> goFirstPage(EncodeStatus? value, WidgetRef ref) async {
    if (value != null && value.code == 200) {
      NavigationService.instance.navigateToPageClear(
          path: NavigationConstants.encodeMainPage
      );
      scanBarcode(
          ref,true);

    }
  }

  Future<bool> writeData(WidgetRef ref, String epc) async {
    try {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loading);

      var result = await _methodSupportChannel
          .invokeMethod(InvokeMethods.writeEpc.name, {"epc": epc});

      var getResult = showDialogFromSuccessOrWrite(result);

      if (getResult) {
        ref
            .read(viewModelStateProvider.notifier)
            .repository
            .localService
            .getToken()
            .then((token) {
          if (token != null) {
            debugPrint("ISOK--EPC:$epc}");

            ref
                .read(viewModelStateProvider.notifier)
                .repository
                .networkManager!
                .encodeStatusOK(epc, "1", token)
                .then((value) {
              goFirstPage(value, ref);
            });
          }
        });
      }

      return getResult;
    } finally {
      ref
          .read(loginButtonStateProvider.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  bool showDialogFromSuccessOrWrite(result) {
    if (result == "TOO_MANY_TAG") {
      Dialogs.showFailed("Birden Fazla Etiket Tespit Edildi!");
      return false;
    } else if (result == "NOT_FOUND_TAG") {
      Dialogs.showFailed("Etiket Bulunamadı!");
      return false;
    } else if (result == "SOMETHING_WENT_WRONG") {
      Dialogs.showFailed("Bir şeyler ters gitti!");
      return false;
    } else if (result == "SUCCESS") {
      Dialogs.showSuccess("Yazma İşlemi Başarılı bir şekilde gerçekleştirildi");
      return true;
    } else {
      return false;
    }
  }
}
