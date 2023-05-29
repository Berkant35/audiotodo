import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/core/navigation/navigation_service.dart';
import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/theme/custom_colors.dart';

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
    ref.read(authManager.notifier).currentUser(ref).then((value) {
      if (value != null) {


        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.mainBase);
      } else {
        NavigationService.instance
            .navigateToPage(path: NavigationConstants.authLoginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: CustomColors.primaryColor,
      child: const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: CustomColors.fillWhiteColor,
        ),
      ),
    );
  }
}
