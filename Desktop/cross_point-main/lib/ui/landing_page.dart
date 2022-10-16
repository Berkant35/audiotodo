import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/ui/auth/login_page.dart';
import 'package:cross_point/utilities/common_widgets/custom_button.dart';
import 'package:cross_point/utilities/constants/image_path.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/extensions/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base/base.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool anyHasToken = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ref.read(rfidStateProvider.notifier).initReader(ref);
    ref.read(viewModelStateProvider.notifier).checkToken().then((value) {
      anyHasToken = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : anyHasToken
              ? const BasePage()
              : const LoginPage(),
    );
  }
}
