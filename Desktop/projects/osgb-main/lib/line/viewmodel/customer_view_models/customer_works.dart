import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/models/search_user.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';

import '../../../models/accident_case.dart';
import '../../../models/inspection.dart';
import '../../../models/worker.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../network/auth/auth_manager.dart';
import '../../network/database/fb_db_manager.dart';
import '../../network/database/storage_db_base.dart';
import '../app_view_models/appBar_managers/custom_flexible_model.dart';
import '../global_providers.dart';

class CustomerWorkManager extends StateNotifier<int> {
  CustomerWorkManager(super.state);

  final fb = FirebaseDbManager();
  final auth = AuthService();
  final fireStorage = FirebaseStorageService();

  Future<void> createWorkerDemand(
      Worker worker, WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loading);
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
  }

  Future<List<Inspection>?> getInspectionList(
      bool inspectionDoneFilter, WidgetRef ref) async {
    try {
      return await fb.getInspections(
          inspectionDoneFilter,
          ref.read(currentBaseModelState).customer!.rootUserID,
          ref.read(currentRole));
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<List<AccidentCase>?> getAccidentCaseList(
      bool inspectionDoneFilter, WidgetRef ref) async {
    try {

      return await fb.getAccidentCases(
          inspectionDoneFilter,
          inspectionDoneFilter ? ref.read(currentBaseModelState).customer!.rootUserID : null,
          ref.read(currentRole));
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<bool> createDemandWorker(
      WidgetRef ref, DemandWorker demandWorker, File? workerPhoto) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      return await fireStorage.getPhotoLink(workerPhoto).then((photoLink) async {
        demandWorker.demandWorker!.photoURL = photoLink;
         return await fb.createDemand(demandWorker).then((value){
           return value;
         });
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> updateWorker(
      WidgetRef ref, Worker worker, File? workerPhotoFile) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      if (workerPhotoFile != null) {
        await fireStorage.getPhotoLink(workerPhotoFile).then((photoLink) async {
          worker.photoURL = photoLink;
        }).then((value) async {
          await fb.updateWorker(worker).then((value) {
            if (value) {
              ref
                  .read(currentCustomFlexibleAppBarState.notifier)
                  .changeContentFlexibleManager(CustomFlexibleModel(
                      header1: "Çalışan Adı",
                      header2: "Görevi",
                      header3: "Telefon",
                      content1: worker.workerName,
                      content2: worker.workerJob,
                      content3: worker.workerPhoneNumber,
                      photoUrl: worker.photoURL,
                      backAppBarTitle: "Çalışan Detay"));
            }
          });
        });
      } else {
        await fb.updateWorker(worker).then((value) {
          if (value) {
            ref
                .read(currentCustomFlexibleAppBarState.notifier)
                .changeContentFlexibleManager(CustomFlexibleModel(
                    header1: "Çalışan Adı",
                    header2: "Görevi",
                    header3: "Telefon",
                    content1: worker.workerName,
                    content2: worker.workerJob,
                    content3: worker.workerPhoneNumber,
                    photoUrl: worker.photoURL,
                    backAppBarTitle: "Çalışan Detay"));
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteWorker(WidgetRef ref, String workerID) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteWorker(workerID);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteCrises(String accidentCaseID, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteCrises(accidentCaseID);
    } catch (e) {
      debugPrint('$e<-ERR');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<bool> createCrises(AccidentCase accidentCase, WidgetRef ref,
      List<File?>? crisesFiles) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      if (crisesFiles != null && crisesFiles.isNotEmpty) {
        var localLinks = <String>[];
        return Future.wait([
          Future.forEach(crisesFiles, (perFile) async {
            await fireStorage.getPhotoLink(perFile).then((link) {
              if (link != null) {
                localLinks.add(link);
              } else {
                Fluttertoast.showToast(msg: "Veri Kaybı Yaşandı");
              }
            });
          })
        ]).then((links) {
          debugPrint("Local Links $localLinks");
          for (var link in localLinks) {
            accidentCase.casePhotos!.add(link);
          }
          debugPrint("Local Links ${accidentCase.casePhotos}");

          return fb.createCrises(accidentCase).then((value) async {
            if (value) {
              NavigationService.instance.navigateToPageClear(
                  path: NavigationConstants.customerBasePage);
            }
            return value;
          });
        });
      } else {
        return await fb.createCrises(accidentCase).then((value) async {
          if (value) {
            NavigationService.instance.navigateToPageClear(
                path: NavigationConstants.customerBasePage);
          }
          return value;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<int> getWorkerCount(String customerID) async {
    return await fb.getWorkerCount(customerID);
  }
}
