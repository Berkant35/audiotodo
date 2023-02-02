import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/auth/login_page.dart';
import 'package:osgb/utilities/constants/app/enums.dart';


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
    super.initState();
    prepareLogin();
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

  Future<void> prepareLogin() async {

    Future.delayed(
        const Duration(seconds: 2), () async {
          if(ref.read(currentLoadingState) != LoadingStates.loading){
            ref.read(currentLoadingState.notifier)
                .changeState(LoadingStates.loading);
          }else{
            ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
            ref.read(currentLoadingState.notifier)
            .changeState(LoadingStates.loading);
          }
          await ref.read(currentRole.notifier)
                   .checkLoggedAnyUser(ref);
    });
  }
}
