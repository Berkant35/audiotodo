



import 'package:state_notifier/state_notifier.dart';

enum ScanModes {scan,stop,idle}
class ScanModeStateManager extends StateNotifier<ScanModes>{
  ScanModeStateManager(ScanModes idle) : super(ScanModes.idle);

  changeState(ScanModes value){
    state = value;
  }
}