import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/main.dart';
import 'package:osgb/ui/auth/login_page.dart';
import 'package:osgb/utilities/constants/app/application_constants.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    prepareLogin(ref);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(currentLoadingState) == LoadingStates.loaded
          ? const LoginPage()
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Future<void> prepareLogin(WidgetRef ref) async {

    logger.i("Prepare Login");



    Future.delayed(const Duration(seconds: 2), () async {
      if (ref.read(currentLoadingState) != LoadingStates.loading) {
        ref
            .read(currentLoadingState.notifier)
            .changeState(LoadingStates.loading);
      } else {
        ref
            .read(currentLoadingState.notifier)
            .changeState(LoadingStates.loaded);
        ref
            .read(currentLoadingState.notifier)
            .changeState(LoadingStates.loading);
      }
      await ref.read(currentRole.notifier).checkLoggedAnyUser(ref);
    });
  }
}
