import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/doctor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../utilities/components/custom_elevated_button.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/seperate_padding.dart';
import '../../../../utilities/components/single_photo_container.dart';
import '../../../../utilities/constants/app/application_constants.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class AddDoctor extends ConsumerStatefulWidget {
  const AddDoctor({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddDoctorState();
}

class _AddDoctorState extends ConsumerState<AddDoctor> {
  late TextEditingController doctorNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController doctorPhoneNumberController;
  late TextEditingController doctorMasterController;
  final _addDoctorKey = GlobalKey<FormState>();
  File? doctorPhotoFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doctorNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    doctorPhoneNumberController = TextEditingController();
    doctorMasterController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    doctorNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    doctorPhoneNumberController.dispose();
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
                  key: _addDoctorKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "Hekim Ekle",
                        style: ThemeValueExtension.headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RowFormField(
                        editingController: doctorNameController,
                        headerName: 'Hekim Adı ve Soyadı',
                        inputType: TextInputType.name,
                        hintText: ApplicationConstants.hintName,
                        custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: emailController,
                        headerName: 'Hekim E-mail',
                        inputType: TextInputType.emailAddress,
                        hintText: ApplicationConstants.hintEmail,
                        custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: passwordController,
                        custValidateFunction: (value) =>
                        value != "" && value != null ? value.length>=6 ? null : "Şifre 6 karakterden fazla olmalıdır" : "Bu alan boş bırakılamaz",
                        headerName: 'Hekim Şifre',
                        visibleStatus: true,

                        hintText: ApplicationConstants.hintPassword,
                      ),
                      colAddPhoto(),
                      RowFormField(
                        editingController: doctorPhoneNumberController,
                        headerName: 'Hekim Telefon',
                        inputType: TextInputType.phone,
                        hintText: ApplicationConstants.hintPhoneNumber,
                        custValidateFunction: (value) {
                          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(patttern);

                          if(value!.isEmpty){
                            return "Lütfen telefon numarası giriniz";
                          }else if(!regExp.hasMatch(value)){
                            return "Lütfen geçerli bir telefon numarası giriniz";
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 2.h),
                      ref.watch(currentLoadingState) == LoadingStates.loaded
                          ? CustomElevatedButton(
                              onPressed: () {
                                _addDoctorKey.currentState!.save();

                                if(_addDoctorKey.currentState!.validate()){
                                  var doctor = Doctor(
                                    typeOfUser: 'doctor',
                                    doctorMail: emailController.text,
                                    doctorName: doctorNameController.text,
                                    doctorPhoneNumber:
                                    doctorPhoneNumberController.text,
                                  );

                                  ref
                                      .read(currentAdminWorksState.notifier)
                                      .createDoctor(
                                      doctor,
                                      emailController.text,
                                      passwordController.text,
                                      ref,
                                      doctorPhotoFile,
                                      Roles.doctor);
                                }

                              },
                              inButtonText: "Hekim Ekle",
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

  Column colAddPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text(
            "Hekim Fotoğraf(opsiyonel)",
            style: ThemeValueExtension.subtitle,
          ),
        ),
        SinglePhotoArea(
          onSaved: (value) {
            doctorPhotoFile = value;
          },
          showInArea: true,
        ),
      ],
    );
  }
}
