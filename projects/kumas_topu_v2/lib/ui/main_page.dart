import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/line/native/native_manager.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/per_item_of_menu.dart';
import 'package:kumas_topu/utilities/constants/app/application_constants.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants/extension/image_path.dart';
import '../utilities/init/theme/custom_colors.dart';

class MainPage extends ConsumerWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          ImagePath.logoWhitePng,
          height: 8.h,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Çıkış Yapmaktan Emin Misiniz?",
                          style: ThemeValueExtension.subtitle,
                          textAlign: TextAlign.center,
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomElevatedButton(
                              onPressed: () => ref
                                  .read(viewModelStateProvider.notifier)
                                  .logout(),
                              inButtonText: "Evet",
                              primaryColor: CustomColors.primaryColorM,
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            CustomElevatedButton(
                              onPressed: () =>
                                  NavigationService.instance.navigatePopUp(),
                              inButtonText: "Hayır",
                              primaryColor: CustomColors.darkPurpleColorM,
                              width: 25.w,
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              ImagePath.mainBackJpeg,
              height: 30.h,
              width: 100.w,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              SizedBox(
                height: 60.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GridView.count(
                    primary: false,
                    crossAxisSpacing: 2.h,
                    mainAxisSpacing: 0,
                    crossAxisCount: 2,
                    children: <Widget>[
                      PerItemOfMenu(
                          imagePath: ImagePath.barcodeSvg,
                          scaleHigh: 8.h,
                          title: 'KODLAMA',
                          onTap: () async {
                            await SystemChannels.platform.invokeMethod<void>(
                              'SystemSound.play',
                              SystemSoundType.click.toString(),
                            );
                            ref
                                .read(currentTriggerModeProvider.notifier)
                                .changeState(TriggerModeStatus.BARCODE, ref);
                            NavigationService.instance.navigateToPage(
                                path: NavigationConstants.encodeMainPage);
                          }),
                      PerItemOfMenu(
                          imagePath: ImagePath.wifiTruckSvg,
                          title: 'SEVK',
                          onTap: () async {
                            ref
                                .read(currentIsShipmentProvider.notifier)
                                .changeState(true);
                            await SystemChannels.platform.invokeMethod<void>(
                              'SystemSound.play',
                              SystemSoundType.click.toString(),
                            );
                            NavigationService.instance.navigateToPage(
                                path: NavigationConstants.inventoryMainPage);
                          }),
                      PerItemOfMenu(
                          imagePath: ImagePath.addSvg,
                          scaleHigh: 8.h,
                          title: 'SAYIM',
                          onTap: () async {
                            ref
                                .read(currentIsShipmentProvider.notifier)
                                .changeState(false);
                            await SystemChannels.platform.invokeMethod<void>(
                              'SystemSound.play',
                              SystemSoundType.click.toString(),
                            );
                            NavigationService.instance.navigateToPage(
                                path: NavigationConstants.inventoryMainPage);
                          }),
                      PerItemOfMenu(
                          imagePath: ImagePath.settingsSvg,
                          scaleHigh: 9.h,
                          title: 'AYARLAR',
                          onTap: () async {
                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            AndroidDeviceInfo androidInfo =
                                await deviceInfo.androidInfo;
                            double maxPower = 0.0;
                            if (androidInfo.brand.toUpperCase() == "ZEBRA") {
                              maxPower = 300.0;
                            } else {
                              maxPower = 30.0;
                            }

                            await SystemChannels.platform.invokeMethod<void>(
                              'SystemSound.play',
                              SystemSoundType.click.toString(),
                            );
                            NavigationService.instance.navigateToPage(
                                path: NavigationConstants.settingsPage,
                                data: {"maxValue": maxPower});
                          }),
                      PerItemOfMenu(
                          imagePath: ImagePath.searchSvg,
                          scaleHigh: 9.h,
                          title: 'İNCELE',
                          onTap: () async {
                            await SystemChannels.platform.invokeMethod<void>(
                              'SystemSound.play',
                              SystemSoundType.click.toString(),
                            );

                            NativeManager.instance!.listenAndSingleInventory(ref);


                            NavigationService.instance.navigateToPage(
                                path: NavigationConstants.detailOfProductPage);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: _launchUrl,
              child: Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  ApplicationConstants.uniqueidURL,
                  style: ThemeValueExtension.subtitle2
                      .copyWith(color: CustomColors.pinkColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(
        Uri.parse("https://${ApplicationConstants.uniqueidURL}"))) {
      throw 'Could not launch ${ApplicationConstants.uniqueidURL}';
    }
  }
}
