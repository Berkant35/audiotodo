import 'dart:math';

import 'package:cross_point/layers/models/uhf_tag_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../native/native_manager.dart';

class InventoryTagsManager extends StateNotifier<Map<String, UHFTagInfo>> {
  InventoryTagsManager(Map<String, UHFTagInfo> state) : super({});

  final nativeManager = NativeManager();
  Set<String> expectedEpcList = {};
  Set<String> waitingEpcList = {};
  changeState(Map<String, UHFTagInfo> value) {
    state = value;
  }

  addWaitingTag(String epc){
    waitingEpcList.add(epc);
  }

  addReadedTagForExpected(String epc){
    expectedEpcList.add(epc);
  }

  addTag(UHFTagInfo? tag) {
    Map<String, UHFTagInfo> _tags = {...state};
    if (tag != null) {
      _tags.putIfAbsent(tag.epc!, () => tag);
    }
    state = _tags;

  }

  startScan(WidgetRef ref) {
    nativeManager.inventoryAndThenGetTags(ref).then((value) {
      nativeManager.startScan();
    });
  }

  stopScan() {
    nativeManager.stopScan();
  }

  updateTag(UHFTagInfo tag) {
    state.update(tag.tid!, (value) => tag);
  }

  removeTag(UHFTagInfo tag) {
    state.remove(tag);
  }

  clearTagList() {
    state.clear();
    nativeManager.clear();
    expectedEpcList.clear();
  }
}
