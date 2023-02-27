import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/line/native/native_manager.dart';
import 'package:kumas_topu/line/network/network_manager.dart';
import 'package:kumas_topu/line/repository/repository/repository_base.dart';

import 'package:kumas_topu/line/viewmodel/scan_stop_manager.dart';
import 'package:kumas_topu/models/current_epc_detail.dart';

class CurrentEpcDetailManager extends StateNotifier<CurrentEpcDetail?> {
  CurrentEpcDetailManager(CurrentEpcDetail? state) : super(null);

  changeState(CurrentEpcDetail? value)
  {
    state = value;
  }

  Future<void> getCurrentDetailThenSet(WidgetRef ref,bool isTrigger) async {
    try {
      ref.read(scanStopStateProvider.notifier).changeState(ScanModes.scan);

      if(isTrigger){
        await Repository.instance!
            .getCurrentDetailThenSet(state!.currentEpc!)
            .then((value){
          var currentEpcDetail = state;
          currentEpcDetail!.epcDetail = value;
          changeState(currentEpcDetail);
        });
      }else{
        NativeManager.instance!.singleInventory(ref)
            .then((value) async {
          await Repository.instance!
              .getCurrentDetailThenSet(state!.currentEpc!)
              .then((value){
            var currentEpcDetail = state;
            currentEpcDetail!.epcDetail = value;
            changeState(currentEpcDetail);
          });
        });
      }

    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(scanStopStateProvider.notifier).changeState(ScanModes.stop);
    }
  }
}
