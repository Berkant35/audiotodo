import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/accident_case.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../line/viewmodel/global_providers.dart';
import '../../../models/customer.dart';
import '../../../models/worker.dart';
import '../../../utilities/components/custom_elevated_button.dart';
import '../../../utilities/components/custom_flexible_bar.dart';
import '../../../utilities/components/seperate_padding.dart';
import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/constants/extension/edge_extension.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import '../../expert/pages/directions/show_photo.dart';

class CrisisDetail extends ConsumerStatefulWidget {
  const CrisisDetail({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CrisisDetailState();
}

class _CrisisDetailState extends ConsumerState<CrisisDetail> {
  late StringBuffer listOfWorker;

  late PageController _pageController;
  var currentPage = 0.0;
  AccidentCase? currentCrisis;

  @override
  void initState() {
    super.initState();
    listOfWorker = StringBuffer();
    _pageController = PageController();
    currentCrisis = ref.read(currentCrisisState);
    for (var worker
        in (currentCrisis?.caseAffectedWorkerList as List<dynamic>)) {
      var curWorker = Worker.fromJson(worker);
      listOfWorker.write(curWorker.workerName);
      listOfWorker.write(", ");
    }

  }

  @override
  Widget build(BuildContext context) {
    var currentAppBar = ref.watch(currentCustomFlexibleAppBarState);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
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
              Text("Olay Bilgileri",
                  style: ThemeValueExtension.headline6
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 2.h,
              ),

              columnInfo("Olay Başlık", currentCrisis!.caseName ?? "-"),
              columnInfo("İş Yeri", currentCrisis!.caseCompanyName ?? "-"),
              columnInfo("İş Yeri Telefon", currentCrisis!.caseCompanyPhone ?? "-"),
              columnInfo("İş Yeri E-Mail", currentCrisis!.caseCompanyEmail ?? "-"),
              columnInfo("İş Yeri Yetkilisi Telefon Numarası", currentCrisis!.caseCompanyPresentationPersonPhoneNumber ?? "-"),
              columnInfo(
                  "Olay Tarihi", currentCrisis!.caseDate!.substring(0, 16)),
              columnInfo("Olay Açıklama", currentCrisis!.caseContent ?? "-"),

              columnInfo(
                  "Kazazade İşçi İsimleri",
                  listOfWorker
                      .toString()
                      .substring(0, listOfWorker.length - 2)),
              buildPhotos("Eklenen Fotoğraflar"),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Column buildPhotos(String header) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        Text(header,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          width: 100.w,
          height: 30.h,
          child: ref.read(currentCrisisState)!.casePhotos != null &&
                  ref.read(currentCrisisState)!.casePhotos!.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: ref.read(currentCrisisState)!.casePhotos!.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value.toDouble();
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowPhoto(
                                photoURL: ref
                                    .read(currentCrisisState)!
                                    .casePhotos![index],
                              ))),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        height: 25.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(EdgeExtension.lowEdge.edgeValue)),
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  EdgeExtension.lowEdge.edgeValue))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(
                                EdgeExtension.lowEdge.edgeValue)),
                            child: CachedNetworkImage(
                              imageUrl: ref
                                  .read(currentCrisisState)!
                                  .casePhotos![index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  "Fotoğraf yok",
                  style: ThemeValueExtension.subtitle,
                  textAlign: TextAlign.center,
                )),
        ),
        Center(
          child: ref.read(currentCrisisState)!.casePhotos != null &&
                  ref.read(currentCrisisState)!.casePhotos!.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DotsIndicator(
                    dotsCount: ref.read(currentCrisisState)!.casePhotos!.length,
                    position: currentPage,
                    decorator: DotsDecorator(
                      color: CustomColors.secondaryColor,
                      activeColor: CustomColors.primaryColor,
                      size: Size(MediaQueryExtension(context).lowValue,
                          MediaQueryExtension(context).lowValue),
                      spacing: EdgeInsets.all(
                          MediaQueryExtension(context).lowValue - 4),
                    ),
                  ))
              : const SizedBox(),
        ),
        SizedBox(
          height: 2.h,
        ),
        Center(
          child: ref.watch(currentButtonLoadingState) != LoadingStates.loading
              ? CustomElevatedButton(
                  onPressed: () {
                    ref
                        .read(currentCustomerWorksState.notifier)
                        .deleteCrises(
                            ref.read(currentCrisisState)!.caseID!, ref)
                        .then((value) {
                      if (ref.read(currentRole) == Roles.customer) {
                        NavigationService.instance.navigateToPageClear(
                            path: NavigationConstants.customerBasePage);
                      }else{
                        NavigationService.instance.navigateToPageClear(
                            path: NavigationConstants.adminBasePage);
                      }
                    });
                  },
                  inButtonText: "Durumu Sil",
                  primaryColor: CustomColors.orangeColorM,
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        )
      ],
    );
  }

  Padding columnInfo(String header, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style: ThemeValueExtension.subtitle
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(content,
              style: ThemeValueExtension.subtitle
                  .copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
