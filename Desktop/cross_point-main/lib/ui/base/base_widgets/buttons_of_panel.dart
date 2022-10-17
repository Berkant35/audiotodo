import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/extensions/iconSizeExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layers/view_models/global_providers.dart';
import '../../../layers/view_models/scan_stop_manager.dart';
import '../../../utilities/common_widgets/custom_button.dart';
import '../../../utilities/constants/custom_colors.dart';
import '../../../utilities/extensions/font_theme.dart';

class ButtonsOfPanel extends ConsumerWidget {
  const ButtonsOfPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: context.lowValue * 0.265,
        ),
        ref.watch(scanStopStateProvider) == ScanModes.scan
            ? CustomElevatedButton(
                onPressed: () {
                  ref
                      .read(scanStopStateProvider.notifier)
                      .changeState(ScanModes.stop);
                  ref.read(inventoryTagsProvider.notifier).stopScan();
                },
                inButtonWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: IconSizeExtension.MEDIUMTOHIGH.sizeValue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Stop",
                      style: ThemeValueExtension.subtitle,
                    ),
                  ],
                ),
                height: buildHeight(context),
                width: buttonWidth(context),
                primaryColor: ref.watch(scanStopStateProvider) == ScanModes.stop
                    ? CustomColors.acikGri.withOpacity(0.25)
                    : CustomColors.crossPointDark,
              )
            : CustomElevatedButton(
                onPressed: () {
                  ref
                      .read(scanStopStateProvider.notifier)
                      .changeState(ScanModes.scan);
                  ref.read(inventoryTagsProvider.notifier).startScan(ref);
                },
                inButtonWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: IconSizeExtension.MEDIUMTOHIGH.sizeValue,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Scan",
                      style: ThemeValueExtension.subtitle,
                    ),
                  ],
                ),
                width: buttonWidth(context),
                height: buildHeight(context),
                primaryColor: ref.watch(scanStopStateProvider) == ScanModes.scan
                    ? CustomColors.acikGri.withOpacity(0.25)
                    : CustomColors.crossPointDark,
              ),
      ],
    );
  }

  double buildHeight(BuildContext context) => context.height * 0.045;

  double buttonWidth(BuildContext context) => context.width * 0.45;
}
