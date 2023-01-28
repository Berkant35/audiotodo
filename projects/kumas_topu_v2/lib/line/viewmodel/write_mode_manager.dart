



import 'package:state_notifier/state_notifier.dart';

class WriteModeManager extends StateNotifier<String>{
  WriteModeManager(String writeMode) : super("SGTIN");

  changeState(String value){
    state = value;
  }
}