import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/components/appbars/title_app_bar.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:kumas_topu/utilities/init/theme/custom_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/global_providers.dart';
import '../../utilities/components/custom_svg.dart';
import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/constants/extension/image_path.dart';

class MatchWithRFID extends ConsumerStatefulWidget {
  const MatchWithRFID({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MatchWithRFIDState();
}

class _MatchWithRFIDState extends ConsumerState<MatchWithRFID> {

  @override
  void initState() {
    super.initState();
    ref
        .read(
        currentTriggerModeProvider.notifier)
        .nativeManager
        .listenTriggerForWriteMode(
        ref,
        ref
            .read(
            currentBarcodeInfoProvider)
            .epc!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        label: "RFID Eşleştirme",
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CustomSvg(
          imagepath: ImagePath.rfidSvg,
          width: 30.w,
        ),
        bodyFlow(),
        matchButton()
      ]),
    );
  }

  Widget matchButton() {
    return ref.watch(loginButtonStateProvider) != LoadingStates.loading
        ? CustomElevatedButton(
            onPressed: ref.read(currentBarcodeInfoProvider).epc != null
                ? () {
                    ref
                        .read(currentTriggerModeProvider.notifier)
                        .nativeManager
                        .writeData(
                            ref, ref.read(currentBarcodeInfoProvider).epc!);
                  }
                : null,
            inButtonText: "EŞLEŞTİR",
            primaryColor: CustomColors.primaryColorM,
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }

  Padding bodyFlow() {
    return Padding(
      padding: seperatePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text("Barkod Numarası", style: ThemeValueExtension.headline6),
          SizedBox(
            height: 2.h,
          ),
          Text(ref.watch(currentBarcodeInfoProvider).barcodeInfo ?? "-",
              style: ThemeValueExtension.subtitle),
          const Divider(),
          Text("EPC", style: ThemeValueExtension.headline6),
          SizedBox(
            height: 2.h,
          ),
          Text(ref.watch(currentBarcodeInfoProvider).epc ?? "-",
              style: ThemeValueExtension.subtitle),
          const Divider(),
          SizedBox(
            height: 4.h,
          ),
        ],
      ),
    );
  }
}
