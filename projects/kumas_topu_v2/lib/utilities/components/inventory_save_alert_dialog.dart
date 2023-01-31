import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/global_providers.dart';
import '../constants/app/enums.dart';
import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';
import 'custom_elevated_button.dart';

class InventorySaveAlertDialog extends ConsumerWidget {
  final bool isShipment;


  const InventorySaveAlertDialog({
    Key? key,
    required this.isShipment
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Sayımı Kaydet',
              style: ThemeValueExtension.headline6
                  .copyWith(fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: () => NavigationService.instance.navigatePopUp(),
              icon: Icon(
                Icons.cancel_outlined,
                size: 8.h,
              ))
        ],
      ),
      insetPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'Sayımı kaydedip sonlandırmak için ',
                style: ThemeValueExtension.subtitle2
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                      text: " 'Kaydet ve Sonlandır' ",
                      style: ThemeValueExtension.subtitle2
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        'eğer daha sonra kaldığınız yerden sayıma devam etmek istiyorsanız sadece',
                    style: ThemeValueExtension.subtitle2.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                      text: " 'Kaydet' ",
                      style: ThemeValueExtension.subtitle2
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'butonuna tıklayınız!',
                      style: ThemeValueExtension.subtitle2.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ref.watch(loginButtonStateProvider) != LoadingStates.loading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                          onPressed: () {
                            ref
                                .read(viewModelStateProvider.notifier)
                                .sendTags(ref, false,isShipment)
                                .then((value) {
                              NavigationService.instance.navigatePopUp();
                            });
                          },
                          inButtonText: "Kaydet",
                          primaryColor: CustomColors.primaryColorM),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          "Veya",
                          style: ThemeValueExtension.subtitle.copyWith(
                              color: CustomColors.customGreyColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      CustomElevatedButton(
                          onPressed: () {
                            ref
                                .read(viewModelStateProvider.notifier)
                                .sendTags(ref, true,isShipment)
                                .then((value) => NavigationService.instance
                                    .navigateToPageClear(
                                        path: NavigationConstants.mainPage));
                          },
                          inButtonText: "Kaydet ve Sonlandır",
                          primaryColor: CustomColors.darkPurpleColorM),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
          ],
        ),
      ),
    );
  }
}
