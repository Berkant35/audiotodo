import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../line/viewmodel/global_providers.dart';
import '../../../../../models/expert.dart';
import '../../../../../utilities/components/custom_elevated_button.dart';
import '../../../../../utilities/components/list_of_expansion_static.dart';
import '../../../../../utilities/components/row_form_field.dart';
import '../../../../../utilities/components/seperate_padding.dart';
import '../../../../../utilities/components/single_photo_container.dart';
import '../../../../../utilities/constants/app/application_constants.dart';
import '../../../../../utilities/constants/app/enums.dart';
import '../../../../../utilities/init/theme/custom_colors.dart';

class ExpertInfo extends ConsumerStatefulWidget {
  final Expert expert;

  const ExpertInfo({Key? key, required this.expert}) : super(key: key);

  @override
  ConsumerState createState() => _ExpertInfoState();
}

class _ExpertInfoState extends ConsumerState<ExpertInfo> {
  final _expertFormKey = GlobalKey<FormState>();

  late TextEditingController expertNameController;

  late TextEditingController expertPhoneNumberController;
  late TextEditingController expertMasterController;
  File? expertPhotoFile;

  @override
  void initState() {
    super.initState();
    expertNameController =
        TextEditingController(text: widget.expert.expertName);
    expertPhoneNumberController =
        TextEditingController(text: widget.expert.expertPhoneNumber);
    expertMasterController =
        TextEditingController(text: widget.expert.expertMaster);
  }

  @override
  void dispose() {
    super.dispose();
    expertNameController.dispose();
    expertMasterController.dispose();
    expertPhoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: seperatePadding(),
          child: Form(
            key: _expertFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text("Düzenle",
                    style: ThemeValueExtension.headline6
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                RowFormField(
                  editingController: expertNameController,
                  headerName: 'Uzman Adı ve Soyadı',
                  inputType: TextInputType.name,
                  hintText: "Adı",
                  custValidateFunction: (value) =>
                  value != "" ? null : "Bu alan boş bırakılamaz",
                ),
                colAddPhoto(),
                RowFormField(
                  editingController: expertPhoneNumberController,
                  headerName: 'Uzman Telefon',
                  hintText: ApplicationConstants.hintPhoneNumber,
                  custValidateFunction: (value) {
                    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                    RegExp regExp = RegExp(patttern);

                    if (value!.isEmpty) {
                      return "Lütfen telefon numarası giriniz";
                    } else if (!regExp.hasMatch(value)) {
                      return "Lütfen geçerli bir telefon numarası giriniz";
                    } else {
                      return null;
                    }
                  },
                  inputType: TextInputType.phone,
                ),
                selectExpertDegree(),
                SizedBox(height: 2.h),
                ref.watch(currentButtonLoadingState) != LoadingStates.loading
                    ? Center(
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          _expertFormKey.currentState!.save();
                          if (_expertFormKey.currentState!.validate()) {
                            var expert = Expert(
                              rootUserID: widget.expert.rootUserID,
                              typeOfUser: 'expert',
                              expertMail: widget.expert.expertMail,
                              expertMaster: expertMasterController.text,
                              photoURL: widget.expert.photoURL,
                              pushToken: widget.expert.pushToken,
                              expertName: expertNameController.text,
                              expertPhoneNumber:
                              expertPhoneNumberController.text,
                            );
                            ref
                                .read(currentAdminWorksState.notifier)
                                .updateExpert(expert, ref,
                                expertPhotoFile, Roles.expert);
                          }
                        },
                        inButtonText: "Uzman Güncelle",
                        primaryColor: CustomColors.secondaryColorM,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          ref
                              .read(currentAdminWorksState.notifier)
                              .deleteExpert(
                              widget.expert.rootUserID, ref,Roles.expert);
                        },
                        inButtonText: "Uzmanı Sil",
                        primaryColor: CustomColors.errorColorM,
                      )
                    ],
                  ),
                )
                    : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column selectExpertDegree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text("Uzmanlık Alanı", style: ThemeValueExtension.subtitle),
        ),
        GetExpansionStaticChooseList(
          onSaved: (String value) {
            expertMasterController.text = value;
          },
          getList: const [
            "A Sınıfı İş Güvenliği Uzmanı",
            "B Sınıfı İş Güvenliği Uzmanı",
            "C Sınıfı İş Güvenliği Uzmanı"
          ],
          defaultValue: widget.expert.expertMaster,
          title: "Uzmanlık Sınıfı",
        ),
      ],
    );
  }

  Column colAddPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text(
            "Uzman Fotoğraf(opsiyonel)",
            style: ThemeValueExtension.subtitle,
          ),
        ),
        Center(
          child: SinglePhotoArea(
            photoUrl: widget.expert.photoURL,
            onSaved: (value) {
              expertPhotoFile = value;
            },
            showInArea: true,
          ),
        ),
      ],
    );
  }
}
