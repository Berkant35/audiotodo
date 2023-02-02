import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accountant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utilities/components/custom_elevated_button.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/seperate_padding.dart';
import '../../../../utilities/components/single_photo_container.dart';
import '../../../../utilities/constants/app/application_constants.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

import '../../../../utilities/init/theme/custom_colors.dart';

class AddAccoundant extends ConsumerStatefulWidget {
  const AddAccoundant({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddAccoundantState();
}

class _AddAccoundantState extends ConsumerState<AddAccoundant> {
  final _accountantFormKey = GlobalKey<FormState>();
  late TextEditingController accountantEmail;
  late TextEditingController accountantNameAndSurname;
  late TextEditingController accountantPassword;
  late TextEditingController accountantPhoneNumber;
  File? localPathOfPath;

  @override
  void initState() {
    super.initState();
    accountantEmail = TextEditingController();
    accountantPassword = TextEditingController();
    accountantNameAndSurname = TextEditingController();
    accountantPhoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    accountantEmail.dispose();
    accountantPassword.dispose();
    accountantNameAndSurname.dispose();
    accountantPhoneNumber.dispose();
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
                  key: _accountantFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "Muhasebeci Ekle",
                        style: ThemeValueExtension.headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RowFormField(
                        editingController: accountantNameAndSurname,
                        headerName: 'Muhasebeci Adı ve Soyadı',
                        hintText: "Adı",
                        custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: accountantEmail,
                        headerName: 'Muhasebeci E-mail',
                        inputType: TextInputType.emailAddress,
                        hintText: "E-Mail",
                        custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      RowFormField(
                        editingController: accountantPassword,
                        headerName: 'Muhasebeci Şifre',
                        hintText: "Şifre",
                        visibleStatus: true,
                        custValidateFunction: (value) =>
                        value != "" && value != null ? value.length>=6 ? null : "Şifre 6 karakterden fazla olmalıdır" : "Bu alan boş bırakılamaz",
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: seperatePadding(),
                            child: Text(
                              "Fotoğraf Ekle",
                              style: ThemeValueExtension.subtitle,
                            ),
                          ),
                          SinglePhotoArea(
                            onSaved: (file) {
                              localPathOfPath = file;
                            },
                            showInArea: true,
                          ),
                        ],
                      ),
                      RowFormField(
                        editingController: accountantPhoneNumber,
                        headerName: 'Muhasebeci Telefon',
                        hintText: ApplicationConstants.hintPhoneNumber,
                        inputType: TextInputType.phone,
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
                      ref.watch(currentButtonLoadingState) != LoadingStates.loading
                          ? CustomElevatedButton(
                        onPressed: () {
                          _accountantFormKey.currentState!.save();

                          if(_accountantFormKey.currentState!.validate()){
                            var accountant = Accountant(
                                typeOfUser: "accountant",
                                accountantEmail: accountantEmail.text,
                                accountantName: accountantNameAndSurname.text,
                                accountantPhoneNumber:
                                accountantPhoneNumber.text);
                            ref
                                .read(currentAdminWorksState.notifier)
                                .createAccountant(
                                accountant,
                                accountantEmail.text,
                                accountantPassword.text,
                                ref,
                                localPathOfPath,
                                Roles.accountant);
                          }

                        },
                        inButtonText: "Muhasebeci Ekle",
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
}
