import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/core/navigation/navigation_service.dart';
import 'package:audiotodo/core/theme/custom_colors.dart';
import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/utilities/components/buttons/mini_button.dart';
import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/edge_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../generated/l10n.dart';
import '../../utilities/components/buttons/neu_text_button.dart';
import '../../utilities/components/dividers/login_divider.dart';
import '../../utilities/components/form_fields/row_form_field.dart';
import '../../utilities/components/logo/glow_logo.dart';

class AuthLogin extends ConsumerStatefulWidget {
  const AuthLogin({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AuthLoginState();
}

class _AuthLoginState extends ConsumerState<AuthLogin>
    with SingleTickerProviderStateMixin {
  bool isLoginButtonsVisible = true;

  late AnimationController _animationController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final loginFormKey = GlobalKey<FormState>();
  final loginButtonLoadingStateKey = "login_key";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
                flex: 4,
                child: Align(
                    alignment: Alignment.bottomCenter, child: GlowLogo())),
            Expanded(
              flex: 5,
              child: _loginBody(context),
            ),
          ],
        ),
      ),
    );
  }

  Stack _loginBody(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
            isLoginButtonsVisible ? 0 : -MediaQuery.of(context).size.width,
            0,
            0,
          ),
          child: loginButtons(),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
            isLoginButtonsVisible ? 100.w : 0,
            0,
            0,
          ),
          child: loginInputs(emailController, passwordController),
        ),
      ],
    );
  }

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(
          flex: 4,
        ),
        const Expanded(flex: 3, child: LoginDivider()),
        Text(
          S.current.or,
          style: ThemeValueExtension.primary
              .copyWith(color: CustomColors.fillWhiteColor),
        ),
        const Expanded(flex: 3, child: LoginDivider()),
        const Spacer(
          flex: 4,
        ),
      ],
    );
  }

  void _toggleLoginButtonsVisibility() {
    setState(() {
      isLoginButtonsVisible = !isLoginButtonsVisible;
    });
  }

  Row socialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MiniNeuSquare(
          iconData: Icons.apple,
          onPressed: () {},
        ),
        SizedBox(
          width: 5.w,
        ),
        MiniNeuSquare(
          iconData: Icons.g_mobiledata,
          onPressed: () {},
        ),
      ],
    );
  }

  Column loginButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buttonsSign(), buildRow(), socialLoginRow()],
    );
  }

  Widget buttonsLogin() {
    return ref.watch(aLoadingStateManager) != LoadingState.loading
        ? Column(
            children: [
              NeuTextButton(
                  text: S.current.sign_in,
                  isPrimaryButton: true,
                  onPressed: () {
                    loginFormKey.currentState!.save();
                    if (loginFormKey.currentState!.validate()) {
                      ref
                          .read(aLoadingStateManager.notifier)
                          .changeState(LoadingState.loading);

                      ref.read(authManager.notifier).signIn(
                          emailController.text, passwordController.text, ref).then((value){
                            Future.delayed(const Duration(seconds: 1),(){
                              ref
                                  .read(aLoadingStateManager.notifier)
                                  .changeState(LoadingState.loaded);
                            });

                      });
                    }
                  }),
              GapSizedBox.miniGap,
              NeuTextButton(
                  text: S.current.cancel,
                  onPressed: _toggleLoginButtonsVisibility),
            ],
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: CustomColors.fillWhiteColor,
            ),
          );
  }

  Column buttonsSign() {
    return Column(
      children: [
        NeuTextButton(
            text: S.current.sign_in,
            isPrimaryButton: true,
            onPressed: _toggleLoginButtonsVisibility),
        GapSizedBox.miniGap,
        NeuTextButton(
            text: S.current.sign_up,
            onPressed: () => NavigationService.instance
                .navigateToPage(path: NavigationConstants.authRegisterPage)),
      ],
    );
  }

  Widget loginInputs(TextEditingController mailController,
      TextEditingController passwordController) {
    return Padding(
      padding: EdgeInsets.all(EdgeExtension.mediumEdge.edgeValue),
      child: Form(
        key: loginFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RowFormField(
                  headerName: S.current.email,
                  inputType: TextInputType.text,
                  editingController: mailController,
                  custValidateFunction: (value) =>
                      value!.isEmpty ? S.current.blank_empty : null),
              RowFormField(
                editingController: passwordController,
                headerName: S.current.password,
                visibleStatus: true,
                custValidateFunction: (value) =>
                    value != null && value.isNotEmpty
                        ? value.length >= 8
                            ? null
                            : S.current.password_min_eight_character
                        : S.current.blank_empty,
              ),
              GapSizedBox.miniGap,
              buttonsLogin(),
              GapSizedBox.miniGap,
            ],
          ),
        ),
      ),
    );
  }
}
