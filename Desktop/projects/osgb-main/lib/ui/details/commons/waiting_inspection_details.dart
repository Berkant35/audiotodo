import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../line/viewmodel/global_providers.dart';
import '../../../models/wait_fix.dart';
import '../../../utilities/components/custom_flexible_bar.dart';
import '../../../utilities/components/seperate_padding.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/constants/extension/edge_extension.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class WaitingInspectionDetails extends ConsumerStatefulWidget {
  final bool? showDeleteButton;

  const WaitingInspectionDetails({
    Key? key,
    required this.showDeleteButton
  }) : super(key: key);

  @override
  ConsumerState createState() => _WaitingInspectionDetailsState();
}

class _WaitingInspectionDetailsState extends ConsumerState<WaitingInspectionDetails> {
  @override
  Widget build(BuildContext context) {
    var currentAppBar = ref.watch(currentCustomFlexibleAppBarState);
    var currentInspection = ref.watch(currentInspectionState);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 25.h,
        flexibleSpace: CustomFlexibleBar(
          appBarTitle: currentAppBar.backAppBarTitle!,
          headerPhoto: currentAppBar.photoUrl,
          firstHeader: currentAppBar.header1,
          firstInfo: currentAppBar.content1,
          secondHeader: currentAppBar.header2,
          secondInfo: currentAppBar.content2,
          thirdHeader: currentAppBar.header3,
          thirdInfo: currentAppBar.content3,
          role: Roles.customer,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: seperatePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text("Denetim Bilgileri",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),
              rowInfo("Denetim Tarihi",
                  currentInspection!.inspectionDate!.substring(0, 16)),
              SizedBox(height: 2.h),
              rowInfo(
                  "Denetimi Gerçekleştiren",
                  currentInspection.expertName ??
                      currentInspection.doctorName!),
              rowInfo("Toplam Düzeltilmesi Gereken Sayı",
                  currentInspection.waitFixList!.length.toString()),
              rowInfo("Düzeltilmesi Gereken 'Çok Önemli' Durum Sayısı",
                  currentInspection.highDanger.toString()),
              rowInfo("Düzeltilmesi Gereken 'Önemli' Durum Sayısı",
                  currentInspection.normalDanger!.toString()),
              rowInfo("Düzeltilmesi Gereken 'Yapılsa İyi Olur' Durum Sayısı",
                  currentInspection.lowDanger!.toString()),
              Text("Açıklama",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),
              Text(
                  currentInspection.inspectionExplain ??
                      "Açıklama bulunmamıştır",
                  style: ThemeValueExtension.subtitle
                      .copyWith(fontWeight: FontWeight.w500)),
              waitFixList(),
              SizedBox(height: 40.h),

            ],
          ),
        ),
      ),
     );
  }
  Padding rowInfo(String header, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(header,
                style: ThemeValueExtension.subtitle
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              content,
              style: ThemeValueExtension.subtitle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: CustomColors.secondaryColor),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget waitFixList() {
    return ref.read(currentInspectionState)!.waitFixList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Text(
          "Düzeltilmesi gereken güncel durumlar",
          style: ThemeValueExtension.subtitle
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 100.w,
          height: 40.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
              ref.watch(currentInspectionState)!.waitFixList?.length,
              itemBuilder: (context, index) {
                var perWaitFix = WaitFix.fromJson(ref
                    .watch(currentInspectionState)!
                    .waitFixList![index] is WaitFix
                    ? (ref
                    .read(currentInspectionState)!
                    .waitFixList![index] as WaitFix)
                    .toJson()
                    : ref
                    .read(currentInspectionState)!
                    .waitFixList![index]);
                return GestureDetector(
                  onTap: () => goToDetailOfWaitFix(perWaitFix),
                  child: Padding(
                    padding: EdgeInsets.all(1.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(
                              EdgeExtension.lowEdge.edgeValue)),
                          boxShadow: const [
                            BoxShadow(
                                blurStyle: BlurStyle.outer,
                                offset: Offset(0, 0),
                                spreadRadius: 1,
                                color: CustomColors.customGreyColor)
                          ]),
                      width: 70.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: photoArea(perWaitFix)),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: Text(
                                  perWaitFix.waitFixTitle!,
                                  style: ThemeValueExtension.subtitle
                                      .copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: Text(
                                  perWaitFix.waitFixContent!,
                                  style: ThemeValueExtension.subtitle2
                                      .copyWith(
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () =>
                                    goToDetailOfWaitFix(perWaitFix),
                                child: SizedBox(
                                  width: 100.w,
                                  child: Padding(
                                    padding: EdgeInsets.all(1.h),
                                    child: Text(
                                      "İncele",
                                      style: ThemeValueExtension.subtitle3
                                          .copyWith(
                                          color: CustomColors
                                              .secondaryColor),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    )
        : const SizedBox();
  }

  void goToDetailOfWaitFix(WaitFix waitFix) {
    NavigationService.instance
        .navigateToPage(path: NavigationConstants.waitFixDetailPage, data: {
      "waitFix": waitFix.toJson(),
      "inspection": ref.watch(currentInspectionState)!.toJson(),
      "showDeleteButton" : widget.showDeleteButton
    });
  }

  Widget photoArea(WaitFix perWaitFix) {
    return perWaitFix.waitFixPhotos != null &&
        perWaitFix.waitFixPhotos!.isNotEmpty
        ? ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(EdgeExtension.lowEdge.edgeValue),
          topRight: Radius.circular(EdgeExtension.lowEdge.edgeValue)),
      child: Image.network(
        perWaitFix.waitFixPhotos!.first,
        fit: BoxFit.fill,
        width: 100.w,
        height: 100.h,
      ),
    )
        : const Center(
      child: Icon(
        Icons.photo,
        size: 45,
      ),
    );
  }


  Column columnInfo(String header, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.bold)),
        Text(content,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
