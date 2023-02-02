

import 'package:state_notifier/state_notifier.dart';

class AdminDashboardTabManager extends StateNotifier<int>
{
  AdminDashboardTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}