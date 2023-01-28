import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/components/row_form_field.dart';
import '../../utilities/constants/app/enums.dart';
import '../../utilities/init/theme/custom_colors.dart';

class CurrentBarcodeInfo extends ConsumerStatefulWidget {
  const CurrentBarcodeInfo({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CurrentBarcodeInfoState();
}

class _CurrentBarcodeInfoState extends ConsumerState<CurrentBarcodeInfo> {
  late TextEditingController barcodeEditingController;

  @override
  void initState() {
    super.initState();
    barcodeEditingController = TextEditingController(
        text: ref.read(currentBarcodeInfoProvider).barcodeInfo ?? "-");
  }

  @override
  Widget build(BuildContext context) {
    barcodeEditingController.text =
        ref.watch(currentBarcodeInfoProvider).barcodeInfo ?? "-";

    return SizedBox(
      width: 96.w,
      child: Padding(
        padding: seperatePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Barkod Numarası", style: ThemeValueExtension.headline6),
                ref.read(loginButtonStateProvider) != LoadingStates.loading
                    ? IconButton(
                        onPressed: () {
                          ref
                              .read(viewModelStateProvider.notifier)
                              .getSerialNumber(ref)
                              .then((value) {
                            if (value != null) {
                              var barcodeProvider =
                                  ref.read(currentBarcodeInfoProvider);
                              barcodeProvider.barcodeInfo =
                                  value.data!.serialNumber.toString();
                              ref
                                  .watch(currentBarcodeInfoProvider.notifier)
                                  .changeState(barcodeProvider);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add_box,
                          size: 4.h,
                        ))
                    : const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
              ],
            ),
            RowFormField(
              padding: const EdgeInsets.all(0),
              headerName: "",
              prefixIcon: Icons.qr_code_scanner_rounded,
              hintText: "Barcode Number",
              editingController: barcodeEditingController,
              custValidateFunction: (value) {
                (value != "") ? "Boş Bırakılamaz" : null;
                return null;
              },
              onChanged: (value) {
                debugPrint("Triggered!");
                var barcodeProvider = ref.read(currentBarcodeInfoProvider);
                barcodeProvider.barcodeInfo = value;
                ref
                    .watch(currentBarcodeInfoProvider.notifier)
                    .changeState(barcodeProvider);
                return null;
              },
            ),
            const Divider(),
            SizedBox(
              height: 4.h,
            ),
            buttons(),
            SizedBox(height: 10.h,)
          ],
        ),
      ),
    );
  }

  Widget buttons() {
    return ref.watch(loginButtonStateProvider) != LoadingStates.loading
        ? Column(
            children: [
              Center(
                child: CustomElevatedButton(
                  onPressed: ref.watch(currentTriggerModeProvider) ==
                          TriggerModeStatus.BARCODE
                      ? () {
                          ref
                              .read(currentTriggerModeProvider.notifier)
                              .nativeManager
                              .scanBarcodeButton(ref);
                        }
                      : null,
                  inButtonText: "TARA",
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              (ref.watch(currentBarcodeInfoProvider).barcodeInfo != "-" &&
                      ref.watch(currentBarcodeInfoProvider).barcodeInfo != null)
                  ? Center(
                      child: CustomElevatedButton(
                        onPressed: ref.watch(currentTriggerModeProvider) ==
                                TriggerModeStatus.BARCODE
                            ? () {
                                ref
                                    .read(viewModelStateProvider.notifier)
                                    .createEPCForMatch(ref)
                                    .then((value) {
                                  if (ref
                                              .read(currentBarcodeInfoProvider)
                                              .epc !=
                                          null &&
                                      value != null) {
                                    NavigationService.instance.navigateToPage(
                                        path: NavigationConstants
                                            .matchWithRFIDPage);
                                  }
                                });
                              }
                            : null,
                        inButtonText: "RFID Eşleştirme",
                        primaryColor: CustomColors.darkPurpleColorM,
                      ),
                    )
                  : const Center(
                      child: SizedBox(),
                    ),
            ],
          )
        : Center(
            child: Text(
              "Epc oluşturuluyor...",
              style: ThemeValueExtension.subtitle,
            ),
          );
  }
}
