import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanoid/async.dart';
import 'package:ntp/ntp.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../line/viewmodel/global_providers.dart';
import '../../../models/customer.dart';
import '../../../models/doctor.dart';
import '../../../models/expert.dart';
import '../../../models/inspection.dart';
import '../../../models/notification_model.dart';
import '../../../utilities/components/custom_card.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class ExpertMissions extends ConsumerStatefulWidget {
  const ExpertMissions({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExpertMissionsState();
}

class _ExpertMissionsState extends ConsumerState<ExpertMissions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Icon(
                Icons.qr_code_2,
                size: 25.h,
              ),
            ),
            Center(
              child: CustomElevatedButton(
                onPressed: () async {
                  try {
                    String barcodeScanRes =
                        await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "Çıkış", false, ScanMode.QR);

                    await ref
                        .read(currentExpertWorksState.notifier)
                        .getWithQRInspection(false, barcodeScanRes, ref)
                        .then((value) async {
                      if (value != null && value.isNotEmpty) {
                        Customer? customer = await ref
                            .read(currentBaseModelState.notifier)
                            .getCustomer(value.first.customerID!);
                        ref
                            .read(currentCustomFlexibleAppBarState.notifier)
                            .changeContentFlexibleManager(CustomFlexibleModel(
                                header1: "Şirket Adı",
                                header2:
                                    "Uzman${value.first.doctorName != null ? "/Hekim" : ""}",
                                header3: "Tarih",
                                header5: "Tehlike Durumu",
                                header4: "Sicil No",
                                content1: value.first.customerName!,
                                content2:
                                    "${value.first.expertName!}${value.first.doctorName != null ? "/${value.first.doctorName}" : ""}",
                                content3: value.first.inspectionDate!
                                    .substring(0, 16),
                                content4: customer!.companyDetectNumber!,
                                content5: value.first.dangerLevelOfCustomer!,
                                photoUrl: value.first.customerPhotoURL,
                                backAppBarTitle: "Denetimi Gerçekleştir"));
                        ref
                            .read(currentInspectionState.notifier)
                            .changeCurrentInspection(value.first);
                        NavigationService.instance.navigateToPage(
                            path: NavigationConstants.doAuditPage);
                      } else {
                        ref
                            .read(currentCustomerWorksState.notifier)
                            .fb
                            .dbBase
                            .collection("users")
                            .doc(barcodeScanRes)
                            .get()
                            .then((value) async {
                          if (value.data() != null) {
                            var customer = Customer.fromJson(value.data()!);
                            var expert =
                                Expert.fromJson(customer.definedExpert);
                            var doctor = customer.definedDoctor != null
                                ? Doctor.fromJson(customer.definedDoctor)
                                : null;

                            int workerCount = await ref
                                .read(currentCustomerWorksState.notifier)
                                .getWorkerCount(customer.rootUserID!);

                            if ((ref.read(currentRole) == Roles.expert &&
                                    ref
                                            .read(currentBaseModelState)
                                            .expert!
                                            .rootUserID ==
                                        expert.rootUserID) ||
                                (ref.read(currentRole) == Roles.doctor &&
                                    ref.read(currentBaseModelState).doctor !=
                                        null &&
                                    ref
                                            .read(currentBaseModelState)
                                            .doctor!
                                            .rootUserID ==
                                        doctor?.rootUserID)) {
                              var uniqueID = await nanoid();
                              var dateTime = await NTP.now();
                              var newInspection = Inspection(
                                inspectionID: uniqueID,
                                customerID: customer.rootUserID,
                                doctorID: doctor?.rootUserID,
                                expertID: expert.rootUserID,
                                inspectionDate: dateTime.toString(),
                                doctorName: doctor?.doctorName,
                                customerName: customer.customerName,
                                createdDate: DateTime.now().toString().substring(0,16),
                                updatedDate: DateTime.now().toString().substring(0,16),
                                inspectionTitle:
                                    "${ref.read(currentRole) == Roles.expert ? ref.read(currentBaseModelState).expert!.expertName : ref.read(currentBaseModelState).doctor!.doctorName}",
                                customerPhotoURL: customer.photoURL,
                                lowDanger: 0,
                                normalDanger: 0,
                                highDanger: 0,
                                expertName:
                                    Expert.fromJson(customer.definedExpert)
                                        .expertName,
                                inspectionExplain:
                                    "${customer.customerName} şirketine "
                                    "${ref.read(currentRole) == Roles.expert ? ref.read(currentBaseModelState).expert!.expertName : ref.read(currentBaseModelState).doctor!.doctorName}"
                                    " tarafından denetim gerçekleşimi",
                                inspectionIsStarted: true,
                                currentHasMustFixCount: 0,
                                waitFixList: [],
                                inspectionIsDone: false,
                                customerPresentationName:
                                    customer.representativePerson,
                                customerAddress: customer.customerAddress,
                                customerSector: customer.customerSector,
                                dangerLevelOfCustomer: customer.dangerLevel,
                                workerCount: workerCount,
                              );

                              ref
                                  .read(
                                      currentCustomFlexibleAppBarState.notifier)
                                  .changeContentFlexibleManager(CustomFlexibleModel(
                                      header1: "Şirket Adı",
                                      header2:
                                          "Uzman${newInspection.doctorName != null ? "/Hekim" : ""}",
                                      header3: "Tarih",
                                      header4: "Sicil No",
                                      content1: newInspection.customerName!,
                                      content2:
                                          "${newInspection.expertName!}${newInspection.doctorName != null ? "/${newInspection.doctorName}" : ""}",
                                      content3: newInspection.inspectionDate!
                                          .substring(0, 16),
                                      content4: customer.companyDetectNumber,
                                      header5: "Tehlike Sınıfı",
                                      content5:
                                          newInspection.dangerLevelOfCustomer,
                                      photoUrl: newInspection.customerPhotoURL,
                                      backAppBarTitle:
                                          "Denetimi Gerçekleştir"));

                              ref
                                  .read(currentInspectionState.notifier)
                                  .changeCurrentInspection(newInspection);

                              ref
                                  .read(currentAdminWorksState.notifier)
                                  .createInspection(ref, newInspection)
                                  .then((value) {
                                if (value) {
                                  ref
                                      .read(
                                          currentPushNotificationState.notifier)
                                      .sendPush(NotificationModel(
                                          to: customer.pushToken!,
                                          priority: "high",
                                          notification: CustomNotification(
                                              title: "Denetim Oluşturuldu",
                                              body:
                                                  " Su Osgb ${ref.read(currentRole) == Roles.doctor ? "iş güvenliği hekimi ${ref.read(currentBaseModelState).doctor?.doctorName}" : "iş güvenliği uzmanı ${ref.read(currentBaseModelState).expert!.expertName}"} şu anda işletmenizi ziyaret etmektedir.")));
                                }
                                NavigationService.instance.navigateToPage(
                                    path: NavigationConstants.doAuditPage);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Tanımlı müşterinin uzmanlarından birsi değilsiniz!");
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "İşlem gereçekleştirilemedi");
                          }
                        });
                      }
                    });
                  } on Exception catch (e) {
                    debugPrint('err->- $e -<-err');
                  }
                },
                inButtonText: "QR İle Tara",
                primaryColor: CustomColors.secondaryColorM,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.h, top: 2.h),
              child: Text(
                "Bekleyen Görevleriniz",
                style: ThemeValueExtension.subtitle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )),
        customFutureBuilder(),
      ],
    );
  }

  Expanded customFutureBuilder() {
    return Expanded(
        child: Padding(
      padding: seperatePadding(),
      child: SingleChildScrollView(
        child: FutureBuilder<List<Inspection>?>(
            future: ref
                .read(currentExpertWorksState.notifier)
                .getInspectionList(false, ref),
            builder: (context, snapshot) {
              var list = snapshot.data;
              return snapshot.connectionState == ConnectionState.done
                  ? list!.isNotEmpty
                      ? Column(
                          children: [
                            ListView.builder(
                                itemCount: list.length,
                                itemExtent: 15.h,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var perInspection = list[index];
                                  return Padding(
                                    padding: EdgeInsets.all(1.h),
                                    child: CustomCard(
                                        networkImage:
                                            perInspection.customerPhotoURL,
                                        header1: "Şirket Adı",
                                        content1: perInspection.customerName!,
                                        header2:
                                            "Uzman${perInspection.doctorName != null ? "/Hekim" : ""}",
                                        content2:
                                            "${perInspection.expertName!}${perInspection.doctorName != null ? "/${perInspection.doctorName}" : ""}",
                                        header3: "Tarih",
                                        content3: perInspection.inspectionDate!
                                            .substring(0, 16),
                                        navigationContentText: "Detaylar",
                                        onClick: () async {
                                          Customer? customer = await ref
                                              .read(currentBaseModelState
                                                  .notifier)
                                              .getCustomer(
                                                  perInspection.customerID!);

                                          debugPrint(
                                              "test:${customer?.dangerLevel}");
                                          ref
                                              .read(
                                                  currentCustomFlexibleAppBarState
                                                      .notifier)
                                              .changeContentFlexibleManager(CustomFlexibleModel(
                                                  header1: "Şirket Adı",
                                                  header2:
                                                      "Uzman${perInspection.doctorName != null ? "/Hekim" : ""}",
                                                  header3: "Tarih",
                                                  header4: "Sicil No",
                                                  header5: "Tehlike Durumu",
                                                  content4:
                                                      customer!
                                                          .companyDetectNumber!,
                                                  content5: perInspection
                                                      .dangerLevelOfCustomer,
                                                  content1:
                                                      perInspection
                                                          .customerName!,
                                                  content2:
                                                      "${perInspection.expertName!}${perInspection.doctorName != null ? "/${perInspection.doctorName}" : ""}",
                                                  content3: perInspection
                                                      .inspectionDate!
                                                      .substring(0, 16),
                                                  photoUrl: perInspection
                                                      .customerPhotoURL,
                                                  backAppBarTitle:
                                                      "Denetimi Gerçekleştir"));

                                          ref
                                              .read(currentExpertWorksState
                                                  .notifier)
                                              .getWithQRInspection(
                                                  false,
                                                  perInspection.customerID!,
                                                  ref)
                                              .then((value) {
                                            if (value != null &&
                                                value.isNotEmpty) {
                                              ref
                                                  .read(currentInspectionState
                                                      .notifier)
                                                  .changeCurrentInspection(
                                                      perInspection);
                                              NavigationService.instance
                                                  .navigateToPage(
                                                      path: NavigationConstants
                                                          .doAuditPage);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Seçili şirkete tanımlı bir denetleme talebi bulunamadı");
                                            }
                                          });
                                        }),
                                  );
                                }),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Ziyaret edilecek bir görev bulunmamaktadır",
                              textAlign: TextAlign.center,
                              style: ThemeValueExtension.subtitle2
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
            }),
      ),
    ));
  }
}
