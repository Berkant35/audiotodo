import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../line/viewmodel/global_providers.dart';
import '../../../utilities/components/custom_elevated_button.dart';
import '../../../utilities/components/custom_flexible_bar.dart';
import '../../../utilities/components/row_form_field.dart';
import '../../../utilities/components/single_photo_container.dart';
import '../../../utilities/constants/app/application_constants.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class AccountantDetail extends ConsumerStatefulWidget {
  final Accountant accountant;

  const AccountantDetail({Key? key, required this.accountant})
      : super(key: key);

  @override
  ConsumerState createState() => _AccountantDetailState();
}

class _AccountantDetailState extends ConsumerState<AccountantDetail> {
  final _accountantFromKey = GlobalKey<FormState>();

  late TextEditingController accountantNameController;
  late TextEditingController accountantPhoneNumberController;
  File? accountantPhotoFile;

  @override
  void initState() {
    super.initState();
    accountantNameController =
        TextEditingController(text: widget.accountant.accountantName);
    accountantPhoneNumberController =
        TextEditingController(text: widget.accountant.accountantPhoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    accountantNameController.dispose();
    accountantPhoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
        flexibleSpace: CustomFlexibleBar(
            firstHeader: ref.watch(currentCustomFlexibleAppBarState).header1,
            secondHeader: ref.watch(currentCustomFlexibleAppBarState).header2,
            thirdHeader: ref.watch(currentCustomFlexibleAppBarState).header3,
            firstInfo: ref.watch(currentCustomFlexibleAppBarState).content1,
            secondInfo: ref.watch(currentCustomFlexibleAppBarState).content2,
            thirdInfo: ref.watch(currentCustomFlexibleAppBarState).content3,
            headerPhoto: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
            role: Roles.expert,
            appBarTitle: "Muhasebeci Detay"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: seperatePadding(),
          child: Form(
            key: _accountantFromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text("Düzenle",
                    style: ThemeValueExtension.headline6
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                RowFormField(
                  editingController: accountantNameController,
                  headerName: 'Muhasebeci Adı ve Soyadı',
                  inputType: TextInputType.name,
                  hintText: "Adı",
                  custValidateFunction: (value) =>
                  value != "" ? null : "Bu alan boş bırakılamaz",
                ),
                colAddPhoto(),
                RowFormField(
                  editingController: accountantPhoneNumberController,
                  headerName: 'Muhasebeci Telefon',
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
                SizedBox(height: 2.h,),
                ref.watch(currentButtonLoadingState) != LoadingStates.loading
                    ? Center(
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          _accountantFromKey.currentState!.save();
                          if (_accountantFromKey.currentState!.validate()) {
                            var doctor = Accountant(
                              rootUserID: widget.accountant.rootUserID,
                              typeOfUser: 'muhasebeci',
                              accountantEmail: widget.accountant.accountantEmail,
                              photoURL: widget.accountant.photoURL,
                              pushToken: widget.accountant.pushToken,
                              accountantName: accountantNameController.text,
                              accountantPhoneNumber:
                              accountantPhoneNumberController.text,
                            );
                            ref
                                .read(currentAdminWorksState.notifier)
                                .updateAccountant(doctor, ref,
                                accountantPhotoFile, Roles.accountant);
                          }
                        },
                        inButtonText: "Muhasebeci Güncelle",
                        primaryColor: CustomColors.secondaryColorM,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomElevatedButton(
                        onPressed: () {

                          ref
                              .read(currentAdminWorksState.notifier)
                              .deleteAccountant(
                              widget.accountant.rootUserID, ref).then((value){
                            ref.read(currentAdminDashboardTabManager.notifier).changeState(0);
                            ref.read(currentAddUserIndexState.notifier).changeState(0);

                          });
                        },
                        inButtonText: "Muhasebeci Sil",
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
            photoUrl: widget.accountant.photoURL,
            onSaved: (value) {
              accountantPhotoFile = value;
            },
            showInArea: true,
          ),
        ),
      ],
    );
  }
}
