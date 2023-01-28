import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/constants/extension/image_path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/components/custom_svg.dart';
import '../../utilities/components/login_form.dart';

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
    super.initState();
    controller1 = TextEditingController(text: "murat@ilgazi.com");
    controller2 = TextEditingController(text: "jum2ktdbsd");
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
          LoginForm(controller1, controller2),
        ],
      ),
    );
  }
}

