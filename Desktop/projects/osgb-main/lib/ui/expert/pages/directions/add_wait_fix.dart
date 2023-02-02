import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/async.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/components/single_photo_container.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:osgb/utilities/init/theme/custom_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/inspection.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/work_danger_check_list.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/edge_extension.dart';

class AddWaitFix extends ConsumerStatefulWidget {
  final Inspection inspection;

  const AddWaitFix({
    Key? key,
    required this.inspection,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddWaitFixState();
}

class _AddWaitFixState extends ConsumerState<AddWaitFix> {
  final _addWaitFixFormKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController contentAdviceController;
  late TextEditingController deadlineDateController;
  List<File> localFileList = [];
  String? dangerLevel;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    contentAdviceController = TextEditingController();
    deadlineDateController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    contentAdviceController.dispose();
    deadlineDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Durum Ekle", style: ThemeValueExtension.subtitle),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            NavigationService.instance.navigatePopUp();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
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
              key: _addWaitFixFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      "Durum Bilgileri",
                      style: ThemeValueExtension.headline6
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  RowFormField(
                    headerName: 'Durum Başlık',
                    editingController: titleController,
                    hintText: "Baret takmayan çalışan",
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  RowFormField(
                    headerName: 'Durum Açıklama',
                    editingController: contentController,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                    maxLines: 5,
                    hintText:
                        " Şantiye alanında baret takmayan çalışanlar tespit edildi.",
                  ),
                  RowFormField(
                    headerName: 'Öneri',
                    editingController: contentAdviceController,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                    maxLines: 5,
                    hintText:
                        " Baretler için uyarıcı tabelalar hazırlanabilir.",
                  ),
                  SizedBox(height: 1.h),
                  dateField(),
                  SizedBox(height: 2.h),
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
                  SizedBox(height: 2.h),
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
                  SizedBox(height: 1.h),
                  WorkDangerCheckList(
                    onSaved: (level) {
                      dangerLevel = level;
                    },
                  ),
                  SizedBox(height: 1.h),
                  ref.watch(currentButtonLoadingState) != LoadingStates.loading
                      ? CustomElevatedButton(
                          onPressed: () async {
                            _addWaitFixFormKey.currentState!.save();
                            if (_addWaitFixFormKey.currentState!.validate()) {
                              DateTime dateTime  = DateTime.parse(deadlineDateController.text);
                              var deadLineFormat = DateFormat("dd-MM-yyyy").format(dateTime);

                              var waitFixID = await nanoid();


                              var waitFix = WaitFix(
                                waitFixID: waitFixID,
                                waitFixContent: contentController.text,
                                waitFixDegree: dangerLevel,
                                waitFixPhotos: [],
                                waitFixExpertID:
                                    ref.read(currentRole) == Roles.expert
                                        ? ref
                                            .read(currentBaseModelState)
                                            .expert!
                                            .rootUserID!
                                        : ref
                                            .read(currentBaseModelState)
                                            .doctor!
                                            .rootUserID,
                                waitFixTitle: titleController.text,
                                waitFixInspectionID:
                                    widget.inspection.inspectionID,
                                deadlineDate: deadLineFormat,
                                adviceExplain: contentAdviceController.text,
                              );

                              debugPrint("Per Wait Fix:${waitFix.toJson()}");

                              ref
                                  .read(currentExpertWorksState.notifier)
                                  .addWaitFix(waitFix, localFileList, ref)
                                  .then((value) {
                                NavigationService.instance.navigatePopUp();
                              });
                            }
                          },
                          inButtonText: "Durum Ekle",
                          primaryColor: CustomColors.orangeColorM,
                        )
                      : const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                  SizedBox(
                    height: 40.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding dateField() {
    return Padding(
      padding: seperatePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Termin Tarihi",
            style: ThemeValueExtension.subtitle,
          ),
          DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'dd-mm-yyyy',

            controller: deadlineDateController,
            //initialValue: _initialValue,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(
              Icons.event,
              color: CustomColors.secondaryColor,
            ),
            dateLabelText: 'Tarih',
            style: ThemeValueExtension.subtitle2,
          ),
        ],
      ),
    );
  }

  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
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
}
