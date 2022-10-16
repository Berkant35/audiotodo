import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/utilities/common_widgets/flutter_toast_dialog.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layers/view_models/login_state_manager.dart';
import '../../../utilities/constants/custom_colors.dart';
import '../../../utilities/constants/values.dart';
import '../../../utilities/custom_functions.dart';
import '../../../utilities/extensions/EdgeExtension.dart';
import '../../../utilities/extensions/font_theme.dart';
import '../../base/base.dart';
import 'login_form_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const LoginForm(this.controller1, this.controller2, {Key? key})
      : super(key: key);

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
        padding: EdgeInsets.only(
            bottom: context.height * (AllFunc.isPhone() ? 0.02 : 0.09),
            top: context.height * 0.08),
        child: Material(
          borderRadius:
              const BorderRadius.all(Radius.circular(Values.radiusValue)),
          elevation: 5,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(Values.radiusValue)),
            child: Container(
              height: MediaQueryExtension(context).height / (1.8),
              width: MediaQueryExtension(context).width /
                  (AllFunc.isPhone() ? 1.24 : 1.48),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Values.radiusValue))),
              child: buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
        key: validateForm,
        child: SizedBox(
          height: MediaQueryExtension(context).height / 2,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQueryExtension(context).height / 22,
                ),
                Center(
                  child: Text(
                    'Log In',
                    style: ThemeValueExtension.subtitle2,
                  ),
                ),
                SizedBox(
                  height: MediaQueryExtension(context).height / 22,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQueryExtension(context).lowValue,
                      left: MediaQueryExtension(context).width / 14),
                  child: Text(
                    'E-mail',
                    style: ThemeValueExtension.subtitle3,
                  ),
                ),
                LoginFormField(
                  isAvailablePaste: false,
                  controller: widget.controller1,
                  initialValue: 'E-mail',
                  counterText: '',
                  contentPadding: EdgeInsets.only(left: context.lowValue),
                  maxLengthWord: 50,
                  inputType: TextInputType.emailAddress,
                  validateFunction: (String? value) {
                    return value.toString().contains('@') &&
                            (value.toString().contains('com') ||
                                value.toString().contains('nl'))
                        ? null
                        : 'Invalid email';
                  },
                ),
                SizedBox(height: MediaQueryExtension(context).lowValue),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQueryExtension(context).lowValue,
                      left: MediaQueryExtension(context).width / 14),
                  child: Text(
                    'Password',
                    style: ThemeValueExtension.subtitle3,
                  ),
                ),
                LoginFormField(
                  counterText: '',
                  controller: widget.controller2,
                  initialValue: 'Password',
                  inputType: TextInputType.text,
                  goster: showPassword,
                  validateFunction: (String? value) {
                    return value.toString().isNotEmpty
                        ? null
                        : 'Invalid password';
                  },
                  contentPadding: EdgeInsets.only(
                      top: context.lowValue * 2, left: context.lowValue),
                  preicon: null,
                  suficon: Padding(
                    padding:
                        EdgeInsets.only(right: EdgeExtension.lowEdge.edgeValue),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Icon(
                          showPassword == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: AllFunc.isPhone() ? 24 : 40,
                          color: CustomColors.crossPointLight,
                        )),
                  ),
                ),
                SizedBox(height: MediaQueryExtension(context).normalValue),
                Center(
                  child: ref.watch(loginButtonStateProvider) ==
                          LoadingStates.loaded
                      ? Container(
                          width: MediaQueryExtension(context).width *
                              (AllFunc.isPhone() ? 0.66 : 0.4),
                          height: context.height * 0.06,
                          decoration: BoxDecoration(
                              color: CustomColors.crossPointDark,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  EdgeExtension.lowEdge.edgeValue / 2))),
                          child: InkWell(
                            onTap: () async {
                              validateForm.currentState!.save();
                              if (validateForm.currentState!.validate()) {
                                //Login...
                                ref.read(viewModelStateProvider.notifier).login(
                                    widget.controller1.text,
                                    widget.controller2.text,
                                    ref);
                              }
                            },
                            child: Center(
                              child: Text(
                                'Log In',
                                style: AllFunc.isPhone()
                                    ? ThemeValueExtension.subtitle2.copyWith(
                                        color: Colors.white,
                                        letterSpacing: -0.9)
                                    : ThemeValueExtension.subtitle3
                                        .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator.adaptive(),
                ),
                SizedBox(
                  height: MediaQueryExtension(context).height / 18,
                ),
              ],
            ),
          ),
        ));
  }
}
