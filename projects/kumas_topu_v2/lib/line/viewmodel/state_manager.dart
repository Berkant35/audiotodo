

import 'package:state_notifier/state_notifier.dart';

import '../../utilities/constants/app/enums.dart';

class StateManager extends StateNotifier<LoadingStates>{
  StateManager(LoadingStates state) : super(LoadingStates.loaded);

  changeState(LoadingStates value){
    state = value;
  }
}
