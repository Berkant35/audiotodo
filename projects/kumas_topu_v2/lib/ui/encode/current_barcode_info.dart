import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/dialogs.dart';
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
  final barcodeFormState = GlobalKey<FormState>();

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

    return Form(
      key: barcodeFormState,
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
                        icon: Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: Icon(
                            Icons.add_box,
                            size: 4.h,
                          ),
                        ))
                    : const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
              ],
            ),
            RowFormField(
              headerName: "",
              verticalContentPadding: 0.h,
              prefixIcon: Icons.qr_code_scanner_rounded,
              hintText: "Barcode Numarası",
              editingController: barcodeEditingController,
              custValidateFunction: (value) {
                (ref.read(currentBarcodeInfoProvider).barcodeInfo != "" &&
                        ref.read(currentBarcodeInfoProvider).barcodeInfo !=
                            null &&
                        ref.read(currentBarcodeInfoProvider).barcodeInfo != "-")
                    ? null
                    : "Boş Bırakılamaz";
                return null;
              },
              onChanged: (value) {
                debugPrint("Triggered!: $value");
                var barcodeProvider = ref.read(currentBarcodeInfoProvider);
                barcodeProvider.barcodeInfo = value;
                ref
                    .read(currentBarcodeInfoProvider.notifier)
                    .changeState(barcodeProvider);

                if (value == "") {
                  setState(() {});
                }

                return barcodeProvider.barcodeInfo;
              },
            ),
            const Divider(),
            SizedBox(
              height: 4.h,
            ),
            buttons(),
            SizedBox(
              height: 10.h,
            )
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
                      ref.watch(currentBarcodeInfoProvider).barcodeInfo !=
                          null &&
                      ref
                              .watch(currentBarcodeInfoProvider)
                              .barcodeInfo!
                              .length >
                          1)
                  ? Center(
                      child: CustomElevatedButton(
                        onPressed: ref.watch(currentTriggerModeProvider) ==
                                TriggerModeStatus.BARCODE
                            ? () {
                                barcodeFormState.currentState!.save();
                                if (barcodeFormState.currentState!.validate()) {
                                  ref
                                      .read(viewModelStateProvider.notifier)
                                      .createEPCForMatch(ref)
                                      .then((value) {
                                    if (ref
                                                .read(
                                                    currentBarcodeInfoProvider)
                                                .epc !=
                                            null &&
                                        value != null) {
                                      var barcodeInfo =
                                          ref.read(currentBarcodeInfoProvider);
                                      barcodeInfo.barcodeInfo = "";
                                      ref
                                          .read(currentBarcodeInfoProvider
                                              .notifier)
                                          .changeState(barcodeInfo);

                                      NavigationService.instance.navigateToPage(
                                          path: NavigationConstants
                                              .matchWithRFIDPage,
                                          data: {
                                            "controller":
                                                barcodeEditingController
                                          });
                                    }
                                  });
                                } else {
                                  Dialogs.showFailed(
                                      "Lütfen standart seçimini gerçekleştirin");
                                }
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
