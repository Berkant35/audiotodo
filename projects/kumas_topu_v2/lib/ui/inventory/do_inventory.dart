import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/line/viewmodel/scan_stop_manager.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/inventory_save_alert_dialog.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/constants/extension/edge_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:segment_display/segment_display.dart';

import '../../utilities/constants/extension/image_path.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../../utilities/init/theme/custom_colors.dart';

class DoInventory extends ConsumerStatefulWidget {
  const DoInventory({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DoInventoryState();
}

class _DoInventoryState extends ConsumerState<DoInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(currentInventoryProvider)!.inventory?.inventoryName ?? "-",
          style: ThemeValueExtension.headline6
              .copyWith(overflow: TextOverflow.ellipsis),
        ),
        leadingWidth: 8.w,
        leading: IconButton(
          onPressed: () {
            ref.read(currentInventoryProvider.notifier).clearInventory();
            NavigationService.instance.navigatePopUp().then((value) {
              if (ref.watch(scanStopStateProvider) != ScanModes.scan) {
                ref
                    .read(currentTriggerModeProvider.notifier)
                    .nativeManager
                    .stopScan()
                    .then((value) {
                  ref
                      .read(currentTriggerModeProvider.notifier)
                      .nativeManager
                      .clear()
                      .then((value) {
                    ref
                        .read(scanStopStateProvider.notifier)
                        .changeState(ScanModes.idle);
                  });
                });
              }
            });
          },
          icon: Icon(
            Icons.arrow_back,
            size: 4.h,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return const InventorySaveAlertDialog();
                      }).then((value) {
                    setState(() {});
                  }),
              icon: Icon(
                Icons.save,
                size: 4.h,
              ))
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ref.watch(currentInventoryProvider)!.readEpcList!.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: ListView.builder(
                        itemCount: ref
                            .watch(currentInventoryProvider)!
                            .readEpcList!
                            .length,
                        itemBuilder: (context, index) {
                          var hashMap = ref
                              .watch(currentInventoryProvider)!
                              .readEpcList![index];
                          return SizedBox(
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  hashMap.epc!,
                                  style: ThemeValueExtension.subtitle2,
                                ),
                                subtitle: Text(
                                  hashMap.readDate!.toString().substring(0, 22),
                                  style: ThemeValueExtension.subtitle2,
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sayımı yapmak için lütfen tetiği kulanın!",
                          style: ThemeValueExtension.subtitle2
                              .copyWith(color: CustomColors.appBarColor),
                        ),
                        Lottie.asset(ImagePath.scanLottieAnimation,
                            repeat: true, width: 50.w, height: 50.w)
                      ],
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 100.w,
              height: 15.h,
              decoration: const BoxDecoration(color: CustomColors.appBarColor),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        if (ref.watch(scanStopStateProvider) !=
                            ScanModes.scan) {
                          ref
                              .read(currentTriggerModeProvider.notifier)
                              .nativeManager
                              .startScan();
                        } else {
                          ref
                              .read(currentTriggerModeProvider.notifier)
                              .nativeManager
                              .stopScan();
                        }
                      },
                      inButtonText: null,
                      inButtonWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                ref.watch(scanStopStateProvider) !=
                                        ScanModes.scan
                                    ? Icons.play_circle
                                    : Icons.stop_circle,
                                size: 4.25.h,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  ref.watch(scanStopStateProvider) !=
                                          ScanModes.scan
                                      ? "Başla"
                                      : "Durdur",
                                  style: ThemeValueExtension.subtitle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SevenSegmentDisplay(
                          value: ref
                              .watch(currentInventoryProvider)!
                              .readEpcList!
                              .length
                              .toString(),
                          size: 4.0,
                          characterSpacing: 10.0,
                          backgroundColor: Colors.transparent,
                          segmentStyle: HexSegmentStyle(
                            enabledColor: Colors.green,
                            disabledColor: Colors.greenAccent.withOpacity(0.15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Radius buildRadius() => Radius.circular(12.w);
}
