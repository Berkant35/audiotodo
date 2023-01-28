


import 'package:state_notifier/state_notifier.dart';

import '../../utilities/constants/app/enums.dart';


class OperationStatusStateManager extends StateNotifier<OperationStatus>{
  OperationStatusStateManager(OperationStatus state) : super(OperationStatus.IDLE);

  changeState(OperationStatus value){
    state = value;
  }

}