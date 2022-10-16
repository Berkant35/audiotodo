
import 'package:flutter/cupertino.dart';
import 'package:state_notifier/state_notifier.dart';

enum LoadingStates {loading,loaded}
class LoginButtonStateManager extends StateNotifier<LoadingStates>{
  LoginButtonStateManager(LoadingStates state) : super(LoadingStates.loaded);

  changeState(LoadingStates value){
    state = value;
    debugPrint("State ${state.toString()}");
  }
}