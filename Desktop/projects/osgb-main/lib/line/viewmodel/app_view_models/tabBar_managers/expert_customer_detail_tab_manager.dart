

import 'package:state_notifier/state_notifier.dart';

class ExpertCustomerDetailTabManager extends StateNotifier<int>
{
  ExpertCustomerDetailTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}