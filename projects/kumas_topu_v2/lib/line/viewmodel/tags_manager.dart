import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/uhf_tag_info.dart';
import '../native/native_manager.dart';

class InventoryTagsManager extends StateNotifier<Map<String, UHFTagInfo>> {
  InventoryTagsManager(Map<String, UHFTagInfo> state) : super({});

  final nativeManager = NativeManager.instance;
  Set<String> expectedEpcList = {};
  Map<String,String> readTime = {};
  Set<String> waitingEpcList = {};

  bool isListening = false;

  changeState(Map<String, UHFTagInfo> value) {
    state = value;
  }

  addWaitingTag(String epc){
    waitingEpcList.add(epc);
  }

  addReadedTagForExpected(String epc){
    expectedEpcList.add(epc);
    var addedTimeFormatUTC =
    DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now().toUtc());
    readTime.addAll({epc : addedTimeFormatUTC});
  }

  addTag(UHFTagInfo? tag) {
    Map<String, UHFTagInfo> _tags = {...state};
    if (tag != null) {
      _tags.putIfAbsent(tag.epc!, () => tag);
    }
    state = _tags;

  }

  listen(WidgetRef ref) {
    debugPrint("Listening....");
    nativeManager!.inventoryAndThenGetTags(ref).then((value){
      isListening = true;
    });
  }



  startScan(WidgetRef ref) {

      nativeManager!.inventoryAndThenGetTags(ref).then((value){
        nativeManager!.startScan();
      });


  }

  stopScan() {
    nativeManager!.stopScan();
  }

  updateTag(UHFTagInfo tag) {
    state.update(tag.tid!, (value) => tag);
  }

  removeTag(UHFTagInfo tag) {
    state.remove(tag);
  }

  clearTagList(bool deleteWaitingEpcList) {
    state.clear();
    nativeManager!.clear();
    if(deleteWaitingEpcList){
      waitingEpcList.clear();
    }
    expectedEpcList.clear();

  }

  initInventory(){
    nativeManager!.initInventory();
  }
}
