import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/network/auth/auth_manager.dart';
import 'package:osgb/line/network/database/fb_db_manager.dart';
import 'package:osgb/line/network/database/storage_db_base.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/models/customer.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/models/inspection.dart';
import 'package:osgb/models/worker.dart';
import 'package:osgb/ui/details/customer/customer_details.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

import '../../../models/payment.dart';
import '../../../models/search_user.dart';
import '../../../ui/details/accountant/accountant_detail.dart';
import '../../../ui/details/customer/customer_tab_views/workers/worker_detail.dart';
import '../../../ui/details/expert/common_doctor_detail.dart';
import '../../../ui/details/expert/common_expert_detail.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/navigation/navigation_service.dart';

class AdminWorkManager extends StateNotifier<int> {
  AdminWorkManager(int state) : super(0);
  final fb = FirebaseDbManager();
  final fireStorage = FirebaseStorageService();
  final auth = AuthService();

  Future<void> createCustomer(Customer customer, WidgetRef ref,
      File? localPathOfPath, Roles role) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        await auth
            .createUserWithEmailAndPassword(
                customer.email!,
                customer.password!,
                onlinePhotoLink,
                role,
                SearchUser(
                    userName: customer.customerName,
                    role: "Müşteri",
                    rootUserID: customer.rootUserID,
                    typeOfUser: customer.typeOfUser))
            .then((userCredential) async {
          await fireStorage
              .createQRLink(userCredential!.uid, customer.customerName!)
              .then((qrPhotoLink) async {
            customer.qrCodeURL = qrPhotoLink;
            await fb
                .saveUser(
                    customer,
                    userCredential.uid,
                    onlinePhotoLink,
                    role,
                    ref.read(currentBaseModelState).admin,
                    SearchUser(
                        userName: customer.customerName,
                        role: "Müşteri",
                        rootUserID: userCredential.uid,
                        typeOfUser: customer.typeOfUser))
                .then((accepted) {
              ref
                  .read(currentAccountantManagerState.notifier)
                  .createPayment(userCredential.uid)
                  .then((value) {
                ref
                    .read(currentAdminDashboardTabManager.notifier)
                    .changeState(0);
                Fluttertoast.showToast(
                    msg: accepted ? "Başarılı!" : "Başarısız");
                NavigationService.instance
                    .navigateToPage(path: NavigationConstants.adminBasePage);
              });
            });
          });
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> createDoctor(Doctor doctor, String email, String password,
      WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        await auth
            .createUserWithEmailAndPassword(
                email,
                password,
                onlinePhotoLink,
                role,
                SearchUser(
                    userName: doctor.doctorName,
                    role: "Hekim",
                    rootUserID: doctor.rootUserID,
                    typeOfUser: doctor.typeOfUser))
            .then((value) async {
          return await Future.delayed(const Duration(seconds: 1), () {
            return fb.saveUser(
                doctor,
                value!.uid,
                onlinePhotoLink,
                role,
                ref.read(currentBaseModelState).admin,
                SearchUser(
                    userName: doctor.doctorName,
                    role: "Hekim",
                    rootUserID: value.uid,
                    typeOfUser: doctor.typeOfUser));
          });
        }).then((value) {
          debugPrint(value.toString() + '<-');
          if (value) {
            ref.read(currentAdminDashboardTabManager.notifier).changeState(2);
            NavigationService.instance
                .navigateToPage(path: NavigationConstants.adminBasePage);
          }
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
  }

  Future<void> createAccountant(Accountant accountant, String email,
      String password, WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        await auth
            .createUserWithEmailAndPassword(
                email,
                password,
                onlinePhotoLink,
                role,
                SearchUser(
                    userName: accountant.accountantName,
                    role: "Muhasebeci",
                    rootUserID: accountant.rootUserID,
                    typeOfUser: accountant.typeOfUser))
            .then((value) {
          return Future.delayed(const Duration(seconds: 1), () async {
            await fb
                .saveUser(
                    accountant,
                    value!.uid,
                    onlinePhotoLink,
                    role,
                    ref.read(currentBaseModelState).admin,
                    SearchUser(
                        userName: accountant.accountantName,
                        role: "Muhasebeci",
                        rootUserID: value.uid,
                        typeOfUser: accountant.typeOfUser))
                .then((value) {
              if (value) {
                ref
                    .read(currentAdminDashboardTabManager.notifier)
                    .changeState(3);
                NavigationService.instance
                    .navigateToPage(path: NavigationConstants.adminBasePage);
                Fluttertoast.showToast(msg: "Başarılı!");
              }
            });
          });
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  int milliseconds() => 2000;

  Future<void> updateExpert(
      Expert expert, WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        expert.photoURL = onlinePhotoLink ?? expert.photoURL;

        await fb.updateExpert(expert).then((value) {
          ref
              .read(currentCustomFlexibleAppBarState.notifier)
              .changeContentFlexibleManager(CustomFlexibleModel(
                  header1: "Uzman Adı",
                  header2: "Uzmanlık",
                  header3: "E-Mail",
                  content1: expert.expertName ?? "-",
                  content2: expert.expertMaster,
                  content3: expert.expertMail,
                  backAppBarTitle: "Uzman Detay",
                  photoUrl: expert.photoURL));
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
      Fluttertoast.showToast(
          msg: "Güncelleme işlemi gerçekleştirirken bir hata meydana geldi",
          toastLength: Toast.LENGTH_LONG);
    } finally {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
  }

  Future<void> createExpert(Expert expert, String email, String password,
      WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        debugPrint("Get Photo Link after $onlinePhotoLink");

        await auth
            .createUserWithEmailAndPassword(
                email,
                password,
                onlinePhotoLink,
                role,
                SearchUser(
                    userName: expert.expertName,
                    role: "Uzman",
                    rootUserID: expert.rootUserID,
                    typeOfUser: expert.typeOfUser))
            .then((value) async {
          return await Future.delayed(const Duration(seconds: 1), () async {
            return await fb
                .saveUser(
                    expert,
                    value!.uid,
                    onlinePhotoLink,
                    role,
                    ref.read(currentBaseModelState).admin,
                    SearchUser(
                        userName: expert.expertName,
                        role: "Uzman",
                        rootUserID: value.uid,
                        typeOfUser: expert.typeOfUser))
                .then((value) {
              if (value) {
                ref
                    .read(currentAdminDashboardTabManager.notifier)
                    .changeState(1);
                NavigationService.instance
                    .navigateToPage(path: NavigationConstants.adminBasePage);
                Fluttertoast.showToast(msg: "Başarılı!");
              }
            });
          });
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    }
  }

  Future<List<dynamic>> getExpertList(WidgetRef ref) async {
    try {
      return await fb.getExpertList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Customer>> getCustomerList(WidgetRef ref,{String? expertId,String? doctorId}) async {
    try {
      return await fb.getCustomerList(ref,expertId:expertId,doctorId: doctorId);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCustomerListWithMap(WidgetRef ref) async {
    try {
      if (ref.read(currentRole) == Roles.expert) {
        return await fb.getCustomerListWithMap(
            ref.read(currentBaseModelState).expert!.rootUserID!,
            ref.read(currentRole));
      } else if (ref.read(currentRole) == Roles.doctor) {
        return await fb.getCustomerListWithMap(
            ref.read(currentBaseModelState).doctor!.rootUserID!,
            ref.read(currentRole));
      } else {
        return await fb.getCustomerListWithMap(
            ref.read(currentBaseModelState).admin!.rootUserID!,
            ref.read(currentRole));
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Expert>> getExpertListWithType(WidgetRef ref) async {
    try {
      return await fb.getExpertListWithType();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Accountant>> getAccountantListWithType(WidgetRef ref) async {
    try {
      return await fb.getAccountantListWithType();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Doctor>> getDoctorListWithType(WidgetRef ref) async {
    try {
      return await fb.getDoctorListWithType();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getDoctorList(WidgetRef ref) async {
    try {
      return await fb.getDoctorList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<dynamic> getRoleUser(String userID) async {
    try {
      return await auth.getUser(userID);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> createInspection(WidgetRef ref, Inspection inspection) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      return await fb.createInspection(inspection);
    } catch (e) {
      debugPrint("createInspection $e");
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
      return false;
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<List<Inspection>?> getInspectionList(
    bool inspectionDoneFilter,
  ) async {
    try {
      return await fb.getInspections(inspectionDoneFilter, null, null);
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }


  Future<List<DemandWorker>?> getDemands() async {
    try {
      return await fb.getDemands();
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<List<Worker>?> getWorkersOfCompany(String companyID) async {
    try {
      return await fb.getWorkersOfCompany(companyID);
    } catch (e) {
      debugPrint('$e<-ERR');
      return [];
    }
  }

  Future<bool> updateCustomer(Customer customer, WidgetRef ref,
      File? localPhoto, bool needUpdateEmail, String? email) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      return await fireStorage
          .getPhotoLink(localPhoto)
          .then((onlinePhotoLink) async {
        if (onlinePhotoLink != "" && onlinePhotoLink != null) {
          customer.photoURL = onlinePhotoLink;
        }

        return await fb.updateCustomer(customer).then((value) {
          if (value) {
            ref
                .read(currentCustomFlexibleAppBarState.notifier)
                .changeContentFlexibleManager(CustomFlexibleModel(
                header1: "İş Yeri",
                content1: customer.customerName,
                header2: "Tehlike Durumu",
                content2: customer.dangerLevel,
                header3: "E-Mail",
                content3: customer.email,
                photoUrl: customer.photoURL,
                backAppBarTitle: "İş Yeri Detay"));
          }
          return value;
        });
      });
    } catch (e) {
      return false;
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteWorkDemand(String demandID, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteDemand(demandID).then((value) {
        ref.read(currentAddUserIndexState.notifier).changeState(0);
        ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.adminBasePage);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<bool> confirmWorkDemand(
      DemandWorker demandWorker, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      demandWorker.demandWorker!.isAcceptedByAdmin = true;
      return await fb.confirmDemand(demandWorker);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      ref.read(currentAddUserIndexState.notifier).changeState(0);
      ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
      NavigationService.instance
          .navigateToPageClear(path: NavigationConstants.adminBasePage);
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteExpert(
      String? rootUserID, WidgetRef ref, Roles roles) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteExpert(rootUserID).then((value) {
        ref
            .read(currentAdminDashboardTabManager.notifier)
            .changeState(roles == Roles.expert ? 1 : 2);
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.adminBasePage);
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteDoctor(String? rootUserID, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteDoctor(rootUserID!).then((value) {
        ref.read(currentAdminDashboardTabManager.notifier).changeState(2);
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.adminBasePage);
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> updateDoctor(
      Doctor doctor, WidgetRef ref, File? localPathOfPath, Roles role) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(localPathOfPath)
          .then((onlinePhotoLink) async {
        doctor.photoURL = onlinePhotoLink ?? doctor.photoURL;

        await fb.updateDoctor(doctor).then((value) {
          ref
              .read(currentCustomFlexibleAppBarState.notifier)
              .changeContentFlexibleManager(CustomFlexibleModel(
                  header1: "Hekim Adı",
                  header2: "Telefon",
                  header3: "E-Mail",
                  content1: doctor.doctorName ?? "-",
                  content2: doctor.doctorPhoneNumber,
                  content3: doctor.doctorMail,
                  backAppBarTitle: "Hekim Detay",
                  photoUrl: doctor.photoURL));
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
      Fluttertoast.showToast(
          msg: "Bir şeyler ters gitti", toastLength: Toast.LENGTH_LONG);
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> updateAccountant(Accountant accountant, WidgetRef ref,
      File? accountantPhotoFile, Roles role) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      await fireStorage
          .getPhotoLink(accountantPhotoFile)
          .then((onlinePhotoLink) async {
        accountant.photoURL = onlinePhotoLink ?? accountant.photoURL;

        await fb.updateAccountant(accountant).then((value) {
          ref
              .read(currentCustomFlexibleAppBarState.notifier)
              .changeContentFlexibleManager(CustomFlexibleModel(
                  header1: "Muhasebeci Adı",
                  header2: "Telefon",
                  header3: "E-Mail",
                  content1: accountant.accountantName ?? "-",
                  content2: accountant.accountantPhoneNumber,
                  content3: accountant.accountantEmail,
                  backAppBarTitle: "Muhasebeci Detay",
                  photoUrl: accountant.photoURL));
        });
      });
    } catch (e) {
      debugPrint('$e<-err');
      Fluttertoast.showToast(
          msg: "Güncelleme işlemi gerçekleştirirken bir hata meydana geldi",
          toastLength: Toast.LENGTH_LONG);
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteAccountant(String? rootUserID, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteAccountant(rootUserID!).then((value) {
        ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.adminBasePage);
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<void> deleteCustomer(String? rootUserID,WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      await fb.deleteCustomer(rootUserID!).then((value) {
        ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.adminBasePage);
      });
    } catch (e) {
      debugPrint('$e<-err');
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }


  Future<List<SearchUser>> getSearchUsers() async {
    try {
      return await fb.getSearchUsers();
    } catch (e) {
      debugPrint("Error 'getDemands' $e ");
      return [];
    }
  }

  Future<void> getUserAndThenGoDetail(
      String rootUserID, BuildContext context, WidgetRef ref) async {
    await getRoleUser(rootUserID).then((value) {
      debugPrint("View Model ${value.toString()}");

      if (value is Customer) {
        ref
            .read(currentCustomFlexibleAppBarState.notifier)
            .changeContentFlexibleManager(CustomFlexibleModel(
              header1: "İş Yeri",
              content1: value.customerName,
              header2: "Tehlike Durumu",
              content2: value.dangerLevel,
              header3: "Sektör",
              content3: value.customerSector,
              photoUrl: value.photoURL,
              backAppBarTitle: "İş Yeri Detay",
            ));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CustomerDetails(
                  customer: value,
                  onSaved: (value) => debugPrint("Value$value"),
                )));
      } else if (value is Worker) {
        ref
            .read(currentCustomFlexibleAppBarState.notifier)
            .changeContentFlexibleManager(CustomFlexibleModel(
                header1: "Çalışan Adı",
                header2: "Görevi",
                header3: "Telefon",
                content1: value.workerName,
                content2: value.workerJob,
                content3: value.workerPhoneNumber,
                photoUrl: value.photoURL,
                backAppBarTitle: "Çalışan Detay"));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WorkerDetail(worker: value)));
      } else if (value is Expert) {
        ref
            .read(currentCustomFlexibleAppBarState.notifier)
            .changeContentFlexibleManager(CustomFlexibleModel(
                header1: "Uzman Adı",
                header2: "Uzmanlık",
                header3: "E-Mail",
                content1: value.expertName ?? "-",
                content2: value.expertMaster,
                content3: value.expertMail,
                backAppBarTitle: "Uzman Detay",
                photoUrl: value.photoURL));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommonExpertDetail(expert: value)));
      } else if (value is Doctor) {
        ref
            .read(currentCustomFlexibleAppBarState.notifier)
            .changeContentFlexibleManager(CustomFlexibleModel(
                header1: "Hekim Adı",
                header2: "Telefon",
                header3: "E-Mail",
                content1: value.doctorName ?? "-",
                content2: value.doctorPhoneNumber,
                content3: value.doctorMail,
                backAppBarTitle: "Hekim Detay",
                photoUrl: value.photoURL));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommonDoctorDetail(doctor: value)));
      } else if (value is Accountant) {
        ref
            .read(currentCustomFlexibleAppBarState.notifier)
            .changeContentFlexibleManager(CustomFlexibleModel(
                header1: "Muhasebeci Adı",
                header2: "Telefon",
                header3: "E-Mail",
                content1: value.accountantName ?? "-",
                content2: value.accountantPhoneNumber,
                content3: value.accountantEmail,
                backAppBarTitle: "Muhasebeci Detay",
                photoUrl: value.photoURL));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountantDetail(accountant: value)));
      } else {
        Fluttertoast.showToast(msg: "Bir şeyler ters gitti");
      }
    });
  }
}
