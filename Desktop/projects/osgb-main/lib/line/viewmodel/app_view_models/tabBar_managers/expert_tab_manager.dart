


import 'package:state_notifier/state_notifier.dart';

class ExpertTabManager extends StateNotifier<int>
{
  ExpertTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}