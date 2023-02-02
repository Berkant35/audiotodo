

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/app/enums.dart';

class ButtonLoadingManager extends StateNotifier<LoadingStates>{
  ButtonLoadingManager(LoadingStates state) :
        super(LoadingStates.idle);

  changeState(LoadingStates loadingState)
  {
    state = loadingState;
    debugPrint("Change state ${loadingState.name}");
  }
}