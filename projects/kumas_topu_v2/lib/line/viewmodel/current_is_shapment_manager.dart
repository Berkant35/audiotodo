


import 'package:state_notifier/state_notifier.dart';

class CurrentIsShipmentManager extends StateNotifier<bool>{
  CurrentIsShipmentManager(bool state) : super(false);

  changeState(bool value){
    state = value;
  }
}