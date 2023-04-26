import 'dart:io';

import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/models/user_model.dart';
import 'package:audiotodo/utilities/components/buttons/mini_button.dart';
import 'package:audiotodo/utilities/components/dialogs/auth_dialogs.dart';
import 'package:audiotodo/utilities/components/form_fields/row_form_field.dart';
import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/edge_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/icon_size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/navigation/navigation_service.dart';
import '../../core/theme/custom_colors.dart';
import '../../generated/l10n.dart';
import '../../utilities/components/containers/custom_bar_container.dart';

class AuthRegisterPage extends ConsumerStatefulWidget {
  const AuthRegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends ConsumerState<AuthRegisterPage> {
  late TextEditingController userNameController;
  late TextEditingController surnameController;
  late TextEditingController mailController;
  late TextEditingController passwordController;
  late TextEditingController againPasswordController;
  final registerKey = GlobalKey<FormState>();
  String _registerLoginKey = "register_button";

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    surnameController = TextEditingController();
    mailController = TextEditingController();
    passwordController = TextEditingController();
    againPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    surnameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    againPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: GestureDetector(
          onTap: () => Focus.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: CustomBarContainer(
                    text: S.current.sign_up,
                  )),
              Expanded(flex: 3, child: _headerOfRegister()),
              Expanded(
                  flex: 17,
                  child: Container(
                    color: CustomColors.primaryColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: EdgeExtension.highEdge.edgeValue),
                      child: Form(
                        key: registerKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              RowFormField(
                                  headerName: S.current.username,
                                  inputType: TextInputType.text,
                                  editingController: userNameController,
                                  custValidateFunction: (value) =>
                                      value!.isEmpty
                                          ? S.current.blank_empty
                                          : null),
                              RowFormField(
                                  headerName: S.current.surname,
                                  inputType: TextInputType.text,
                                  editingController: surnameController,
                                  custValidateFunction: (value) =>
                                      value!.isEmpty
                                          ? S.current.blank_empty
                                          : null),
                              RowFormField(
                                  headerName: S.current.email,
                                  inputType: TextInputType.emailAddress,
                                  editingController: mailController,
                                  custValidateFunction: (value) =>
                                      value!.isEmpty
                                          ? S.current.blank_empty
                                          : null),
                              RowFormField(
                                editingController: passwordController,
                                headerName: S.current.password,
                                visibleStatus: true,
                                custValidateFunction: (value) => value !=
                                            null &&
                                        value.isNotEmpty
                                    ? value.length >= 8
                                        ? null
                                        : S.current.password_min_eight_character
                                    : S.current.blank_empty,
                              ),
                              RowFormField(
                                editingController: againPasswordController,
                                headerName: S.current.password,
                                visibleStatus: true,
                                custValidateFunction: (value) =>
                                    value != null && value.isNotEmpty
                                        ? value.length >= 8
                                            ? againPasswordController.text !=
                                                    passwordController.text
                                                ? S.current.passwords_not_same
                                                : null
                                            : S.current
                                                .password_min_eight_character
                                        : S.current.blank_empty,
                              ),
                              GapSizedBox.smallGap,
                              ref.watch(aLoadingStateManager) !=
                                      LoadingState.loading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MiniNeuSquare(
                                          iconData: Icons.arrow_back,
                                          onPressed: () => NavigationService
                                              .instance
                                              .navigatePopUp(),
                                        ),
                                        MiniNeuSquare(
                                          iconData: Icons.arrow_forward_rounded,
                                          onPressed: register,
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor:
                                            CustomColors.fillWhiteColor,
                                      ),
                                    ),
                              GapSizedBox.mediumGap,
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    ref.read(aLoadingStateManager.notifier).changeState(LoadingState.loading);

    registerKey.currentState!.save();
    if (registerKey.currentState!.validate()) {
      var newUser = UserModel(
          email: mailController.text,
          userName: userNameController.text,
          surName: surnameController.text,
          platform: Platform.isAndroid ? "android" : 'ios');

      ref
          .read(currentLoadingStateManager.notifier)
          .changeState(_registerLoginKey, LoadingState.loaded);

      ref
          .read(authManager.notifier)
          .createCustomUserWithEmailAndPassword(
              mailController.text, passwordController.text, newUser, ref)
          .then((value) =>
              value ? AuthDialogs.createUserActionSuccess(ref) : null);
    }
  }

  Container _headerOfRegister() {
    return Container(
      color: CustomColors.primaryColor,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: EdgeExtension.hugeEdge.edgeValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Text(
                  S.current.welcome_to_audiotodo,
                  style: ThemeValueExtension.titleTextStyle
                      .copyWith(color: CustomColors.fillWhiteColor),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Icon(
                  Icons.person,
                  size: IconSizeExtension.huge.sizeValue,
                  color: CustomColors.fillWhiteColor,
                )),
          ],
        ),
      ),
    );
  }
}
