import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

class LoadingStateManager extends StateNotifier<LoadingStates> {
  LoadingStateManager(LoadingStates state) :
        super(LoadingStates.idle);

  changeState(LoadingStates loadingState)
  {
    state = loadingState;
  }

}
