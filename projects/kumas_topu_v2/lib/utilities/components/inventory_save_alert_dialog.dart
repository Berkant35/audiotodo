import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/global_providers.dart';
import '../constants/app/enums.dart';
import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';
import 'custom_elevated_button.dart';

class InventorySaveAlertDialog extends ConsumerWidget {
  const InventorySaveAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Sayımı Kaydet',
          style: ThemeValueExtension.headline6
              .copyWith(fontWeight: FontWeight.bold)),
      insetPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 1.w),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sayımı kaydedip sonlandırmak için 'Kaydet ve Sonlandır' eğer sadece kaydetmek istiyorsanız 'Kaydet' butonuna tıklayınız!",
              style: ThemeValueExtension.subtitle2.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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
                                .sendTags(ref, false);
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
                                .sendTags(ref, true);
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
