import 'package:flutter/material.dart';
import 'package:kumas_topu/models/current_inventory.dart';
import 'package:kumas_topu/models/read_epc.dart';
import 'package:state_notifier/state_notifier.dart';

import '../native/native_manager.dart';
import '../repository/repository/repository_base.dart';

class CurrentInventoryState extends StateNotifier<CurrentInventory?> {
  CurrentInventoryState(CurrentInventory? currentInventory)
      : super(
            CurrentInventory(readEpcMap: {}, readEpcList: [], inventory: null));
  int count = 0;

  final nativeManager = NativeManager.instance;
  final repository = Repository.instance;

  changeState(CurrentInventory value) {
    state = value;
  }

  Future<void> getReadListAndSet(String? shipmentId,bool isShipment) async {
    final currentList = await repository!.getReadList(shipmentId,isShipment);

    for (var perReadEpc in currentList!) {
      addTag(perReadEpc.epc!, perReadEpc.readDate!);
    }

    state = state!.copyWith(
        readEpcList: currentList,
        inventory: state!.inventory!,
        readEpcMap: state!.readEpcMap);
  }

  addTag(String epc, String dateTime) {
    count++;

    if (state!.readEpcMap != null && !state!.readEpcMap!.keys.contains(epc)) {
      final readEpc = ReadEpc(epc: epc, readDate: dateTime);

      state?.readEpcMap!.addAll({readEpc.epc!: readEpc});
      state?.readEpcMap!.values.toList().sort((a, b) =>
          DateTime.parse(b.readDate!).compareTo(DateTime.parse(a.readDate!)));

      nativeManager!.playSound();
    }

    updateCurrentState();
  }

  clearInventory() {
    state = state!.copyWith(inventory: null, readEpcList: [], readEpcMap: {});
    nativeManager!.clear();
    //updateCurrentState();
  }

  updateCurrentState() {
    CurrentInventory newCurrentInventory = CurrentInventory(
        inventory: state!.inventory,
        readEpcList: state!.readEpcList!,
        readEpcMap: state!.readEpcMap);
    changeState(newCurrentInventory);
  }
}
