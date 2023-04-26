import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/core/navigation/navigation_service.dart';
import 'package:audiotodo/line/db/firebase/auth/auth_manager.dart';
import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../utilities/constants/enums/loading_states.dart';

class AuthManagerProvider extends StateNotifier<UserModel?> with AuthManager {
  AuthManagerProvider(UserModel? userModel) : super(null);
  final _authService = AuthService();

  changeUser(UserModel userModel) => state = userModel;

  @override
  Future<bool> createCustomUserWithEmailAndPassword(
      String email, String password, UserModel userModel, WidgetRef ref) async {
    try {
      return await _authService.createCustomUserWithEmailAndPassword(
          email, password, userModel, ref);
    } catch (e) {
      logger.e(e);
      return false;
    } finally {
      ref.read(aLoadingStateManager.notifier).changeState(LoadingState.idle);
    }
  }

  @override
  Future<UserModel?> currentUser(WidgetRef ref) async {
    try {
      var currentUser = await _authService.currentUser(ref);
      state = currentUser;
      return currentUser;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email, WidgetRef ref) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> signIn(
      String email, String password, WidgetRef ref) async {
    try {
      var currentUser = await _authService.signIn(email, password, ref);
      state = currentUser;

      if (state != null) {
        // await NavigationService.instance
        //     .navigateToPageClear(path: NavigationConstants.mainBase);
      }

      return state;
    } catch (e) {
      logger.e("Error: $e");
    }
    return null;
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<bool> updateEmail(String email, String password, WidgetRef ref) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(
      String currentPassword, String newPassword, WidgetRef ref) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
