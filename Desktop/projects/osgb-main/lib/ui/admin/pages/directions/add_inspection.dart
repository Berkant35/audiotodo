import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanoid/nanoid.dart';
import 'package:osgb/models/notification_model.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/customer.dart';
import '../../../../models/doctor.dart';
import '../../../../models/expert.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/components/list_of_expansion_list.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/seperate_padding.dart';
import '../../../../utilities/init/navigation/navigation_service.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class AddInspection extends ConsumerStatefulWidget {
  const AddInspection({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddInspectionState();
}

class _AddInspectionState extends ConsumerState<AddInspection> {
  final _addInspectionFormKey = GlobalKey<FormState>();
  String? choosedCustomer;
  String? choosedCustomerID;
  Customer? inspectionCustomer;
  late TextEditingController dateController;
  late TextEditingController inspectionExplain;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    inspectionExplain = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    inspectionExplain.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Denetim Oluştur",
          style: ThemeValueExtension.subtitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: SingleChildScrollView(
          child: Form(
            key: _addInspectionFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "İş Yeri Seçimi",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                selectCustomer(),
                choosedCustomerID != null
                    ? FutureBuilder<dynamic>(
                        future: ref
                            .read(currentAdminWorksState.notifier)
                            .getRoleUser(choosedCustomerID!),
                        builder: (context, snapshot) {
                          Customer? customer;
                          customer = snapshot.data as Customer?;
                          return snapshot.connectionState ==
                                      ConnectionState.done &&
                                  customer != null
                              ? SizedBox(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      infoColumn(
                                          "İş Yeri Sicil No",
                                          customer.companyDetectNumber
                                              .toString()),
                                      infoColumn(
                                          "İş Yeri Telefon",
                                          customer.customerPhoneNumber ??
                                              "Belirtilmemiş"),
                                      infoColumn("İş Yeri E-Mail",
                                          customer.email ?? "Belirtilmemiş"),
                                      infoColumn(
                                          "Atanmış Uzman",
                                          Expert.fromJson(
                                                  customer.definedExpert)
                                              .expertName!),
                                      infoColumn(
                                          "Atanmış Hekim",
                                          customer.definedDoctor != null
                                              ? Doctor.fromJson(
                                                      customer.definedDoctor)
                                                  .doctorName!
                                              : ""),
                                      RowFormField(
                                        editingController: inspectionExplain,
                                        headerName: "Açıklama",
                                        maxLines: 5,
                                        custValidateFunction: (value) =>
                                            value != ""
                                                ? null
                                                : "Bu alan boş bırakılamaz",
                                      ),
                                      dateField(),
                                      createInspectionButton(
                                          Expert.fromJson(
                                              customer.definedExpert),
                                          customer.definedDoctor != null
                                              ? Doctor.fromJson(
                                                  customer.definedDoctor)
                                              : null),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                        })
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding createInspectionButton(Expert expert, Doctor? doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ref.watch(currentButtonLoadingState) != LoadingStates.loading
          ? CustomElevatedButton(
              onPressed: () async {
                _addInspectionFormKey.currentState!.save();
                if (_addInspectionFormKey.currentState!.validate() &&
                    dateController.text != "") {
                  int workerCount = await ref
                      .read(currentCustomerWorksState.notifier)
                      .getWorkerCount(inspectionCustomer!.rootUserID!);
                  var id = nanoid();
                  var currentInspection = Inspection(
                      inspectionID: id,
                      customerID: inspectionCustomer!.rootUserID,
                      customerName: inspectionCustomer!.customerName,
                      customerPhotoURL: inspectionCustomer!.photoURL,
                      doctorID: doctor != null ? doctor.rootUserID ?? "" : "",
                      doctorName: doctor != null ? doctor.doctorName ?? "" : "",
                      highDanger: 0,
                      normalDanger: 0,
                      lowDanger: 0,
                      customerPushToken: inspectionCustomer!.pushToken != null
                          ? inspectionCustomer!.pushToken!
                          : "",
                      expertName: expert.expertName,
                      expertID: expert.rootUserID,
                      inspectionDate: dateController.text,
                      inspectionExplain: inspectionExplain.text,
                      inspectionIsDone: false,
                      inspectionIsStarted: false,
                      waitFixList: [],
                      currentHasMustFixCount: 0,
                      customerPresentationName:
                          inspectionCustomer!.representativePerson,
                      customerAddress: inspectionCustomer!.customerAddress,
                      customerSector: inspectionCustomer!.customerSector,
                      dangerLevelOfCustomer: inspectionCustomer!.dangerLevel,
                      workerCount: workerCount);
                  ref
                      .read(currentAdminWorksState.notifier)
                      .createInspection(ref, currentInspection)
                      .then((value) {
                    if (value) {
                      ref.read(currentPushNotificationState.notifier).sendPush(
                          NotificationModel(
                              to: inspectionCustomer!.pushToken ?? "",
                              priority: "high",
                              notification: CustomNotification(
                                  title: "Denetim Oluşturuldu",
                                  body:
                                      "${dateController.text.substring(0, 16)} "
                                      "tarihinde SU OSGB iş sağlığı uzmanları tarafından iş yerinize denetim gerçekleştirilecektir.")));

                      if (ref.read(currentRole) == Roles.admin) {
                        ref
                            .read(currentBaseModelState.notifier)
                            .getExpert(expert.rootUserID!)
                            .then((expert) {
                          ref
                              .read(currentPushNotificationState.notifier)
                              .sendPush(NotificationModel(
                                  to: expert!.pushToken,
                                  priority: "high",
                                  notification: CustomNotification(
                                      title: "Denetim Oluşturuldu",
                                      body:
                                          "${inspectionCustomer!.customerName} iş yerine ${dateController.text} denetim planlanıldı")));
                        });
                      }
                    }

                    if ((ref.read(currentRole) == Roles.doctor ||
                        ref.read(currentRole) == Roles.expert)) {
                      NavigationService.instance.navigateToPageClear(
                          path: NavigationConstants.expertBasePage);
                    } else {
                      NavigationService.instance.navigateToPageClear(
                          path: NavigationConstants.adminBasePage);
                    }
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: "Lütfen belirtilen alanları doldurunuz");
                }
              },
              inButtonText: "Denetimi Oluştur",
              primaryColor: CustomColors.orangeColorM,
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Padding dateField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Denetimin Olacağı Tarih",
            style: ThemeValueExtension.subtitle,
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            controller: dateController,
            //initialValue: _initialValue,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(
              Icons.event,
              color: CustomColors.secondaryColor,
            ),
            dateLabelText: 'Tarih',
            timeLabelText: "Saat",
            style: ThemeValueExtension.subtitle2,
          ),
        ],
      ),
    );
  }

  Padding infoColumn(String header, String content) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header, style: ThemeValueExtension.subtitle),
            Text(content, style: ThemeValueExtension.subtitle2),
          ],
        ),
      );

  Column selectCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text("İş Yeri", style: ThemeValueExtension.subtitle),
        ),
        GetExpansionChooseList(
          onSaved: (String? value, String? customerID) async {
            choosedCustomer = value;
            choosedCustomerID = customerID;
            inspectionCustomer = await ref
                .read(currentAdminWorksState.notifier)
                .getRoleUser(choosedCustomerID!) as Customer;
            setState(() {});
          },
          getFutureList: ref
              .read(currentAdminWorksState.notifier)
              .getCustomerListWithMap(ref),
          title: "İş Yeri Seç",
          keyOfMap: "customerName",
        ),
      ],
    );
  }
}
