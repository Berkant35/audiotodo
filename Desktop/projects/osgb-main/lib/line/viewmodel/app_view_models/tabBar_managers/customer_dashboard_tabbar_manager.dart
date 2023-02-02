


//CustomerDashboardTabBarManager

import 'package:state_notifier/state_notifier.dart';

class CustomerDashboardTabBarManager extends StateNotifier<int>
{
  CustomerDashboardTabBarManager(int state) :
        super(1);

  changeState(int index)
  {
    state = index;
  }

}