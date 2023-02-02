import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/wait_fix.dart';

import '../../../models/inspection.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../network/database/fb_db_manager.dart';
import '../../network/database/storage_db_base.dart';

class ExpertWorkManager extends StateNotifier<int> {
  ExpertWorkManager(int state) : super(0);
  final fb = FirebaseDbManager();
  final fireStorage = FirebaseStorageService();

  Future<List<Inspection>?> getInspectionList(
      bool inspectionDoneFilter, WidgetRef ref) async {
    try {
      String? userID;
      if (ref.read(currentRole) == Roles.doctor) {
        userID = ref.read(currentBaseModelState).doctor!.rootUserID;
      } else {
        userID = ref.read(currentBaseModelState).expert!.rootUserID;
      }
      return await fb.getInspections(
          inspectionDoneFilter, userID, ref.read(currentRole));
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<List<Inspection>?> getWithQRInspection(
      bool inspectionDoneFilter, String userID, WidgetRef ref) async {
    try {
      return await fb.getInspections(
          inspectionDoneFilter, userID, Roles.customer);
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<void> addWaitFix(WaitFix waitFix, List<File> createLinkFileAndUpdate,
      WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      if (createLinkFileAndUpdate.isNotEmpty) {
        for (var perImageFile in createLinkFileAndUpdate) {
          String? createdPerLink = await fireStorage.getPhotoLink(perImageFile);
          if (createdPerLink != null) {
            waitFix.waitFixPhotos!.add(createdPerLink);
          } else {
            Fluttertoast.showToast(msg: "Bir fotoğrafınız yüklenemedi");
          }
        }
      }
      ref.read(currentInspectionState.notifier).addWaitFix(waitFix);
      await fb.addWaitFix(waitFix);
    } catch (e) {
      debugPrint("$e ADDWAITFIX");
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteWaitFix(WaitFix waitFix, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      return await fb.deleteWaitFix(waitFix).then((value){
        ref.read(currentInspectionState.notifier).removeWaitFix(waitFix);

      });

    } catch (e) {
      debugPrint("$e DELETEWAITFIX");
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> finishInspection(String inspectionID, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.finishInspection(inspectionID);
    } catch (e) {
      debugPrint("$e err");
    } finally {



      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }
}
