import 'package:audiotodo/models/user_model.dart';
import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/firebase/auth/auth_manager.dart';
import 'app/a_loading_manager.dart';
import 'app/all_loading_managers.dart';
import 'auth/auth_manager.dart';

typedef LoadingStateKeyStatusMap = Map<String, LoadingState>;

//You can handle all authentication bussiniess logics
final authManager =
    StateNotifierProvider<AuthManagerProvider, UserModel?>((ref) {
  return AuthManagerProvider(null);
});

final currentLoadingStateManager =
    StateNotifierProvider<AllLoadingManagers, LoadingStateKeyStatusMap>((ref) {
  return AllLoadingManagers({});
});
final aLoadingStateManager =
    StateNotifierProvider<ALoadingManager, LoadingState>((ref) {
  return ALoadingManager(LoadingState.idle);
});
