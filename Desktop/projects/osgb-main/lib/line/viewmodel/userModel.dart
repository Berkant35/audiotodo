import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/base_user_model.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';

import '../../models/admin.dart';
import '../../models/customer.dart';
import '../network/auth/auth_manager.dart';

class UserModelManager extends StateNotifier<BaseUserModel> {
  UserModelManager(BaseUserModel state)
      : super(BaseUserModel(
            admin: null, expert: null, customer: null, accountant: null));
  final auth = AuthService();

  changeState(BaseUserModel newModel) {
    state = newModel;
  }

  Future<void> logOut(WidgetRef ref) async {
    String currentRootUserID = "";

    switch (ref.read(currentRole)) {
      case Roles.none:
        // TODO: Handle this case.
        break;
      case Roles.admin:
        currentRootUserID = state.admin!.rootUserID!;
        break;
      case Roles.accountant:
        currentRootUserID = state.accountant!.rootUserID!;

        break;
      case Roles.customer:
        currentRootUserID = state.customer!.rootUserID!;
        break;
      case Roles.expert:
        currentRootUserID = state.expert!.rootUserID!;
        break;
      case Roles.doctor:
        currentRootUserID = state.doctor!.rootUserID!;
        break;
      case Roles.worker:
        break;
    }

    BaseUserModel baseUserModel = BaseUserModel(
        admin: null, expert: null, customer: null, accountant: null);

    changeState(baseUserModel);

    auth.signOut().then((value) async {
      debugPrint(value.toString());

      if (value) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.landingPage);
        await ref
            .read(currentPushNotificationState.notifier)
            .updatePushToken("", currentRootUserID);
      }
    });
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await auth.updatePassword(currentPassword, newPassword);
    } catch (e) {
      debugPrint("Error Password ${e.toString()}");
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<Admin?> getAdmin() async {
    try {
      return await auth.getAdminToken();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Expert?> getExpert(String rootUserID) async {
    try {
      return await auth.getExpert(rootUserID);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Customer?> getCustomer(String rootUserID) async {
    try {
      return await auth.getCustomer(rootUserID);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
