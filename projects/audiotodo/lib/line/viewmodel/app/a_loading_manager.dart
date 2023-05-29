import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ALoadingManager extends StateNotifier<LoadingState> {
  ALoadingManager(LoadingState state) : super(LoadingState.idle);

  changeState(LoadingState loadingState) {

    state = loadingState;
  }


}
