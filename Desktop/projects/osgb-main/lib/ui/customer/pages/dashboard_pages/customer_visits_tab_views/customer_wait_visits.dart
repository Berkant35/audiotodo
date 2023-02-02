import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../../models/inspection.dart';
import '../../../../../utilities/components/custom_card.dart';
import '../../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../../utilities/init/navigation/navigation_constants.dart';
import '../../../../../utilities/init/navigation/navigation_service.dart';

class CustomerWaitVisits extends ConsumerStatefulWidget {
  const CustomerWaitVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerWaitVisitsState();
}

class _CustomerWaitVisitsState extends ConsumerState<CustomerWaitVisits> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inspection>?>(
        future:
        ref.read(currentCustomerWorksState.notifier).getInspectionList(false,ref),
        builder: (context, snapshot) {
          var list = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? list!.isNotEmpty
              ? ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemExtent: 15.h,
              itemBuilder: (context, index) {
                var perInspection = list[index];
                return Padding(
                  padding:  EdgeInsets.all(1.h),
                  child: CustomCard(
                      networkImage: perInspection.customerPhotoURL,
                      header1: "Şirket Adı",
                      content1: perInspection.customerName!,
                      header2: "Uzman${(perInspection.doctorName != null && perInspection.doctorName != "")  ?"/Hekim" : ""}",
                      content2:
                      "${perInspection.expertName!}${(perInspection.doctorName != null && perInspection.doctorName != "")  ?"/${perInspection.doctorName!}" : ""}",
                      header3: "Tarih",
                      content3: perInspection.inspectionDate!.substring(0,16),
                      navigationContentText: "Detaylar",
                      onClick: () {
                        ref
                            .read(currentCustomFlexibleAppBarState
                            .notifier)
                            .changeContentFlexibleManager(
                            CustomFlexibleModel(
                                header1: "Şirket Adı",
                                header2: "Uzman",
                                header3: "Tarih",
                                content1:
                                perInspection.customerName,
                                content2:
                                perInspection.expertName ??
                                    perInspection.doctorName,
                                content3: perInspection
                                    .inspectionDate
                                    .toString()
                                    .substring(0, 16),
                                backAppBarTitle: "Denetim Detay",
                                photoUrl: perInspection
                                    .customerPhotoURL));
                        ref
                            .read(currentInspectionState.notifier)
                            .changeCurrentInspection(perInspection);
                        NavigationService.instance.navigateToPage(
                            path: NavigationConstants
                                .waitingInspectionDetails,
                          data: {
                              "showDeleteButton":false
                          }
                        );
                      }),
                );
              })
              : Center(
            child: Text(
              "Yapılacak bir ziyaret bulunmamaktadır",
              style: ThemeValueExtension.subtitle,
            ),
          )
              : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }
}
