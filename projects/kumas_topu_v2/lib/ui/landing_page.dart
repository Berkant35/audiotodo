import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/ui/main_page.dart';

import 'auth/login_page.dart';

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
    //ref.read(rfidStateProvider.notifier).initReader(ref);
    ref.read(viewModelStateProvider.notifier).checkToken().then((value) {
      anyHasToken = value;
      isLoading = false;
      setState(() {});
    });
    ref.read(rfidStateProvider.notifier).initReader(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator.adaptive(),
      )
          : anyHasToken
          ? const MainPage()
          : const LoginPage(),
    );
  }
}
