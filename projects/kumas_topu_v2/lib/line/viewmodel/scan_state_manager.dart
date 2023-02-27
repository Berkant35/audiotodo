



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/constants/app/enums.dart';
import '../native/native_manager.dart';



class ScanToMatchStateManager extends StateNotifier<ScanToMatchStatus>{
  ScanToMatchStateManager(ScanToMatchStatus state) : super(ScanToMatchStatus.IDLE);
  final nativeManager = NativeManager.instance;

  changeState(ScanToMatchStatus value){
    state = value;
    debugPrint("State ${state.toString()}");
  }

  Future<void> listen(WidgetRef ref)async{
    nativeManager!.listenAndSetScanToMatchStatus(ref);
  }

  Future<void> setMode(ScanToMatchStatus scanToMatchStatus) async {
    nativeManager!.setStatusOfScanToMatchStatus(scanToMatchStatus);
  }

}