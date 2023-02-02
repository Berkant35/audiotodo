

import 'package:state_notifier/state_notifier.dart';

class AddUserTabManager extends StateNotifier<int>
{
  AddUserTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}