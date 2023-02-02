


import 'package:state_notifier/state_notifier.dart';

class CustomerVisitsTabManager extends StateNotifier<int>
{
  CustomerVisitsTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}