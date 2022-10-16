import 'package:cross_point/layers/models/rfid_device.dart';
import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/uhf_tag_info.dart';

part 'native_interface.dart';

class NativeManager extends NativeInterface {
  @override
  Future<RFIDDevice?> connectRFIDDevice() async {
    var result = await _methodChannel.invokeMethod(InvokeMethods.init.name);
    if (result.toString() == RFIDStatus.connected.name.toUpperCase()) {
      RFIDDevice rfidDevice = RFIDDevice(result);
      return rfidDevice;
    } else {
      return null;
    }
  }

  @override
  Future<void> inventoryAndThenGetTags(WidgetRef ref) async {
    _eventChannel
        .receiveBroadcastStream(BroadCastStates.inventoryAndGetTag.name)
        .listen((event) {
      //Clear Option
      if (event.toString() == '-1') {
        ref.read(inventoryTagsProvider.notifier).clearTagList();
        /*
        ref.read(inventoryTagsProvider.notifier).changeState({});
        */
      } else {
        //UHFTagInfo perTag = UHFTagInfo.fromJson(jsonDecode(event));
        debugPrint('$event=Flutter');
        var uhfTagInfo = UHFTagInfo(epc: event, tid: event, userData: event);


        ref
            .read(inventoryTagsProvider.notifier)
            .addTag(uhfTagInfo);
        if(ref.read(inventoryTagsProvider.notifier).waitingEpcList.contains(uhfTagInfo.epc)){
          ref.read(inventoryTagsProvider.notifier).addReadedTagForExpected(uhfTagInfo.epc!);
        }

        /*
        ref
            .read(inventoryTagsProvider.notifier)
            .changeState();*/
      }
    });
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



}
