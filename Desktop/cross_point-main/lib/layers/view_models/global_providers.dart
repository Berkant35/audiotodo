import 'package:cross_point/layers/models/uhf_tag_info.dart';
import 'package:cross_point/layers/view_models/rfid_state_manager.dart';
import 'package:cross_point/layers/view_models/scan_stop_manager.dart';
import 'package:cross_point/layers/view_models/tags_manager.dart';
import 'package:cross_point/layers/view_models/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/rfid_device.dart';
import 'login_state_manager.dart';

final rfidStateProvider =
    StateNotifierProvider<RFIDDeviceStateManager, RFIDDevice?>((ref) {
  return RFIDDeviceStateManager(null);
});

final inventoryTagsProvider =
    StateNotifierProvider<InventoryTagsManager, Map<String, UHFTagInfo>>((ref) {
  return InventoryTagsManager({});
});

final loginButtonStateProvider =
StateNotifierProvider<LoginButtonStateManager, LoadingStates>((ref) {
  return LoginButtonStateManager(LoadingStates.loaded);
});

final scanStopStateProvider =
StateNotifierProvider<ScanModeStateManager, ScanModes>((ref) {
  return ScanModeStateManager(ScanModes.idle);
});

final viewModelStateProvider = StateNotifierProvider<ViewModel, void>((ref) {
  return ViewModel();
});