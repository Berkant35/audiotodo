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
import '../../../../models/doctor.dart';

class DoctorInfo extends ConsumerStatefulWidget {
  final Doctor doctor;

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  ConsumerState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends ConsumerState<DoctorInfo> {
  final _doctorFormKey = GlobalKey<FormState>();

  late TextEditingController doctorNameController;
  late TextEditingController doctorPhoneNumberController;
  File? doctorPhotoFile;

  @override
  void initState() {
    super.initState();
    doctorNameController =
        TextEditingController(text: widget.doctor.doctorName);
    doctorPhoneNumberController =
        TextEditingController(text: widget.doctor.doctorPhoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    doctorNameController.dispose();
    doctorPhoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: seperatePadding(),
          child: Form(
            key: _doctorFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text("Düzenle",
                    style: ThemeValueExtension.headline6
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                RowFormField(
                  editingController: doctorNameController,
                  headerName: 'Hekim Adı ve Soyadı',
                  inputType: TextInputType.name,
                  hintText: "Adı",
                  custValidateFunction: (value) =>
                  value != "" ? null : "Bu alan boş bırakılamaz",
                ),
                colAddPhoto(),
                RowFormField(
                  editingController: doctorPhoneNumberController,
                  headerName: 'Hekim Telefon',
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
                SizedBox(height: 2.h),
                buttonCases(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center buttonCases() {
    return ref.watch(currentButtonLoadingState) != LoadingStates.loading
        ? Center(
      child: Column(
        children: [
          CustomElevatedButton(
            onPressed: () {
              _doctorFormKey.currentState!.save();
              if (_doctorFormKey.currentState!.validate()) {
                var doctor = Doctor(
                  rootUserID: widget.doctor.rootUserID,
                  typeOfUser: 'doctor',
                  doctorMail: widget.doctor.doctorMail,
                  photoURL: widget.doctor.photoURL,
                  pushToken: widget.doctor.pushToken,
                  doctorName: doctorNameController.text,
                  doctorPhoneNumber: doctorPhoneNumberController.text,
                );
                ref.read(currentAdminWorksState.notifier).updateDoctor(
                    doctor, ref, doctorPhotoFile, Roles.doctor);
              }
            },
            inButtonText: "Hekim Güncelle",
            primaryColor: CustomColors.secondaryColorM,
          ),
          SizedBox(
            height: 4.h,
          ),
          CustomElevatedButton(
            onPressed: () {
              ref.read(currentAdminWorksState.notifier).deleteExpert(
                  widget.doctor.rootUserID, ref, Roles.doctor);
            },
            inButtonText: "Hekim Sil",
            primaryColor: CustomColors.errorColorM,
          )
        ],
      ),
    )
        : const Center(
      child: CircularProgressIndicator.adaptive(),
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
            photoUrl: widget.doctor.photoURL,
            onSaved: (value) {
              doctorPhotoFile = value;
            },
            showInArea: true,
          ),
        ),
      ],
    );
  }
}
