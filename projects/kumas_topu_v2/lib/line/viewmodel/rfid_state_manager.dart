import 'dart:ffi';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../models/barcode_info.dart';
import '../../models/rfid_device.dart';
import '../../utilities/components/dialogs.dart';
import '../native/native_manager.dart';

///RFID Cihazının  bağlı olup olmadığını ve en son deaktif ettiği tagi tutan
///RFIDDevice Objesinin statetini tutar.
class RFIDDeviceStateManager extends StateNotifier<RFIDDevice?> {
  RFIDDeviceStateManager(RFIDDevice? state) : super(null);

  double? currentPowerValue;


  NativeManager nativeManager = NativeManager();

  changeState(RFIDDevice value) {
    state = value;
    debugPrint("Rfid Device -> ${state.toString()}");
  }

  Future<void> scanBarcode(WidgetRef ref) async {
     await nativeManager.scanBarcode(ref,false);
  }


  ///Cihaza bağlanma fonksiyon
  Future<void> initReader(WidgetRef ref) async {
    var readerDevice = await nativeManager.connectRFIDDevice();
    if (readerDevice != null) {
      state = readerDevice;
      Dialogs.showSuccess("RFID Aktif");
      /*NavigationService.instance
          .navigateToPage(path: NavigationConstants.newInventoryPage);*/
      //ref.read(contentStateProvider.notifier).changeState(ContentStates.READY);
      //nativeManager.listenButtonForKill(ref);
    }
  }

  Future<double?> getPower() async {
    var result = await nativeManager.getPower();
    currentPowerValue = result.toDouble();
    return currentPowerValue ?? 5.0;
  }

  Future<void> setPower(String setPowerValue) async {
    currentPowerValue  = double.tryParse(setPowerValue)!.toInt().toDouble();
     await nativeManager.setPower(setPowerValue).then((value){
       currentPowerValue  = double.tryParse(setPowerValue);
     });
  }
}
