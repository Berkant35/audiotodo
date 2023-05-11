import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/line/viewmodel/scan_stop_manager.dart';
import 'package:kumas_topu/utilities/components/appbars/title_app_bar.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/constants/extension/edge_extension.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/current_epc_detail.dart';
import '../../utilities/init/theme/custom_colors.dart';

class DetailOfProduct extends ConsumerWidget {
  const DetailOfProduct({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TitleAppBar(
        label: "İncele",
        onTap: () {
          ref
              .watch(currentEpcDetailInfoProvider.notifier)
              .changeState(CurrentEpcDetail(currentEpc: "", epcDetail: null));
          NavigationService.instance.navigatePopUp();
        },
      ),
      body: Padding(
        padding: seperatePadding(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text("Epc",
                  style: ThemeValueExtension.subtitle
                      .copyWith( fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 100.w,
                height: 8.h,
                decoration: BoxDecoration(
                    color: CustomColors.darkPurpleColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(EdgeExtension.lowEdge.edgeValue))),
                child: Center(
                  child: Text(
                      ref.watch(currentEpcDetailInfoProvider)?.currentEpc ?? "-",
                      style: ThemeValueExtension.subtitle2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              ref.watch(scanStopStateProvider) != ScanModes.scan
                  ? Center(
                      child: CustomElevatedButton(
                        onPressed: () => ref
                            .read(currentEpcDetailInfoProvider.notifier)
                            .getCurrentDetailThenSet(ref, false),
                        inButtonText: "Tara",
                        primaryColor: CustomColors.primaryColorM,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
              SizedBox(height: 2.h),
              Text("Epc Detay",
                  style: ThemeValueExtension.subtitle
                      .copyWith(
                          fontWeight: FontWeight.bold
                  )),
              SizedBox(height: 2.h),
              ref.watch(currentEpcDetailInfoProvider)?.epcDetail != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildRow(
                            "Barcode:",
                            ref
                                .watch(currentEpcDetailInfoProvider)
                                ?.epcDetail!
                                .data!
                                .barcode ??
                                "-"),
                        buildRow(
                            "Şirket Adı:",
                            ref
                                    .watch(currentEpcDetailInfoProvider)
                                    ?.epcDetail!
                                    .data!
                                    .companyName ??
                                "-"),
                        buildRow(
                            "Cihaz Adı:",
                            ref
                                    .watch(currentEpcDetailInfoProvider)
                                    ?.epcDetail!
                                    .data!
                                    .deviceName ??
                                "-"),
                        buildRow(
                            "Cihaz IP:",
                            ref
                                    .watch(currentEpcDetailInfoProvider)
                                    ?.epcDetail!
                                    .data!
                                    .deviceIp ??
                                "-"),
                        buildRow(
                            "Kayıt tarihi:",
                            ref
                                    .watch(currentEpcDetailInfoProvider)
                                    ?.epcDetail!
                                    .data!
                                    .recordDate ??
                                "-"),
                        buildRow(
                            "Kayıt eden kullanıcı:",
                            ref
                                    .watch(currentEpcDetailInfoProvider)
                                    ?.epcDetail!
                                    .data!
                                    .recordUser ??
                                "-"),
                        SizedBox(height: 10.h,)
                      ],
                    )
                  : Center(
                      child: Text(
                        "Bu epc ile ilgili tanımlanan bir bilgi bulunmamaktadır.",
                        style: ThemeValueExtension.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildRow(String header, String content) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                header,
                style: ThemeValueExtension.subtitle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                content,
                style: ThemeValueExtension.subtitle,
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
