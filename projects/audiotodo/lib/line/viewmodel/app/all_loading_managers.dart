import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllLoadingManagers extends StateNotifier<LoadingStateKeyStatusMap> {
  AllLoadingManagers(LoadingStateKeyStatusMap state) : super({});

  addLoadingState(String key) {
    state.addAll({key: LoadingState.idle});
    changeState(key, LoadingState.loading);
  }

  changeAllStateToIdle() {
    for (var perKey in state.keys) {
      state[perKey] = LoadingState.idle;
    }
  }

  changeAllStateToLoading() {
    for (var perKey in state.keys) {
      state[perKey] = LoadingState.loading;
    }
  }

  changeAllStateToLoaded() {
    for (var perKey in state.keys) {
      state[perKey] = LoadingState.loaded;
    }
  }

  changeState(String key, LoadingState loadingState) {
    LoadingStateKeyStatusMap allLoadingManagers = state;
    allLoadingManagers[key] = loadingState;
    state = allLoadingManagers;
  }

  removeLoadingStateByKey(String key) {
    state.remove(key);
  }
}
