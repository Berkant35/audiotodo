import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/wait_fix.dart';
import '../../../utilities/components/custom_flexible_bar.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/constants/extension/edge_extension.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class DoneInspectionDetails extends ConsumerStatefulWidget {
  const DoneInspectionDetails({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DoneInspectionDetailsState();
}

class _DoneInspectionDetailsState extends ConsumerState<DoneInspectionDetails> {
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
            fourInfo: currentAppBar.content5,
            fiveInfo: currentAppBar.content4,
            fourHeader: currentAppBar.header5,
            fiveHeader: currentAppBar.header4,
            role: Roles.customer),
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
              rowInfo(
                  "Denetimi Gerçekleştiren",
                  currentInspection.expertName ??
                      currentInspection.doctorName!),
              rowInfo("Toplam Düzeltilmesi Gereken Sayı",
                  currentInspection.waitFixList!.length.toString()),
              rowInfo("Düzeltilmesi Gereken 'Çok Önemli' Durum Sayısı",
                  currentInspection.highDanger!.toString()),
              rowInfo("Düzeltilmesi Gereken 'Önemli' Durum Sayısı",
                  currentInspection.normalDanger!.toString()),
              rowInfo("Düzeltilmesi Gereken 'Yapılsa İyi Olur' Durum Sayısı",
                  currentInspection.lowDanger!.toString()),
              SizedBox(height: 2.h),
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
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: ref.watch(currentButtonLoadingState) !=
                        LoadingStates.loading
                    ? CustomElevatedButton(
                        onPressed: () async {
                          try {
                            try {
                              ref
                                  .read(currentButtonLoadingState.notifier)
                                  .changeState(LoadingStates.loading);
                              var stringBuffer = StringBuffer();

                              for (int i = 0;
                                  i < currentInspection.waitFixList!.length;
                                  i++) {
                                var waitFix = WaitFix.fromJson(
                                    currentInspection.waitFixList![i]);
                                debugPrint(waitFix.waitFixPhotos!.first);
                                String link = waitFix.waitFixPhotos!.first;

                                stringBuffer
                                    .write('{"waitFixPhotos":["$link"],');
                                stringBuffer.write(
                                    '"waitFixInspectionID":"${waitFix.waitFixInspectionID}","waitFixID":"${waitFix.waitFixID}","waitFixDegree":"${waitFix.waitFixDegree}","waitFixContent":"${waitFix.waitFixContent}","waitFixTitle":"${waitFix.waitFixTitle}","waitFixExpertID":"${waitFix.waitFixExpertID}","deadlineDate":"${waitFix.deadlineDate}","adviceExplain":"${waitFix.adviceExplain}"}');
                                if (i <=
                                    currentInspection.waitFixList!.length - 2) {
                                  stringBuffer.write(",");
                                }
                              }

                              debugPrint(
                                  '{"inspectionID":"${currentInspection.inspectionID}","customerID":"${currentInspection.customerID}","customerName":"${currentInspection.customerName}","customerPhotoURL":"${currentInspection.customerPhotoURL}","expertID":"${currentInspection.expertID}","expertName":"${currentInspection.expertName}","doctorID":"${currentInspection.doctorID}","customerPushToken":"${currentInspection.customerPushToken}","doctorName":"${currentInspection.doctorName}","inspectionExplain":"${currentInspection.inspectionExplain}","inspectionTitle":"","inspectionDate":"${currentInspection.inspectionDate}","inspectionIsStarted":${currentInspection.inspectionIsStarted},"currentHasMustFixCount":${currentInspection.currentHasMustFixCount},"highDanger":${currentInspection.highDanger},"customerSector":"${currentInspection.customerSector}","customerAddress":"${currentInspection.customerAddress}","dangerLevelOfCustomer":"${currentInspection.dangerLevelOfCustomer}","customerPresentationName":"${currentInspection.customerPresentationName}","normalDanger":${currentInspection.normalDanger},"lowDanger":${currentInspection.lowDanger},"workerCount":${currentInspection.workerCount},"waitFixList":[${stringBuffer.toString()}],"inspectionIsDone":true}');

                              var response = await http.post(
                                Uri.parse(
                                    "https://osgb.linksible.com/api/pdf/generate"),
                                body: {
                                  "pdf_json":
                                      '{"inspectionID":"${currentInspection.inspectionID}","customerID":"${currentInspection.customerID}","customerName":"${currentInspection.customerName}","customerPhotoURL":"${currentInspection.customerPhotoURL}","expertID":"${currentInspection.expertID}","expertName":"${currentInspection.expertName}","doctorID":"${currentInspection.doctorID}","customerPushToken":"${currentInspection.customerPushToken}","doctorName":"${currentInspection.doctorName}","inspectionExplain":"${currentInspection.inspectionExplain}","inspectionTitle":"","inspectionDate":"${currentInspection.inspectionDate}","inspectionIsStarted":${currentInspection.inspectionIsStarted},"currentHasMustFixCount":${currentInspection.currentHasMustFixCount},"highDanger":${currentInspection.highDanger},"customerSector":"${currentInspection.customerSector}","customerAddress":"${currentInspection.customerAddress}","dangerLevelOfCustomer":"${currentInspection.dangerLevelOfCustomer}","customerPresentationName":"${currentInspection.customerPresentationName}","normalDanger":${currentInspection.normalDanger},"lowDanger":${currentInspection.lowDanger},"workerCount":${currentInspection.workerCount},"waitFixList":[${stringBuffer.toString()}],"inspectionIsDone":true}' //
                                },
                              );

                              launch(
                                  "https://osgb.linksible.com/pdfler/${response.body.toString()}");
                            } catch (e) {
                              debugPrint(e.toString());
                            } finally {
                              ref
                                  .read(currentButtonLoadingState.notifier)
                                  .changeState(LoadingStates.loaded);
                            }

                            /* var result = await _dio.post(
                          "https://osgb.linksible.com/api/pdf/generate",
                          data: {"pdf_json": currentInspection.toJson()},
                          options: Options(headers: {}));*/

                          } catch (e) {
                            if (e is DioError) {
                              debugPrint("$e<-Err");
                            }
                          }
                        },
                        inButtonText: null,
                        primaryColor: CustomColors.orangeColorM,
                        inButtonWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PDF İndir",
                              style: ThemeValueExtension.subtitle,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Icon(
                              Icons.picture_as_pdf,
                              size: 4.h,
                            )
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
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
        : SizedBox();
  }

  void goToDetailOfWaitFix(WaitFix waitFix) {
    NavigationService.instance
        .navigateToPage(path: NavigationConstants.waitFixDetailPage, data: {
      "waitFix": waitFix.toJson(),
      "inspection": ref.watch(currentInspectionState)!.toJson(),
      "showDeleteButton": false
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
