

import 'package:cross_point/utilities/constants/enums.dart';
import 'package:state_notifier/state_notifier.dart';


class OperationStatusStateManager extends StateNotifier<OperationStatus>{
  OperationStatusStateManager(OperationStatus state) : super(OperationStatus.IDLE);

  changeState(OperationStatus value){
    state = value;
  }

}