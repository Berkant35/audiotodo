import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/components/custom_card.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../models/customer.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/init/navigation/navigation_constants.dart';

class DoneVisits extends ConsumerStatefulWidget {
  const DoneVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DoneVisitsState();
}

class _DoneVisitsState extends ConsumerState<DoneVisits> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inspection>?>(
        future:
            ref.read(currentAdminWorksState.notifier).getInspectionList(true),
        builder: (context, snapshot) {
          var list = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? list!.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              itemExtent: 15.h,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var perInspection = list[index];
                                return Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: CustomCard(
                                      networkImage:
                                          perInspection.customerPhotoURL,
                                      header1: "Şirket Adı",
                                      content1: perInspection.customerName!,
                                      header2:
                                          "Uzman${perInspection.doctorName != null ? "/Hekim" : ""}",
                                      content2:
                                          "${perInspection.expertName!}${perInspection.doctorName != null ? "/${perInspection.doctorName}" : ""}",
                                      header3: "Tarih",
                                      content3: perInspection.inspectionDate!
                                          .substring(0, 16),
                                      navigationContentText: "Detaylar",
                                      onClick: () async {
                                        Customer? customer = await ref
                                            .read(
                                                currentBaseModelState.notifier)
                                            .getCustomer(
                                                perInspection.customerID!);

                                        ref
                                            .read(
                                                currentCustomFlexibleAppBarState
                                                    .notifier)
                                            .changeContentFlexibleManager(
                                                CustomFlexibleModel(
                                                    header1: "Şirket Adı",
                                                    header2: "Uzman",
                                                    header3: "Tarih",
                                                    header4: "Sicil No",
                                                    header5: "Tehlike Durumu",
                                                    content1: perInspection
                                                        .customerName,
                                                    content2: perInspection
                                                            .expertName ??
                                                        perInspection
                                                            .doctorName,
                                                    content3: perInspection
                                                        .inspectionDate
                                                        .toString()
                                                        .substring(0, 16),
                                                    content4: customer!
                                                        .companyDetectNumber!,
                                                    content5: perInspection
                                                        .dangerLevelOfCustomer,
                                                    backAppBarTitle:
                                                        "Denetim Detay",
                                                    photoUrl: perInspection
                                                        .customerPhotoURL));
                                        ref
                                            .read(
                                                currentInspectionState.notifier)
                                            .changeCurrentInspection(
                                                perInspection);
                                        NavigationService.instance
                                            .navigateToPage(
                                                path: NavigationConstants
                                                    .doneInspectionDetails);
                                      }),
                                );
                              }),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Yapılan bir ziyaret bulunmamaktadır",
                        style: ThemeValueExtension.subtitle,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        });
  }
}
