import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/custom_flexible_bar.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/customer.dart';
import '../../../../models/notification_model.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class DoAudit extends ConsumerStatefulWidget {
  const DoAudit({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _DoAuditState();
}

class _DoAuditState extends ConsumerState<DoAudit> {
  Customer? customer;

  @override
  void initState() {
    super.initState();
    ref
        .read(currentCustomerWorksState.notifier)
        .auth
        .getUser(ref.read(currentInspectionState)!.customerID!)
        .then((value) {
      customer = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: seperatePadding(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Açıklama",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),
              Text(ref.watch(currentInspectionState)!.inspectionExplain ?? "-",
                  style: ThemeValueExtension.subtitle
                      .copyWith(fontWeight: FontWeight.w500)),
              const Divider(),
              SizedBox(
                height: 2.h,
              ),
              Text("Mevcut Durum",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),
              rowInfo(
                  "İşlemi yapan ${ref.read(currentRole) == Roles.doctor ? "hekim " : "uzman"}",
                  ref.read(currentRole) == Roles.doctor
                      ? "${ref.watch(currentInspectionState)!.doctorName} "
                      : "${ref.watch(currentInspectionState)!.expertName} "),
              rowInfo(
                  "Düzeltilmesi Gereken Durumlar",
                  ref
                      .watch(currentInspectionState)!
                      .waitFixList!
                      .length
                      .toString()),
              rowInfo("Düzeltilmesi Çok Önemli Durumlar",
                  ref.watch(currentInspectionState)!.highDanger.toString()),
              rowInfo("Düzeltilmesi Önemli Durumlar",
                  ref.watch(currentInspectionState)!.normalDanger.toString()),
              rowInfo("Düzeltilmesi Yapılsa İyi Olur Durumlar",
                  ref.watch(currentInspectionState)!.lowDanger.toString()),
              waitFixList(),
              buttons(),
              SizedBox(
                height: 35.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center buttons() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          CustomElevatedButton(
            onPressed: () => NavigationService.instance
                .navigateToPage(path: NavigationConstants.addWaitFix, data: {
              "inspectionID": ref.watch(currentInspectionState)!.inspectionID
            }),
            inButtonText: "Yeni Durum Ekle",
            primaryColor: CustomColors.secondaryColorM,
          ),
          SizedBox(
            height: 2.h,
          ),
          ref.watch(currentButtonLoadingState) != LoadingStates.loading
              ? CustomElevatedButton(
                  onPressed: () {
                    ref
                        .read(currentExpertWorksState.notifier)
                        .finishInspection(
                            ref.read(currentInspectionState)!.inspectionID!,
                            ref)
                        .then((value) {
                      ref
                          .read(currentBaseModelState.notifier)
                          .getAdmin()
                          .then((admin) async {
                         Future.wait([
                          ref
                              .read(currentPushNotificationState.notifier)
                              .sendPush(NotificationModel(
                                  to: ref
                                      .read(currentInspectionState)!
                                      .customerPushToken,
                                  priority: "high",
                                  notification: CustomNotification(
                                      title: "Denetim İşlemi Raporlandı",
                                      body:
                                          "${ref.read(currentInspectionState)!.inspectionDate} tarihli'li denetiminiz raporlandı.Ziyaretlerim bölümünden inceleyebilirsiniz"))),
                          ref
                              .read(currentPushNotificationState.notifier)
                              .sendPush(NotificationModel(
                                  to: admin!.pushToken,
                                  priority: "high",
                                  notification: CustomNotification(
                                      title:
                                          "${ref.read(currentInspectionState)!.customerName}'e yapılan denetim gerçekleştirildi",
                                      body:
                                          "Rapor'a ziyaretlerimden ulaşabilirsiniz")))
                        ]);
                      });
                      NavigationService.instance.navigateToPage(
                          path: NavigationConstants.expertBasePage);
                    });
                  },
                  inButtonText: "İşlemi Bitir",
                  primaryColor: CustomColors.orangeColorM,
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ],
      ),
    );
  }

  RenderObjectWidget waitFixList() {
    return ref.watch(currentInspectionState)!.waitFixList != null &&
            ref.watch(currentInspectionState)!.waitFixList!.isNotEmpty
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
                                        perWaitFix.waitFixTitle ?? "",
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
                                        perWaitFix.waitFixContent ?? "",
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
      "showDeleteButton": true
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

  Padding rowInfo(String header, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: ThemeValueExtension.subtitle,
          ),
          Text(
            content,
            style: ThemeValueExtension.subtitle
                .copyWith(color: CustomColors.secondaryColor),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const SizedBox(),
      toolbarHeight: 25.h,
      flexibleSpace: CustomFlexibleBar(
        appBarTitle:
            ref.watch(currentCustomFlexibleAppBarState).backAppBarTitle ??
                "Denetimi Gerçekleştir",
        headerPhoto: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
        firstHeader: ref.watch(currentCustomFlexibleAppBarState).header1,
        firstInfo: ref.watch(currentCustomFlexibleAppBarState).content1,
        secondHeader: ref.watch(currentCustomFlexibleAppBarState).header2,
        secondInfo: ref.watch(currentCustomFlexibleAppBarState).content2,
        thirdHeader: ref.watch(currentCustomFlexibleAppBarState).header3,
        thirdInfo: ref.watch(currentCustomFlexibleAppBarState).content3,
        fourInfo: ref.watch(currentCustomFlexibleAppBarState).content4,
        fiveInfo: ref.watch(currentCustomFlexibleAppBarState).content5,
        fiveHeader: ref.watch(currentCustomFlexibleAppBarState).header5,
        fourHeader: ref.watch(currentCustomFlexibleAppBarState).header4,
        role: Roles.customer,
        goBackFunction: () => NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.expertBasePage),
      ),
    );
  }
}
