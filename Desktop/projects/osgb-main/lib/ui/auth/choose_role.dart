import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/auth/auth_widgets/logo.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';

import '../../utilities/init/theme/custom_colors.dart';

class ChooseRole extends ConsumerWidget {
  const ChooseRole({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 5, child: Logo()),
          Expanded(
              flex: 7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () =>
                          changeRoleAndGoToLoginPage(Roles.admin, ref),
                      inButtonText: "Admin Giriş",
                      primaryColor: CustomColors.secondaryColorM,
                    ),
                    CustomElevatedButton(
                      onPressed: () =>
                          changeRoleAndGoToLoginPage(Roles.accountant, ref),
                      inButtonText: "Muhasebe Giriş",
                      primaryColor: CustomColors.secondaryColorM,
                    ),
                    CustomElevatedButton(
                      onPressed: () =>
                          changeRoleAndGoToLoginPage(Roles.expert, ref),
                      inButtonText: "Uzman Giriş",
                      primaryColor: CustomColors.primaryColorM,
                    ),
                    CustomElevatedButton(
                      onPressed: () =>
                          changeRoleAndGoToLoginPage(Roles.expert, ref),
                      inButtonText: "Hekim Giriş",
                      primaryColor: CustomColors.primaryColorM,
                    ),
                    CustomElevatedButton(
                      onPressed: () =>
                          changeRoleAndGoToLoginPage(Roles.customer, ref),
                      inButtonText: "İş Yeri Yetkili Giriş",
                      primaryColor: CustomColors.orangeColorM,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  changeRoleAndGoToLoginPage(Roles role, WidgetRef ref) {
    ref.read(currentRole.notifier).changeState(role);
    NavigationService.instance
        .navigateToPage(path: NavigationConstants.loginPage);
  }
}
