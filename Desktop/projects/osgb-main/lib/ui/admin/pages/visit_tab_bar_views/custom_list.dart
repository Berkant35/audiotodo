
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/init/navigation/navigation_constants.dart';
import '../../../../utilities/init/navigation/navigation_service.dart';

class CustomList extends ConsumerStatefulWidget {
  final List<Inspection> list;

  const CustomList({Key? key, required this.list}) : super(key: key);

  @override
  ConsumerState createState() => _CustomListState();
}

class _CustomListState extends ConsumerState<CustomList> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(currentSearchText.notifier).setScrollController(scrollController);
    if (ref.watch(currentSearchText.notifier).requiredRefreshList) {
      setState(() {});
      ref.read(currentSearchText.notifier).updateRequireStateToFalse();
    }
    var list = widget.list;
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.list.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var perInspection = list[index];
            return ref.watch(currentSearchText)!.isEmpty ||
                perInspection.customerName!.toLowerCase().contains(
                    ref.watch(currentSearchText).toString().toLowerCase())
                ? Padding(
                padding: EdgeInsets.all(1.h),
                child: CustomCard(
                    networkImage: perInspection.customerPhotoURL,
                    header1: "Şirket Adı",
                    content1: perInspection.customerName!,
                    header2:
                    "Uzman${perInspection.doctorName != null ? "/Hekim" : ""}",
                    content2:
                    "${perInspection.expertName!}${perInspection.doctorName != null ? "/${perInspection.doctorName}" : ""}",
                    header3: "Tarih",
                    content3: perInspection.inspectionDate!.substring(0, 16),
                    navigationContentText: "Detaylar",
                    onClick: () {
                      ref
                          .read(currentCustomFlexibleAppBarState.notifier)
                          .changeContentFlexibleManager(CustomFlexibleModel(
                          header1: "Şirket Adı",
                          header2: "Uzman",
                          header3: "Tarih",
                          content1: perInspection.customerName,
                          content2: perInspection.expertName ??
                              perInspection.doctorName,
                          content3: perInspection.inspectionDate
                              .toString()
                              .substring(0, 16),
                          backAppBarTitle: "Denetim Detay",
                          photoUrl: perInspection.customerPhotoURL));
                      ref
                          .read(currentInspectionState.notifier)
                          .changeCurrentInspection(perInspection);
                      NavigationService.instance.navigateToPage(
                          path: NavigationConstants.waitingInspectionDetails,
                          data: {
                            "showDeleteButton": true,
                          });
                    }))
                : const SizedBox();
          }),
    );
  }
}