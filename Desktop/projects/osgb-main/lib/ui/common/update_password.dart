import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/row_form_field.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/init/theme/custom_colors.dart';

class UpdatePassword extends ConsumerStatefulWidget {
  const UpdatePassword({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends ConsumerState<UpdatePassword> {
  late TextEditingController currentPassword;
  late TextEditingController changePassword;
  late TextEditingController changeCheckPassword;
  final _updatePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentPassword = TextEditingController();
    changePassword = TextEditingController();
    changeCheckPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    currentPassword.dispose();
    changePassword.dispose();
    changeCheckPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 8.w,
        title: InkWell(
          onTap: () => NavigationService.instance.navigatePopUp(),
          child: Text(
            "Şifreyi Yenile",
            style: ThemeValueExtension.subtitle,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: seperatePadding(),
        child: Form(
          key: _updatePasswordFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Şifrenizi Güncelleyin",
                style: ThemeValueExtension.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              RowFormField(
                headerName: "Mevcut Şifre",
                editingController: currentPassword,
                visibleStatus: true,
                custValidateFunction: (value) =>
                value != "" && value != null
                    ? value.length >= 6
                    ? null
                    : "Şifre 6 karakterden fazla olmalıdır"
                    : "Bu alan boş bırakılamaz",
              ),
              RowFormField(
                headerName: "Yeni Şifre",
                editingController: changePassword,
                visibleStatus: true,
                custValidateFunction: (value) =>
                value != "" && value != null
                    ? value.length >= 6
                    ? null
                    : "Şifre 6 karakterden fazla olmalıdır"
                    : "Bu alan boş bırakılamaz",
              ),
              RowFormField(
                headerName: "Yeni Şifre Yeniden",
                editingController: changeCheckPassword,
                visibleStatus: true,
                custValidateFunction: (value) =>
                value != "" && value != null
                    ? value.length >= 6
                    ? null
                    : "Şifre 6 karakterden fazla olmalıdır"
                    : "Bu alan boş bırakılamaz",
              ),
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: ref.watch(currentButtonLoadingState) !=
                    LoadingStates.loading
                    ? CustomElevatedButton(
                  onPressed: () {
                    _updatePasswordFormKey.currentState!.save();
                    if (changeCheckPassword.text == changePassword.text) {
                      if (_updatePasswordFormKey.currentState!
                          .validate()) {
                        ref.read(currentBaseModelState.notifier)
                            .updatePassword(
                            currentPassword.text, changePassword.text, ref);
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Şifreler eşleşmiyor!");
                    }
                  },
                  inButtonText: "Şifreyi Güncelle",
                  primaryColor: CustomColors.secondaryColorM,
                )
                    : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
