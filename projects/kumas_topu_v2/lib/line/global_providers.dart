
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/viewmodel/current_barcode_info_manager.dart';
import 'package:kumas_topu/line/viewmodel/current_barcode_standart.dart';
import 'package:kumas_topu/line/viewmodel/login_state_manager.dart';
import 'package:kumas_topu/line/viewmodel/operation_work_manager.dart';
import 'package:kumas_topu/line/viewmodel/rfid_state_manager.dart';
import 'package:kumas_topu/line/viewmodel/scan_state_manager.dart';
import 'package:kumas_topu/line/viewmodel/scan_stop_manager.dart';
import 'package:kumas_topu/line/viewmodel/state_manager.dart';
import 'package:kumas_topu/line/viewmodel/tags_manager.dart';
import 'package:kumas_topu/line/viewmodel/trigger_mode.dart';
import 'package:kumas_topu/line/viewmodel/view_model.dart';
import 'package:kumas_topu/line/viewmodel/write_mode_manager.dart';
import 'package:kumas_topu/models/encode_standarts.dart';

import '../models/barcode_info.dart';
import '../models/rfid_device.dart';
import '../models/uhf_tag_info.dart';
import '../utilities/constants/app/enums.dart';


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

final currentBarcodeStandartProvider =
StateNotifierProvider<CurrentBarcodeStandartManager, PerStandart?>((ref) {
  return CurrentBarcodeStandartManager(null);
});
final stateManagerProvider =
StateNotifierProvider<StateManager, LoadingStates>((ref) {
  return StateManager(LoadingStates.loaded);
});

final operationStatusStateProvider =
StateNotifierProvider<OperationStatusStateManager, OperationStatus>((ref) {
  return OperationStatusStateManager(OperationStatus.IDLE);
});
final scanStopStateProvider =
StateNotifierProvider<ScanModeStateManager, ScanModes>((ref) {
  return ScanModeStateManager(ScanModes.idle);
});
final scanToMatchProvider =
StateNotifierProvider<ScanToMatchStateManager, ScanToMatchStatus>((ref) {
  return ScanToMatchStateManager(ScanToMatchStatus.IDLE);
});
final viewModelStateProvider = StateNotifierProvider<ViewModel, void>((ref) {
  return ViewModel();
});
final writeModeStateProvider =
StateNotifierProvider<WriteModeManager, String>((ref) {
  return WriteModeManager("SGTIN");
});

final currentBarcodeInfoProvider =
StateNotifierProvider<CurrentBarcodeInfoManager, BarcodeInfo>((ref) {
  return CurrentBarcodeInfoManager(BarcodeInfo());
});

final currentTriggerModeProvider=
StateNotifierProvider<TriggerModeManager, TriggerModeStatus>((ref) {
  return TriggerModeManager(TriggerModeStatus.IDLE);
});

