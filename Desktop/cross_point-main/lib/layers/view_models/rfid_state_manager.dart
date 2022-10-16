import 'package:cross_point/utilities/navigation/navigation_constants.dart';
import 'package:cross_point/utilities/navigation/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/common_widgets/flutter_toast_dialog.dart';
import '../models/rfid_device.dart';
import '../native/native_manager.dart';

///RFID Cihazının  bağlı olup olmadığını ve en son deaktif ettiği tagi tutan
///RFIDDevice Objesinin statetini tutar.
class RFIDDeviceStateManager extends StateNotifier<RFIDDevice?> {
  RFIDDeviceStateManager(RFIDDevice? state) : super(null);

  NativeManager nativeManager = NativeManager();

  changeState(RFIDDevice value) {
    state = value;
    debugPrint("Rfid Device -> ${state.toString()}");
  }

  ///Cihaza bağlanma fonksiyon
  Future<void> initReader(WidgetRef ref) async {
    var readerDevice = await nativeManager.connectRFIDDevice();
    if (readerDevice != null) {
      debugPrint("Successfully initialized!");
      state = readerDevice;
      Dialogs.showSuccess("RFID Active");
      /*NavigationService.instance
          .navigateToPage(path: NavigationConstants.newInventoryPage);*/
      //ref.read(contentStateProvider.notifier).changeState(ContentStates.READY);
      //nativeManager.listenButtonForKill(ref);
    } else {
      //ref.read(switchControllerProvider.notifier).changeState(false, ref);
      debugPrint('Not initialized!');
      Dialogs.showSuccess("Failed Connected!");
    }
  }
}
