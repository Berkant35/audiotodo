import 'package:flutter/material.dart';
import 'package:kumas_topu/models/current_inventory.dart';
import 'package:kumas_topu/models/read_epc.dart';
import 'package:state_notifier/state_notifier.dart';

import '../native/native_manager.dart';

class CurrentInventoryState extends StateNotifier<CurrentInventory?> {
  CurrentInventoryState(CurrentInventory? currentInventory) : super(null);
  int count = 0;

  final nativeManager = NativeManager();

  changeState(CurrentInventory value) {
    state = value;
  }

  addTag(String epc, String dateTime) {
    count++;
    debugPrint("Count:$count");

    if (state?.readEpcList != null &&
        !state!.readEpcList!.toString().contains(epc))
    {

      state?.readEpcList!.add(ReadEpc(epc: epc, readDate: dateTime));

      state?.readEpcList!.sort((a, b) =>
          DateTime.parse(b.readDate!).compareTo(DateTime.parse(a.readDate!)));

      nativeManager.playSound();

    }

    updateCurrentState();
  }

  clearInventory() {
    state!.inventory = null;
    state!.readEpcList!.clear();

    updateCurrentState();
  }

  updateCurrentState() {
    CurrentInventory newCurrentInventory = CurrentInventory(
        inventory: state!.inventory, readEpcList: state!.readEpcList!);
    changeState(newCurrentInventory);
  }
}
