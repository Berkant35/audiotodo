



import 'package:state_notifier/state_notifier.dart';

class CurrentPowerValueManager extends StateNotifier<int>{
  CurrentPowerValueManager(int state) : super(15);

  changeState(int value){
    state = value;
  }
}