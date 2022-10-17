import 'package:cross_point/layers/models/rfid_device.dart';
import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/layers/view_models/scan_stop_manager.dart';
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
        if(ref.read(scanStopStateProvider) == ScanModes.scan){
          ref.read(scanStopStateProvider.notifier).changeState(ScanModes.stop);
        }
        /*
        ref.read(inventoryTagsProvider.notifier).changeState({});
        */
      } else {
        if(ref.read(scanStopStateProvider) == ScanModes.stop
            || ref.read(scanStopStateProvider) == ScanModes.idle)
        {
          ref.read(scanStopStateProvider.notifier).changeState(ScanModes.scan);
        }

        //UHFTagInfo perTag = UHFTagInfo.fromJson(jsonDecode(event));
        debugPrint('$event=Flutter');
        var uhfTagInfo = UHFTagInfo(epc: event, tid: event, userData: event);


        ref
            .read(inventoryTagsProvider.notifier)
            .addTag(uhfTagInfo);
        if(ref.read(inventoryTagsProvider.notifier).waitingEpcList.contains(uhfTagInfo.epc)
        && !ref.read(inventoryTagsProvider.notifier).expectedEpcList.contains(uhfTagInfo.epc))
        {
          ref.read(inventoryTagsProvider.notifier).addReadedTagForExpected(uhfTagInfo.epc!);
          playSound();
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

  @override
  Future<void> playSound() async {
    await _methodChannel.invokeMethod(InvokeMethods.playSound.name);
  }



}
