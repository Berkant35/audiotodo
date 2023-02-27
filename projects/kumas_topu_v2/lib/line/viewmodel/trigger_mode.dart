


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/native/native_manager.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:state_notifier/state_notifier.dart';

class TriggerModeManager extends StateNotifier<TriggerModeStatus>{
  TriggerModeManager(TriggerModeStatus state) : super(TriggerModeStatus.IDLE);

  final nativeManager = NativeManager.instance;

  changeState(TriggerModeStatus value,WidgetRef ref){
    switch(value){

      case TriggerModeStatus.IDLE:
        // TODO: Handle this case.
        break;
      case TriggerModeStatus.BARCODE:
       _changeToBarcodeStateOn(ref);
        break;
      case TriggerModeStatus.RFID:
        // TODO: Handle this case.
        break;
    }

  }

  Future<void> _changeToBarcodeStateOn(WidgetRef ref) async {
    var result =  await nativeManager!.barcodeModeOn(ref);
    if(result){
      state = TriggerModeStatus.BARCODE;
    }
  }


}