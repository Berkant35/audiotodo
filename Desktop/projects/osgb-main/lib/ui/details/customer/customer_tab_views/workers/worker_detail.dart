import 'dart:async';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/components/custom_flexible_bar.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../line/viewmodel/global_providers.dart';
import '../../../../../models/worker.dart';
import '../../../../../utilities/components/custom_elevated_button.dart';
import '../../../../../utilities/components/row_form_field.dart';
import '../../../../../utilities/components/seperate_padding.dart';
import '../../../../../utilities/components/single_photo_container.dart';
import '../../../../../utilities/constants/app/application_constants.dart';
import '../../../../../utilities/constants/app/enums.dart';
import '../../../../../utilities/init/theme/custom_colors.dart';

class WorkerDetail extends ConsumerStatefulWidget {
  final Worker worker;

  const WorkerDetail({Key? key, required this.worker}) : super(key: key);

  @override
  ConsumerState createState() => _WorkerDetailState();
}

class _WorkerDetailState extends ConsumerState<WorkerDetail> {
  late TextEditingController workerNameAndSurnameController;
  late TextEditingController workerPhoneNumberController;

  late TextEditingController workerMissionController;
  late TextEditingController dateController;
  final _updateWorkerFormKey = GlobalKey<FormState>();
  File? workerPhotoFile;

  @override
  void initState() {
    super.initState();
    workerNameAndSurnameController =
        TextEditingController(text: widget.worker.workerName);
    workerPhoneNumberController =
        TextEditingController(text: widget.worker.workerPhoneNumber);

    workerMissionController =
        TextEditingController(text: widget.worker.workerJob);
    dateController =
        TextEditingController(text: widget.worker.startAtCompanyDate);
  }

  @override
  void dispose() {
    super.dispose();
    workerNameAndSurnameController.dispose();
    workerPhoneNumberController.dispose();

    workerMissionController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
        flexibleSpace: CustomFlexibleBar(
            firstHeader: "Çalışan Adı",
            secondHeader: "Görevi",
            thirdHeader: "Telefon",
            firstInfo: ref.watch(currentCustomFlexibleAppBarState).content1,
            secondInfo: ref.watch(currentCustomFlexibleAppBarState).content2,
            thirdInfo: ref.watch(currentCustomFlexibleAppBarState).content3,
            headerPhoto: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
            appBarTitle: "Çalışan Detay",
            role: Roles.worker,

        ),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
              padding: EdgeInsets.only(left: 5.w, top: 1.h, right: 5.w),
              child: Form(
                key: _updateWorkerFormKey,
                child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(context.lowValue),
                        child: Text(
                          'Çalışan Detay',
                          style: ThemeValueExtension.headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RowFormField(
                        headerName: 'Çalışan Adı ve Soyadı',
                        hintText: ApplicationConstants.hintName,
                        editingController: workerNameAndSurnameController,
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      Padding(
                        padding: seperatePadding(),
                        child: Text(
                          'Çalışan Fotoğraf',
                          style: ThemeValueExtension.subtitle,
                        ),
                      ),
                      SinglePhotoArea(
                        photoUrl: widget.worker.photoURL,
                        onSaved: (file) {
                          workerPhotoFile = file;
                        },
                        showInArea: true,
                      ),
                      RowFormField(
                        headerName: 'Çalışan Telefon Numarası',
                        editingController: workerPhoneNumberController,
                        hintText: ApplicationConstants.hintPhoneNumber,
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        headerName: 'Görevi',
                        editingController: workerMissionController,
                        hintText: ApplicationConstants.hintMission,
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Çalışma Başlangıç Tarihi",
                              style: ThemeValueExtension.subtitle,
                            ),
                            DateTimePicker(
                              type: DateTimePickerType.date,
                              dateMask: 'd MMM, yyyy',
                              controller: dateController,
                              //initialValue: _initialValue,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: const Icon(
                                Icons.event,
                                color: CustomColors.secondaryColor,
                              ),
                              style: ThemeValueExtension.subtitle,
                              //use24HourFormat: false,
                              //locale: Locale('pt', 'BR'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ref.watch(currentButtonLoadingState) !=
                              LoadingStates.loading
                          ? Column(
                            children: [
                              CustomElevatedButton(
                                  onPressed: () async {
                                    _updateWorkerFormKey.currentState!.save();
                                    if (_updateWorkerFormKey.currentState!
                                        .validate()) {
                                      ref
                                          .read(currentCustomerWorksState.notifier)
                                          .updateWorker(
                                            ref,
                                            Worker(
                                                typeOfUser: 'worker',

                                                rootUserID:
                                                    widget.worker.rootUserID,
                                                workerPassword: "123456",
                                                workerName:
                                                    workerNameAndSurnameController
                                                        .text,
                                                photoURL: widget.worker.photoURL,
                                                workerCompanyID:
                                                    widget.worker.workerCompanyID,
                                                workerJob:
                                                    workerMissionController.text,
                                                workerPhoneNumber:
                                                    workerPhoneNumberController
                                                        .text,
                                                startAtCompanyDate:
                                                    dateController.text),
                                            workerPhotoFile,
                                          ).then((value)=>goToBase(ref));
                                    }
                                  },
                                  inButtonText: "Çalışanı Güncelle",
                                  primaryColor: CustomColors.secondaryColorM,
                                ),
                              SizedBox(
                                height: 2.h,
                              ),
                              CustomElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(currentCustomerWorksState.notifier)
                                      .deleteWorker(ref, widget.worker.rootUserID!)
                                      .then((value)=>goToBase(ref));
                                },
                                inButtonText: " Çalışanı Sil",
                                primaryColor: CustomColors.errorColorM,
                              )
                            ],
                          )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),

                      SizedBox(
                        height: 25.h,
                      ),
                    ]),
              ))),
    );
  }

  FutureOr<void> goToBase(WidgetRef ref) async {

    ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
    ref.read(currentAddUserIndexState.notifier).changeState(0);

    NavigationService.instance.navigateToPageClear(
        path: ref.read(currentRole) == Roles.admin
            ? NavigationConstants.adminBasePage
            : NavigationConstants.customerBasePage);
  }
}
