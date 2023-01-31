import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/row_form_field.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:kumas_topu/utilities/constants/extension/edge_extension.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/global_providers.dart';
import '../constants/extension/context_extensions.dart';
import '../constants/extension/image_path.dart';
import '../init/theme/custom_colors.dart';

class LoginForm extends ConsumerStatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const LoginForm(
    this.controller1,
    this.controller2, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  bool showPassword = true;
  final validateForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: seperatePadding(),
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(EdgeExtension.lowEdge.edgeValue))),
          child: Center(child: buildForm(context)),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
        key: validateForm,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 12.h,
                    width: 60.w,
                    child: Image.asset(
                      ImagePath.logoPng,
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: RowFormField(
                    headerName: "Email",
                    prefixIcon: Icons.perm_identity_sharp,
                    hintText: "E-mail",
                    editingController: widget.controller1,
                    custValidateFunction: (value) {
                      (value != "") ? "Boş Bırakılamaz" : null;
                    }),
              ),
              SizedBox(height: MediaQueryExtension(context).lowValue),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: RowFormField(
                    headerName: "Şifre",
                    prefixIcon: Icons.key,
                    editingController: widget.controller2,
                    visibleStatus: true,
                    hintText: "Şifre",
                    custValidateFunction: (value) {
                      (value != "") ? "Boş Bırakılamaz" : null;
                    }),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: ref.watch(loginButtonStateProvider) !=
                        LoadingStates.loading
                    ? CustomElevatedButton(
                        width: 50.w,
                        onPressed: () {
                          validateForm.currentState!.save();
                          if(validateForm.currentState!.validate())
                          {
                            ref.read(viewModelStateProvider.notifier).login(
                                widget.controller1.text,
                                widget.controller2.text,
                                ref);
                          }

                        },
                        inButtonText: 'Giriş Yap',
                        primaryColor: CustomColors.primaryColorM,
                      )
                    : const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
              ),

            ],
          ),
        ));
  }
}
