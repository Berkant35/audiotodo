import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/network/auth/auth_manager.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/models/admin.dart';
import 'package:osgb/models/base_user_model.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/models/search_user.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../models/customer.dart';
import '../../../utilities/constants/app/application_constants.dart';
import '../../local/local_manager.dart';

class UserRoleManager extends StateNotifier<Roles> {
  UserRoleManager(Roles state) : super(Roles.none);

  final _authManager = AuthService();
  final _localManager = LocaleManager();

  changeState(Roles role) {
    state = role;
  }

  Future<void> checkLoggedAnyUser(WidgetRef ref) async {
    try {
      var result = await _authManager.currentUser();
      await currentUser(result, ref).then((value) {
        PackageInfo.fromPlatform().then((versionValue) async {
          logger.i(versionValue.buildNumber);
          await ref
              .read(currentPushNotificationState.notifier)
              .getVersionFromCloud()
              .then((appVersion) {

            String deviceVersion = versionValue.version;
            String? serverVersion = appVersion?.versionNumber;

            logger.i("Device Version: $deviceVersion Server Version: $serverVersion");

            int deviceVersionValue =
                int.parse(deviceVersion.replaceAll(".", ""));
            int serverVersionValue =
                int.parse(serverVersion!.replaceAll(".", ""));
            if (serverVersionValue > deviceVersionValue &&
                appVersion!.isRequiredForceUpdate!) {
              launchUrl(Platform.isAndroid
                  ? Uri.parse(ApplicationConstants.googlePlayLink)
                  : Uri.parse(
                      "https://apps.apple.com/tr/developer/apple/id284417353?l=tr&see-all=i-phone-apps"));
            }
          });
        });
      });
    } catch (e) {
      debugPrint('$e<--');
    } finally {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
  }

  String getNameString() {
    switch (state) {
      case Roles.none:
        return "";
      case Roles.admin:
        return "Admin";
      case Roles.accountant:
        return "Muhasebe";
      case Roles.customer:
        return "İş Yeri Yetkili";
      case Roles.expert:
        return "Uzman";
      case Roles.doctor:
        return "Doktor";
      case Roles.worker:
        return "Çalışan";
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password,
      File? localOfPath, Roles role, SearchUser searchUser) async {
    await _authManager.createUserWithEmailAndPassword(
        email, password, localOfPath?.path, role, searchUser);
    return null;
  }

  Future<dynamic> currentUser(dynamic currentModel, WidgetRef ref) async {
    debugPrint("Current User ${currentModel.toString()}");

    if (currentModel is Admin) {
      ref.read(currentBaseModelState.notifier).changeState(BaseUserModel(
            admin: currentModel,
            customer: null,
            expert: null,
            accountant: null,
            doctor: null,
          ));
      ref.read(currentRole.notifier).changeState(Roles.admin);
      goToLogin(NavigationConstants.adminBasePage);
    } else if (currentModel is Customer) {
      debugPrint("Current Model Root User ID ${currentModel.rootUserID}");
      ref.read(currentBaseModelState.notifier).changeState(BaseUserModel(
            admin: null,
            customer: currentModel,
            expert: null,
            accountant: null,
            doctor: null,
          ));
      ref.read(currentRole.notifier).changeState(Roles.customer);
      goToLogin(NavigationConstants.customerBasePage);
    } else if (currentModel is Expert) {
      ref.read(currentBaseModelState.notifier).changeState(BaseUserModel(
            admin: null,
            customer: null,
            expert: currentModel,
            accountant: null,
            doctor: null,
          ));
      ref.read(currentRole.notifier).changeState(Roles.expert);
      goToLogin(NavigationConstants.expertBasePage);
    } else if (currentModel is Accountant) {
      ref.read(currentBaseModelState.notifier).changeState(BaseUserModel(
            admin: null,
            customer: null,
            expert: null,
            accountant: currentModel,
            doctor: null,
          ));
      ref.read(currentRole.notifier).changeState(Roles.accountant);
      goToLogin(NavigationConstants.accountantBasePage);
    } else if (currentModel is Doctor) {
      ref.read(currentBaseModelState.notifier).changeState(BaseUserModel(
          admin: null,
          customer: null,
          expert: null,
          accountant: null,
          doctor: currentModel));
      ref.read(currentRole.notifier).changeState(Roles.doctor);
      goToLogin(NavigationConstants.expertBasePage);
    } else {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
    /*Mevcut User'ı doldurduk şimdi onun push notification ayarını yapıyoruz*/

    ref
        .read(currentPushNotificationState.notifier)
        .initializeNotificationState(ref, currentModel.rootUserID);
  }

  void goToLogin(String path) =>
      NavigationService.instance.navigateToPageClear(path: path);

  Future<void> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  Future<void> signIn(String email, String password, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      var resultRole = await _authManager.signIn(email, password);

      if (resultRole != null) {
        _localManager.setEmail(email);
        _localManager.setPassword(password);
      }

      await currentUser(resultRole, ref);
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
