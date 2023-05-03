

import 'package:state_notifier/state_notifier.dart';

class ExpertDetailsTabBarManager extends StateNotifier<int>
{
  ExpertDetailsTabBarManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}