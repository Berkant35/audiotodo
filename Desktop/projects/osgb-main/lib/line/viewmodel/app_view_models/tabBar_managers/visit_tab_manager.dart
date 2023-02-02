

import 'package:state_notifier/state_notifier.dart';

class VisitTabManager extends StateNotifier<int>
{
  VisitTabManager(int state) :
        super(0);

  changeState(int index)
  {
    state = index;
  }

}