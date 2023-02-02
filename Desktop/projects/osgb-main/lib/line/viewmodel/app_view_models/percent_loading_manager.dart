



import 'package:state_notifier/state_notifier.dart';

class PercentLoadingManager extends StateNotifier<int>{
  PercentLoadingManager(int state) :
        super(-1);

  changeState(int value)
  {
    state = value;

  }
}