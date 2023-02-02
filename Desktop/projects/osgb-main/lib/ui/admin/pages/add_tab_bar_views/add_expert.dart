import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/single_photo_container.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/expert.dart';
import '../../../../utilities/components/list_of_expansion_static.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/constants/app/application_constants.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class AddExpert extends ConsumerStatefulWidget {
  const AddExpert({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddExpertState();
}

class _AddExpertState extends ConsumerState<AddExpert> {
  final _expertFormKey = GlobalKey<FormState>();

  late TextEditingController expertNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController expertPhoneNumberController;
  late String expertMaster = "A Sınıfı İş Güvenliği Uzmanı";
  File? expertPhotoFile;

  @override
  void initState() {
    super.initState();
    expertNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    expertPhoneNumberController = TextEditingController();

  }

  @override
  void dispose() {
    super.dispose();
    expertNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    expertPhoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 5.w, top: 1.h, right: 5.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _expertFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "Uzman Ekle",
                        style: ThemeValueExtension.headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RowFormField(
                        editingController: expertNameController,
                        headerName: 'Uzman Adı ve Soyadı',
                        inputType: TextInputType.name,
                        hintText: "Adı",
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: emailController,
                        headerName: 'Uzman E-mail',
                        inputType: TextInputType.emailAddress,
                        hintText: "E-mail",
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: passwordController,
                        headerName: 'Uzman Şifre',
                        hintText: "Şifre",
                        visibleStatus: true,
                        custValidateFunction: (value) =>
                            value != "" && value != null
                                ? value.length >= 6
                                    ? null
                                    : "Şifre 6 karakterden fazla olmalıdır"
                                : "Bu alan boş bırakılamaz",
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
                      /*RowFormField(
                        editingController: expertMasterController,
                        headerName: 'Uzmanlık Alanı',
                        hintText: "Tıp uzmanı",
                        custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                        inputType: TextInputType.name,
                      ),*/
                      SizedBox(height: 2.h),
                      ref.watch(currentLoadingState) == LoadingStates.loaded
                          ? CustomElevatedButton(
                              onPressed: () {
                                _expertFormKey.currentState!.save();
                                if (_expertFormKey.currentState!.validate()) {
                                  var expert = Expert(
                                    typeOfUser: 'expert',
                                    expertMail: emailController.text,
                                    expertMaster: expertMaster,
                                    expertName: expertNameController.text,
                                    expertPhoneNumber:
                                        expertPhoneNumberController.text,
                                  );
                                  ref
                                      .read(currentAdminWorksState.notifier)
                                      .createExpert(
                                          expert,
                                          emailController.text,
                                          passwordController.text,
                                          ref,
                                          expertPhotoFile,
                                          Roles.expert);
                                }
                              },
                              inButtonText: "Uzman Ekle",
                              primaryColor: CustomColors.orangeColorM,
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            )));
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
           expertMaster = value;
           debugPrint("Expert:$expertMaster");
            setState(() {});
          },
          getList: const [
            "A Sınıfı İş Güvenliği Uzmanı",
            "B Sınıfı İş Güvenliği Uzmanı",
            "C Sınıfı İş Güvenliği Uzmanı"
          ],
          defaultValue: "A Sınıfı İş Güvenliği Uzmanı",
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
        SinglePhotoArea(
          onSaved: (value) {
            expertPhotoFile = value;
          },
          showInArea: true,
        ),
      ],
    );
  }

  EdgeInsets seperatePadding() =>
      EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w);
}
