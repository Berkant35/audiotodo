import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/custom_functions.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accident_case.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/models/custom_file.dart';
import 'package:osgb/models/customer.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/models/inspection.dart';
import 'package:osgb/models/notification_model.dart';
import 'package:osgb/models/payment.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/models/worker.dart';
import 'package:osgb/models/yearly.dart';
import 'package:osgb/utilities/constants/app/application_constants.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/init/theme/custom_colors.dart';

import '../../../models/admin.dart';
import '../../../models/doctor.dart';
import '../../../models/expert.dart';
import '../../../models/monthly.dart';
import '../../../models/root_user.dart';
import '../../../models/search_user.dart';

part 'fb_db_base.dart';

class FirebaseDbManager extends FirebaseDbBase {
  @override
  Future<dynamic> readUser(String userID) async {
    try {
      DocumentSnapshot? okunanUser =
          await dbBase.collection('users').doc(userID).get();
      return okunanUser.data();
    } catch (e) {
      debugPrint('${e}FirestoreDBService/readUser');
      return null;
    }
  }

  Future<List<Worker>?> getWorkersOfCompany(String companyID) async {
    try {
      var workerList = <Worker>[];

      var snapshot = await dbBase
          .collection("workers")
          .where("workerCompanyID", isEqualTo: companyID)
          .get();

      for (var perWorkerJSON in snapshot.docs) {
        workerList.add(Worker.fromJson(perWorkerJSON.data()));
      }
      return workerList;
    } catch (e) {
      debugPrint("Error 'getDemands' $e ");
      return null;
    }
  }

  Future<List<DemandWorker>?> getDemands() async {
    try {
      var demandList = <DemandWorker>[];

      var snapshot = await dbBase.collection("demand_workers").get();

      for (var perDemandJSON in snapshot.docs) {
        debugPrint(perDemandJSON.data().toString());

        demandList.add(DemandWorker.fromJson(perDemandJSON.data()));
      }

      return demandList;
    } catch (e) {
      debugPrint("Error 'getDemands' $e ");
      return null;
    }
  }

  Future<List<dynamic>> getExpertList() async {
    var expertList = [];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "expert")
        .get();

    for (var expertJSON in snapshot.docs) {
      expertList.add(Expert.fromJson(expertJSON.data()).toJson());
    }
    return expertList;
  }

  Future<List<Customer>> getCustomerList(WidgetRef ref) async {
    var customerList = <Customer>[];
    QuerySnapshot<Map<String, dynamic>> snapshot;

    snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "customer")

        .get();



    for (var expertJSON in snapshot.docs) {
      var perCustomer  =Customer.fromJson(expertJSON.data());
      if(ref.read(currentBaseModelState).expert != null ){
        if(Expert.fromJson(perCustomer.definedExpert).rootUserID == ref.read(currentBaseModelState).expert!.rootUserID){
          customerList.add(perCustomer);
        }
      }else{
        customerList.add(perCustomer);

      }
    }
    return customerList;
  }

  Future<List<dynamic>> getCustomerListWithMap() async {
    var customerList = <dynamic>[];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "customer")
        .get();

    for (var expertJSON in snapshot.docs) {
      customerList.add(Customer.fromJson(expertJSON.data()).toJson());
    }
    return customerList;
  }

  Future<List<dynamic>> getDoctorList() async {
    var doctorList = [];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "doctor")
        .get();

    for (var doctorJSON in snapshot.docs) {
      doctorList.add(Doctor.fromJson(doctorJSON.data()).toJson());
    }

    return doctorList;
  }

  Future<List<Doctor>> getDoctorListWithType() async {
    var doctorList = <Doctor>[];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "doctor")
        .get();

    for (var doctorJSON in snapshot.docs) {
      doctorList.add(Doctor.fromJson(doctorJSON.data()));
    }

    return doctorList;
  }

  Future<List<Expert>> getExpertListWithType() async {
    var expertList = <Expert>[];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "expert")
        .get();

    for (var expertJSON in snapshot.docs) {
      expertList.add(Expert.fromJson(expertJSON.data()));
    }
    return expertList;
  }

  Future<List<Accountant>> getAccountantListWithType() async {
    var accountantList = <Accountant>[];

    var snapshot = await dbBase
        .collection("users")
        .where('typeOfUser', isEqualTo: "accountant")
        .get();

    for (var expertJSON in snapshot.docs) {
      accountantList.add(Accountant.fromJson(expertJSON.data()));
    }

    return accountantList;
  }

  @override
  Future<bool> saveUser(RootUser user, String? userID, String? photoURL,
      Roles role, Admin? currentAdmin, SearchUser searchUser) async {
    try {
      DocumentSnapshot okunanUser = await FirebaseFirestore.instance
          .doc('users/${userID ?? user.rootUserID}')
          .get();

      if (okunanUser.data() == null) {
        return await dbBase
            .collection('users')
            .doc(userID)
            .set(user.toJson())
            .then((value) async {
          return await updateRootUserIDAndPhotoUrl(userID, user, photoURL)
              .then((value) async {
            if (value) {
              return await updateSearchUser(userID, searchUser);
            } else {
              return false;
            }
          });
        });
      } else {
        return true;
      }
    } catch (e) {
      debugPrint("Error: $e");
      Fluttertoast.showToast(msg: "Başarısız!");
      return false;
    }
  }

  Future<bool> updateSearchUser(String? userID, SearchUser searchUser) async {
    try {
      await dbBase
          .collection("search_users")
          .doc(userID)
          .set(searchUser.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateRootUserIDAndPhotoUrl(
      String? userID, RootUser user, String? photoURL) async {
    try {
      await dbBase.collection('users').doc(userID ?? user.rootUserID).update(
          {'rootUserID': userID ?? user.rootUserID, 'photoURL': photoURL});
      return true;
    } catch (e) {
      debugPrint('$e<--Err');
      return false;
    }
  }

  @override
  Future<bool> saveWorker(RootUser user, String? userID, String photoURL,
      Roles role, String? companyName) async {
    try {
      DocumentSnapshot okunanUser = await FirebaseFirestore.instance
          .doc('workers/${userID ?? user.rootUserID}')
          .get();
      if (okunanUser.data() == null) {
        return await dbBase
            .collection('workers')
            .doc(companyName)
            .collection("workersOf$companyName")
            .doc(userID ?? user.rootUserID)
            .set(user.toJson())
            .then((value) {
          return dbBase
              .collection('workers')
              .doc(companyName)
              .collection("workersOf$companyName")
              .doc(userID ?? user.rootUserID)
              .update({
            'rootUserID': userID ?? user.rootUserID,
            'photoURL': photoURL
          }).then((value) {
            Fluttertoast.showToast(msg: "Başarılı!");
            return true;
          });
        });
      } else {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: "Başarısız!");
      return false;
    }
  }

  @override
  Future<bool> createInspection(Inspection inspection) async {
    try {
      return await dbBase
          .collection("inspections")
          .doc(inspection.inspectionID)
          .set(inspection.toJson())
          .then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde denetim oluşturuldu");
        return true;
      });
    } catch (e) {
      debugPrint("createInspectionS $e");
      Fluttertoast.showToast(
          msg: "Bir hata gerçekleşti",
          backgroundColor: CustomColors.errorColor);
      return false;
    }
  }

  @override
  Future<List<Inspection>?> getInspections(
      bool filterIsDone, String? filterUserID, Roles? roles) async {
    try {
      List<Inspection> inspectionList = [];
      QuerySnapshot<Map<String, dynamic>> documentSnapshot;
      if (filterUserID == null) {
        documentSnapshot = await dbBase
            .collection("inspections")
            .where("inspectionIsDone", isEqualTo: filterIsDone)
            .get();
      } else {
        debugPrint(roles.toString());
        documentSnapshot = await dbBase
            .collection("inspections")
            .where("inspectionIsDone", isEqualTo: filterIsDone)
            .where(
                roles == Roles.doctor
                    ? "doctorID"
                    : roles == Roles.customer
                        ? "customerID"
                        : "expertID",
                isEqualTo: filterUserID)
            .get();
      }

      for (var perInspectionJSON in documentSnapshot.docs) {
        var inspection = Inspection.fromJson(perInspectionJSON.data());
        inspectionList.add(inspection);
      }

      return inspectionList;
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Bir hata gerçekleşti",
          backgroundColor: CustomColors.errorColor);
      return [];
    }
  }

  @override
  Future<List<AccidentCase>?> getAccidentCases(
      bool filterIsDone, String? filterUserID, Roles? roles) async {
    try {
      List<AccidentCase> accidentCaseList = [];
      QuerySnapshot<Map<String, dynamic>> documentSnapshot;
      if (filterUserID == null) {
        documentSnapshot = await dbBase.collection("accident_cases").get();
      } else {
        debugPrint(roles.toString());
        documentSnapshot = await dbBase
            .collection("accident_cases")
            .where("caseCompanyID", isEqualTo: filterUserID)
            .get();
      }

      for (var perAccidentCaseJSON in documentSnapshot.docs) {
        var inspection = AccidentCase.fromJson(perAccidentCaseJSON.data());
        accidentCaseList.add(inspection);
      }

      return accidentCaseList;
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Bir hata gerçekleşti",
          backgroundColor: CustomColors.errorColor);
      return [];
    }
  }

  Future<void> finishInspection(String inspectionID) async {
    try {
      await dbBase
          .collection("inspections")
          .doc(inspectionID)
          .update({"inspectionIsDone": true}).then((value) {
        Fluttertoast.showToast(msg: "Denetim Kaydedildi!");
      });
    } catch (e) {
      debugPrint('$e<-err');
    }
  }

  Future<void> addWaitFix(WaitFix waitFix) async {
    try {
      await dbBase
          .collection("wait_fixs")
          .doc(waitFix.waitFixID)
          .set(waitFix.toJson())
          .then((value) async {
        await dbBase
            .collection("inspections")
            .doc(waitFix.waitFixInspectionID)
            .update({
          "waitFixList": FieldValue.arrayUnion([waitFix.toJson()]),
          CustomFunctions.getKeyForDangerInspections(waitFix.waitFixDegree!):
              FieldValue.increment(1)
        }).then((value) {
          Fluttertoast.showToast(msg: "Yeni durum eklenildi");
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Bir hata gerçekleşti",
          backgroundColor: CustomColors.errorColor);
    }
  }

  Future<bool> updateCustomer(Customer customer) async {
    try {
      return await dbBase
          .collection("users")
          .doc(customer.rootUserID)
          .update(customer.toJson())
          .then((value) {
        return true;
      }).then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde güncellendi");
        return true;
      });
    } catch (e) {
      debugPrint("Firebase error ->$e");
      Fluttertoast.showToast(msg: "Güncellenirken bir hata oluştu!");
      return false;
    }
  }

  Future<bool> updateWorker(Worker worker) async {
    try {
      return await dbBase
          .collection("workers")
          .doc(worker.rootUserID)
          .update(worker.toJson())
          .then((value) {
        return true;
      }).then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde güncellendi");
        return true;
      });
    } catch (e) {
      debugPrint("Firebase error ->$e");
      Fluttertoast.showToast(msg: "Güncellenirken bir hata oluştu!");
      return false;
    }
  }

  Future<void> deleteWorker(String workerID) async {
    try {
      await dbBase
          .collection("workers")
          .doc(workerID)
          .delete()
          .then((value) async {
        await dbBase
            .collection("search_users")
            .doc(workerID)
            .delete()
            .then((value) {
          Fluttertoast.showToast(msg: "Başarılı bir şekilde silindi");
        });
      });
    } catch (e) {
      debugPrint("Firebase error ->$e");
      Fluttertoast.showToast(msg: "Silme işlemi yapılırken bir hata oluştu!");
    }
  }

  @override
  Future<bool> createDemand(DemandWorker demandWorker) async {
    try {
      var json = {
        "demandID": demandWorker.demandID,
        "demandWorker": demandWorker.demandWorker!.toJson(),
        "demandByCustomer": demandWorker.demandByCustomer!.toJson(),
      };
      debugPrint("Problem: $json");

      return await dbBase
          .collection("demand_workers")
          .doc(demandWorker.demandID)
          .set(json)
          .then((value) {
        Fluttertoast.showToast(msg: "Çalışan talebi oluşturuldu");
        return true;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Bir şeyler ters gitti!");
      debugPrint("Create Demand Error: $e");
      return false;
    }
  }

  Future<void> deleteWaitFix(WaitFix waitFix) async {
    try {
      await dbBase
          .collection("wait_fixs")
          .doc(waitFix.waitFixID)
          .delete()
          .then((value) async {
        await dbBase
            .collection("inspections")
            .doc(waitFix.waitFixInspectionID)
            .update({
          "waitFixList": FieldValue.arrayRemove([waitFix.toJson()]),
          CustomFunctions.getKeyForDangerInspections(waitFix.waitFixDegree!):
              FieldValue.increment(-1)
        }).then((value) {
          Fluttertoast.showToast(msg: "Durum Silindi");
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Bir hata gerçekleşti",
          backgroundColor: CustomColors.errorColor);
    }
  }

  Future<bool> deleteDemand(String demandID) async {
    try {
      return await dbBase
          .collection("demand_workers")
          .doc(demandID)
          .delete()
          .then((value) {
        return true;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> confirmDemand(DemandWorker demandWorker) async {
    try {
      debugPrint("Confirmed Demand oluyor mu aq ${demandWorker.toJson().toString()}");
      var result = await dbBase
          .collection("workers")
          .doc(demandWorker.demandWorker!.rootUserID)
          .set(demandWorker.demandWorker!.toJson())
          .then((value) async {
        debugPrint("Confirmed Demand oluyor mu aq1");
        return await dbBase
            .collection("users")
            .doc(demandWorker.demandWorker!.rootUserID)
            .set(demandWorker.demandWorker!.toJson())
            .then((value) async {
          debugPrint("Confirmed Demand oluyor mu aq2");
          return await dbBase
              .collection("demand_workers")
              .doc(demandWorker.demandID)
              .delete()
              .then((value) async {

              debugPrint("Confirmed Demand oluyor mu aq4");
              return await dbBase
                  .collection("search_users")
                  .doc(demandWorker.demandWorker!.rootUserID)
                  .set(SearchUser(
                  typeOfUser: "worker",
                  rootUserID: demandWorker.demandWorker!.rootUserID,
                  role: "worker",
                  userName: demandWorker.demandWorker!.workerName)
                  .toJson())
                  .then((value) {
                debugPrint("Confirmed Demand oluyor mu aq5 ");

                Fluttertoast.showToast(msg: "Başarılı");
                return true;
              });
            });
          });
        });

      debugPrint("Service Result $result");
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> createCrises(AccidentCase accidentCase) async {
    try {
      return await dbBase
          .collection("accident_cases")
          .doc(accidentCase.caseID)
          .set(accidentCase.toJson())
          .then((value) {
        Fluttertoast.showToast(msg: "Yeni Bir Olay Oluşturuldu");
        return true;
      });
    } catch (e) {
      debugPrint('$e<-ERR');
      return false;
    }
  }

  @override
  Future<bool> deleteCrises(String accidentCaseID) async {
    return await dbBase
        .collection("accident_cases")
        .doc(accidentCaseID)
        .delete()
        .then((value) {
      Fluttertoast.showToast(msg: "Olay Başarılı Bir Şekilde Silindi");
      return true;
    });
  }

  @override
  Future<bool> updateExpert(Expert updateExpert) async {
    return await dbBase
        .collection("users")
        .doc(updateExpert.rootUserID)
        .update(updateExpert.toJson())
        .then((value) {
      Fluttertoast.showToast(
          msg: "Güncelleme işlemi gerçekleştirildi",
          toastLength: Toast.LENGTH_LONG);
      return true;
    });
  }

  Future<void> deleteExpert(String? rootUserID) async {
    await dbBase
        .collection("users")
        .doc(rootUserID)
        .delete()
        .then((value) async {
      await dbBase
          .collection("search_users")
          .doc(rootUserID)
          .delete()
          .then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde silindi");
      });
    });
  }

  @override
  Future<void> deleteDoctor(String rootUserID) async {
    await dbBase
        .collection("users")
        .doc(rootUserID)
        .delete()
        .then((value) async {
      await dbBase
          .collection("search_users")
          .doc(rootUserID)
          .delete()
          .then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde silindi");
      });
    });
  }

  @override
  Future<bool> updateDoctor(Doctor updateDoctor) async {
    return await dbBase
        .collection("users")
        .doc(updateDoctor.rootUserID)
        .update(updateDoctor.toJson())
        .then((value) {
      Fluttertoast.showToast(
          msg: "Güncelleme işlemi gerçekleştirildi",
          toastLength: Toast.LENGTH_LONG);
      return true;
    });
  }

  Future<bool> updateAccountant(Accountant accountant) async {
    return await dbBase
        .collection("users")
        .doc(accountant.rootUserID)
        .update(accountant.toJson())
        .then((value) {
      Fluttertoast.showToast(
          msg: "Güncelleme işlemi gerçekleştirildi",
          toastLength: Toast.LENGTH_LONG);
      return true;
    });
  }

  Future<bool> deleteAccountant(String accountantID) async {
    return await dbBase
        .collection("users")
        .doc(accountantID)
        .delete()
        .then((value) async {
      await dbBase
          .collection("search_users")
          .doc(accountantID)
          .delete()
          .then((value) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde silindi");
      });
      return true;
    });
  }

  @override
  Future<List<SearchUser>> getSearchUsers() async {
    try {
      var searchUserList = <SearchUser>[];

      var snapshot = await dbBase
          .collection("search_users")
          .where("typeOfUser", isNotEqualTo: "Admin")
          .get();

      for (var perWorkerJSON in snapshot.docs) {
        searchUserList.add(SearchUser.fromJson(perWorkerJSON.data()));
      }
      return searchUserList;
    } catch (e) {
      debugPrint("Error 'getDemands' $e ");
      return [];
    }
  }

  Future<bool> createPaymentTable(Payment payment) async {
    try {
      return await dbBase
          .collection("payments")
          .doc(payment.customerID)
          .set(payment.toJson())
          .then((value) {
        debugPrint("Success ${payment.toJson()}");

        return true;
      });
    } catch (e) {
      debugPrint("create payment table err: $e");
      return false;
    }
  }

  Future<Payment?> getPayment(String customerID) async {
    try {
      return await dbBase
          .collection("payments")
          .doc(customerID)
          .get()
          .then((value) {
        var payment = Payment.fromJson(value.data()!);
        return payment;
      });
    } catch (e) {
      debugPrint("Error(getPayment) $e");
      return null;
    }
  }

  Future<bool> addDateToPayment(String customerID, Yearly yearly) async {
    try {
      return await dbBase.collection("payments").doc(customerID).update({
        "paymentYearList": FieldValue.arrayUnion([yearly.toJson()])
      }).then((value) {
        return true;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> updatePaymentYear(
      List<dynamic> yearlyList, String customerID) async {
    try {
      return await dbBase
          .collection("payments")
          .doc(customerID)
          .update({"paymentYearList": yearlyList});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> sendPush(NotificationModel notificationModel) async {
    try {
      debugPrint('${notificationModel.toJson()}<-JSON');
      Dio dio = Dio(BaseOptions(
          baseUrl: ApplicationConstants.firebaseNotificationBaseUrl,
          headers: {
            "Authorization":
                ApplicationConstants.firebaseCloudMessagingServerKey
          }));

      var response = await dio.post(
        ApplicationConstants.firebaseNotificationBaseUrl,
        data: {
          "to": notificationModel.to,
          "priority": notificationModel.priority,
          "notification": {
            "title": notificationModel.notification!.title,
            "body": notificationModel.notification!.body,
            "sound": "default"
          }
        },
      );

      debugPrint('${response.data}<-Res');
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.message);
        debugPrint(e.response.toString());
      } else {
        debugPrint('$e<-err');
      }
    }
  }

  @override
  Future<void> updatePushToken(String pushToken, String rootUserID) async {
    await dbBase
        .collection("users")
        .doc(rootUserID)
        .update({"pushToken": pushToken});
  }

  Future<Admin?> getAdmin() async {
    return await dbBase
        .collection("users")
        .where("typeOfUser", isEqualTo: "admin")
        .get()
        .then((value) {
      var admin = Admin.fromJson(value.docs.first.data());
      return admin;
    });
  }

  Future<Expert> getExpert(String rootUserID) async {
    return await dbBase.collection("users").doc(rootUserID).get().then((value) {
      var expert = Expert.fromJson(value.data()!);
      return expert;
    });
  }

  @override
  Future<List<CustomFile>> getFileListOfCustomer(String rootUserID) async {
    try {
      List<CustomFile> customFileList = [];
      debugPrint("List ");

      var snapshot = await dbBase
          .collection("files")
          .where("customerID", isEqualTo: rootUserID)
          .get();

      for (var perFileJson in snapshot.docs) {
        customFileList.add(CustomFile.fromJson(perFileJson.data()));
      }

      return customFileList;
    } catch (e) {
      debugPrint("Error 'getDemands' $e ");
      return [];
    }
  }

  @override
  Future<bool> uploadFileToCustomer(CustomFile customFile) async {
    try {
      return await dbBase
          .collection("files")
          .doc(customFile.fileID)
          .set(customFile.toJson()).then((value){
            return true;
      });
    } catch (e) {
      debugPrint("Error 'uploadFileToCustomer' $e ");
      return false;
    }
  }

  Future<int> getWorkerCount(String customerID) async {

    try{
      return await dbBase
          .collection("workers")
          .where("workerCompanyID" ,isEqualTo: customerID)
          .get().then((value){
            return value.docs.length;
      });
    }catch(e){
      debugPrint('$e<-err');
      return 0;
    }
  }

  Future<Customer?> getCustomer(String rootUserID) async {
    try{
      return await dbBase
          .collection("users")
          .doc(rootUserID)
          .get().then((value){
        return Customer.fromJson(value.data()!);
      });
    }catch(e){
      debugPrint('$e<-err');
      return null;
    }
  }


}
