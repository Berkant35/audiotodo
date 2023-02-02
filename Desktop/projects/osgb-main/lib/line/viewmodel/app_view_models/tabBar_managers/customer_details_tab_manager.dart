




import 'package:state_notifier/state_notifier.dart';

class CustomerDetailsTabBarManager extends StateNotifier<int>
{
  CustomerDetailsTabBarManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}