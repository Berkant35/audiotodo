import 'package:cross_point/utilities/constants/image_path.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/constants/custom_colors.dart';
import '../../utilities/extensions/font_theme.dart';
import 'auth_widgets/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController controller1;
  late TextEditingController controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = TextEditingController(text: "crosspoint@uniqueid.nl");
    controller2 = TextEditingController(text: "s32879crds");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.height * 0.08),
            child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(ImagePath.logoPng,
                    fit: BoxFit.contain, width: context.width * 0.85)),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: context.lowValue),
                child: Text(
                  'powered by Unique ID',
                  style: ThemeValueExtension.subtitle3.copyWith(
                      color: CustomColors.grimsi, fontWeight: FontWeight.w600),
                ),
              )),
          LoginForm(controller1, controller2)
        ],
      ),
    );
  }
}
