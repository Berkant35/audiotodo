import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/auth/auth_widgets/logo.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/input_form_field.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/init/theme/custom_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _authFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        leadingWidth: 4.w,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _authFormKey,
            child: Column(
              children: [
                const Logo(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Giriş",
                            style: ThemeValueExtension.headline6.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        getSpaceColumn(2),
                        Text(
                          "Kullanıcı Adı",
                          style: ThemeValueExtension.subtitle
                              .copyWith(color: Colors.black),
                        ),
                        getSpaceColumn(1),
                        CustomFormField(
                          authEditingFormController: emailController,
                          validateFunction: (value) {
                            return value != "" ? null : "Boş Bırakılamaz";
                          },
                          iconData: const Icon(Icons.account_circle_outlined),
                          hintText: "E-mail",
                        ),
                        customSpace(),
                        Text(
                          "Şifre",
                          style: ThemeValueExtension.subtitle
                              .copyWith(color: Colors.black),
                        ),
                        getSpaceColumn(1),
                        CustomFormField(
                          authEditingFormController: passwordController,
                          validateFunction: (value) {
                            return value != "" ? null : "Boş Bırakılamaz";
                          },
                          visibleStatus: true,
                          hintText: "Şifre",
                          iconData: const Icon(Icons.lock_outline_rounded),
                        ),
                        getSpaceColumn(3),
                        Center(
                          child: ref.watch(currentButtonLoadingState) !=
                                  LoadingStates.loading
                              ? CustomElevatedButton(
                                  onPressed: () {
                                    _authFormKey.currentState!.save();
                                    if (_authFormKey.currentState!.validate()) {
                                      ref.read(currentRole.notifier).signIn(
                                          emailController.text,
                                          passwordController.text,
                                          ref);
                                    }
                                  },
                                  inButtonText: "Giriş Yap",
                                  primaryColor: CustomColors.secondaryColorM,
                                )
                              : const CircularProgressIndicator.adaptive(),
                        ),
                        getSpaceColumn(3)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column getSpaceColumn(int amount) {
    return Column(
      children: [
        for (int i = 0; i < amount; i++) customSpace(),
      ],
    );
  }

  SizedBox customSpace() => SizedBox(
        height: 2.w,
      );
}
