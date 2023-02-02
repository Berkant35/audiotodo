import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/local/local_manager.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../utilities/components/download_image.dart';
import '../../../utilities/components/drawer_budgets.dart';
import '../../../utilities/constants/app/assets.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final localManager = LocaleManager();
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            logo(),
            content(context),
            logOut(localManager),
            const Spacer()
          ]),
    );
  }

  Expanded logOut(LocaleManager localManager) {
    return Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            onPressed: () async {
              await ref
                  .read(currentBaseModelState.notifier)
                  .logOut(ref)
                  .then((value) {
                localManager.setPassword("");
                localManager.setEmail("");
              });
            },
            child: Text(
              "Çıkış yap",
              style: ThemeValueExtension.subtitle
                  .copyWith(color: CustomColors.pinkColor),
            ),
          ),
        ));
  }

  Expanded content(BuildContext context) {
    return Expanded(
      flex: 14,
      child: SizedBox(
        width: 100.w,
        child: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => setState(() {}),
                  icon: Icon(
                    Icons.refresh,
                    size: 2.h,
                  ),
                ),
              ),
              titleOfDrawer(ref),
              const Divider(),
              perDrawerItem(ref, Icons.password_sharp, "Şifreyi Yenile",
                  NavigationConstants.updatePasswordPage, null, context),
              SizedBox(
                height: 1.5.h,
              ),
              qrPart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget qrPart(BuildContext context) {
    return ref.read(currentRole) == Roles.customer
        ? perDrawerItem(
            ref,
            Icons.qr_code_2,
            "QR Göster",
            null,
            Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Text(
                  "QR İşlem",
                  style: ThemeValueExtension.subtitle,
                ),
              ),
              body: DownloadImage(
                imageLink: ref.read(currentBaseModelState).customer!.qrCodeURL!,
                fileName:
                    ref.read(currentBaseModelState).customer!.customerName!,
              ),
            ),
            context)
        : const SizedBox();
  }

  Expanded logo() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Image.asset(
          Assets.logoPNG,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

InkWell perDrawerItem(WidgetRef ref, IconData iconData, String content,
    String? path, Widget? widget, BuildContext context) {
  return InkWell(
    onTap: () => path != null
        ? NavigationService.instance.navigateToPage(path: path)
        : Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget!)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Icon(
            iconData,
            color: CustomColors.pinkColor,
            size: 4.h,
          ),
        ),
        Expanded(
          flex: 8,
          child: Text(
            content,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}

Column titleOfDrawer(WidgetRef ref) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Merhaba,",
        style: ThemeValueExtension.headline6.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        getNameOfAccount(ref),
        style: ThemeValueExtension.subtitle
            .copyWith(color: CustomColors.primaryColor),
      ),
      const DrawerBudgets()
    ],
  );
}

String getNameOfAccount(WidgetRef ref) {
  switch (ref.read(currentRole)) {
    case Roles.none:
      return "-";
    case Roles.admin:
      return "Admin";
    case Roles.accountant:
      return ref.read(currentBaseModelState).accountant!.accountantName!;
    case Roles.customer:
      return ref.read(currentBaseModelState).customer!.customerName!;
    case Roles.expert:
      return ref.read(currentBaseModelState).expert!.expertName!;
    case Roles.doctor:
      return ref.read(currentBaseModelState).doctor!.doctorName!;
    case Roles.worker:
      return "-";
  }
}
