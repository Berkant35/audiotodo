import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanoid/async.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accident_case.dart';
import 'package:osgb/utilities/components/add_worker_dialog.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/notification_model.dart';
import '../../../../models/worker.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/single_photo_container.dart';
import '../../../../utilities/constants/extension/edge_extension.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class AddCrises extends ConsumerStatefulWidget {
  const AddCrises({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddCrisesState();
}

class _AddCrisesState extends ConsumerState<AddCrises> {
  late TextEditingController datePickerController;
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController explainController;
  final _addCrisesFormKey = GlobalKey<FormState>();
  List<File> localFileList = [];
  List<Worker> selectedWorkerList = [];

  @override
  void initState() {
    super.initState();
    datePickerController = TextEditingController();
    titleController = TextEditingController();
    contentController = TextEditingController();
    explainController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    datePickerController.dispose();
    titleController.dispose();
    contentController.dispose();
    explainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: basicAppBar(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
            padding: seperatePadding(),
            child: Form(
              key: _addCrisesFormKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      "Olay Form",
                      style: ThemeValueExtension.headline6
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olay Tarih",
                        style: ThemeValueExtension.subtitle,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        controller: datePickerController,
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
                  RowFormField(
                    headerName: 'Olay Başlık',
                    editingController: titleController,
                    hintText: "Çalışanımız balkondan düştü",
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  RowFormField(
                    headerName: 'Etkilenen Çalışanlar',
                    editingController: explainController,
                    hintText: "Ahmet Durmaz,Veli Demir",
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  RowFormField(
                    headerName: 'Olay Açıklama',
                    editingController: contentController,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                    maxLines: 5,
                    hintText:
                        "Çalışanımız göz kararması sonucu 2.kattan aşağı düştü",
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(EdgeExtension.mediumEdge.edgeValue),
                    decoration: BoxDecoration(
                        color: CustomColors.customGreyColor.withOpacity(0.2),
                        border: Border.all(
                            width: 1.25, color: CustomColors.secondaryColor),
                        borderRadius: BorderRadius.all(
                            Radius.circular(EdgeExtension.lowEdge.edgeValue))),
                    child: Center(
                      child: Text(
                        "Birden fazla fotoğraf ekleyebilirsiniz.Yeni fotoğraf eklemek için sola kaydırın",
                        style: ThemeValueExtension.subtitle3
                            .copyWith(color: CustomColors.secondaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: seperatePadding(),
                        child: Text(
                          "Fotoğraf Ekle(${localFileList.length})",
                          style: ThemeValueExtension.subtitle,
                          textAlign: TextAlign.left,
                        ),
                      )),
                  photoList(),
                  SizedBox(
                    height: 2.h,
                  ),

                  /*AddWorkerDialogs(selectedWorkerList: (workers) {
                    selectedWorkerList = workers;
                  }),*/
                  SizedBox(
                    height: 4.h,
                  ),
                  ref.watch(currentButtonLoadingState) != LoadingStates.loading
                      ? CustomElevatedButton(
                          onPressed: () async {
                            _addCrisesFormKey.currentState!.save();
                            if (_addCrisesFormKey.currentState!.validate() &&
                                datePickerController.text != "") {
                              List<dynamic> workerDynamicList = [];
                              for (var worker in selectedWorkerList) {
                                workerDynamicList.add(worker.toJson());
                              }
                              var uniqueID = await nanoid();
                              ref
                                  .read(currentCustomerWorksState.notifier)
                                  .createCrises(
                                      AccidentCase(
                                          caseID: uniqueID,
                                          caseCompanyID: ref
                                              .read(currentBaseModelState)
                                              .customer!
                                              .rootUserID,
                                          affectedExplain:
                                              explainController.text,
                                          caseAffectedWorkerList:
                                              workerDynamicList,
                                          caseName: titleController.text,
                                          caseDate: datePickerController.text,
                                          casePhotos: [],
                                          caseContent: contentController.text,
                                          caseConfirmedByAdmin: false,
                                          caseCompanyName: ref
                                              .read(currentBaseModelState)
                                              .customer!
                                              .customerName!,
                                          caseCompanyEmail: ref
                                              .read(currentBaseModelState)
                                              .customer!
                                              .email!,
                                          caseCompanyPhone: ref
                                              .read(currentBaseModelState)
                                              .customer!
                                              .customerPhoneNumber,
                                          caseCompanyPresentationPersonPhoneNumber:
                                              ref
                                                  .read(currentBaseModelState)
                                                  .customer!
                                                  .representativePersonPhone),
                                      ref,
                                      localFileList)
                                  .then((value) async {
                                if (value) {
                                  await ref
                                      .read(currentBaseModelState.notifier)
                                      .getAdmin()
                                      .then((admin) {
                                    if (admin != null) {
                                      ref
                                          .read(currentPushNotificationState
                                              .notifier)
                                          .sendPush(NotificationModel(
                                              to: admin.pushToken!,
                                              priority: "high",
                                              notification: CustomNotification(
                                                  title:
                                                      "${ref.read(currentBaseModelState).customer!.customerName} Yerinde Yeni Bir Olay Gerçekleşti!",
                                                  body: workerDynamicList
                                                          .isNotEmpty
                                                      ? "${workerDynamicList.length} çalışan etkilendi"
                                                      : "${datePickerController.text}'de gerçekleşen bir durum var!")));
                                    }
                                  });
                                }
                              });
                            } else {
                              if (selectedWorkerList.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Lütfen Etkilenen Çalışanları Ekleyin");
                              } else if (datePickerController.text == "") {
                                Fluttertoast.showToast(
                                    msg:
                                        "Gerçekleşen İşlemin Tarihini Belirtin");
                              } else {
                                Fluttertoast.showToast(
                                    msg: "İlgili Alanları Doldurun");
                              }
                            }
                          },
                          inButtonText: "Olay Bildir",
                          primaryColor: CustomColors.orangeColorM,
                        )
                      : const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                  SizedBox(height: 20.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView photoList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < localFileList.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Stack(
                children: [
                  Container(
                    width: 90.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: CustomColors.customCardBackgroundColor,
                        border: Border.all(
                            strokeAlign: StrokeAlign.inside,
                            color: CustomColors.secondaryColor),
                        borderRadius: BorderRadius.all(
                            Radius.circular(EdgeExtension.lowEdge.edgeValue))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(EdgeExtension.lowEdge.edgeValue)),
                      child: Image.file(
                        File(localFileList[i].path),
                        width: 90.w,
                        height: 70.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1.4.h,
                    right: -1.25.h,
                    child: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: CustomColors.customGreyColor,
                        onPressed: () {
                          localFileList.removeAt(i);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: CustomColors.orangeColor,
                          size: 20,
                        )),
                  )
                ],
              ),
            ),
          SinglePhotoArea(
            onSaved: (value) {
              localFileList.add(value);
              setState(() {});
            },
            showInArea: false,
          ),
        ],
      ),
    );
  }

  AppBar basicAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => NavigationService.instance.navigatePopUp(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 3.h,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      leadingWidth: 3.h,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Text("Yeni Olay Bildir",
          style: ThemeValueExtension.subtitle.copyWith(color: Colors.black)),
    );
  }
}
