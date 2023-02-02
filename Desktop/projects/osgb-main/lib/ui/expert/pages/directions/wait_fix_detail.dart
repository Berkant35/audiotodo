import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/ui/expert/pages/directions/show_photo.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dots_indicator/dots_indicator.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class WaitFixDetail extends ConsumerStatefulWidget {
  final WaitFix waitFix;
  final Inspection inspection;
  final bool showDeleteButton;

  const WaitFixDetail(
      {Key? key,
      required this.waitFix,
      required this.inspection,
      required this.showDeleteButton})
      : super(key: key);

  @override
  ConsumerState createState() => _WaitFixDetailState();
}

class _WaitFixDetailState extends ConsumerState<WaitFixDetail> {
  late PageController _pageController;
  var currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 5.w,
        title: Text(
          "Düzeltilmesi Gereken Bir Durum",
          style: ThemeValueExtension.subtitle,
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => NavigationService.instance.navigatePopUp(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: seperatePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn("Tehlike Derecesi", widget.waitFix.waitFixDegree!),
              buildColumn("Durum Başlık", widget.waitFix.waitFixTitle!),
              buildColumn("Durum Açıklama", widget.waitFix.waitFixContent!),
              buildColumn("Öneri", widget.waitFix.adviceExplain ?? "-"),
              buildColumn("Termin Tarihi", widget.waitFix.deadlineDate ?? "-"),
              buildPhotos("Fotoğraflar"),
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn(String header, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        Text(header,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.bold)),
        Text(content,
            style: ThemeValueExtension.subtitle2
                .copyWith(fontWeight: FontWeight.w500)),
      ],
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
          child: ref.watch(currentInspectionState)!.waitFixList != null &&
                  widget.waitFix.waitFixPhotos!.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: widget.waitFix.waitFixPhotos!.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value.toDouble();
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowPhoto(
                                photoURL: widget.waitFix.waitFixPhotos![index],
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
                              imageUrl: widget.waitFix.waitFixPhotos![index],
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
          child: widget.waitFix.waitFixPhotos != null &&
                  widget.waitFix.waitFixPhotos!.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DotsIndicator(
                    dotsCount: widget.waitFix.waitFixPhotos!.length,
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
        widget.showDeleteButton ? Center(
          child: ref.watch(currentButtonLoadingState) != LoadingStates.loading
              ? CustomElevatedButton(
                  onPressed: () {
                    ref
                        .read(currentExpertWorksState.notifier)
                        .deleteWaitFix(widget.waitFix, ref);
                  },
                  inButtonText: "Durumu Sil",
                  primaryColor: CustomColors.orangeColorM,
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ) : const SizedBox()
      ],
    );
  }
}
