import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accident_case.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../utilities/components/custom_card.dart';
import '../../../utilities/init/navigation/navigation_constants.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class CustomerCrises extends ConsumerStatefulWidget {
  const CustomerCrises({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerCrisesState();
}

class _CustomerCrisesState extends ConsumerState<CustomerCrises> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: seperatePadding(),
      child: SingleChildScrollView(

        child: Column(
          children: [
            addCrisesRow(),
            FutureBuilder<List<AccidentCase>?>(
                future: ref
                    .read(currentCustomerWorksState.notifier)
                    .getAccidentCaseList(true, ref),
                builder: (context, snapshot) {
                  var list = snapshot.data;
                  return snapshot.connectionState == ConnectionState.done
                      ? list!.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              shrinkWrap: true,
                              itemExtent: 15.h,
                              itemBuilder: (context, index) {
                                var perAccidentCase = list[index];
                                return Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: CustomCard(
                                      networkImage:
                                      perAccidentCase.casePhotos!.isNotEmpty ? perAccidentCase.casePhotos!.first : null,
                                      header1: "Olay Baslik",
                                      content1: perAccidentCase.caseName ?? "-",
                                      header2: "Etkilenen Kişi Sayısı",
                                      content2: perAccidentCase
                                          .caseAffectedWorkerList!.length
                                          .toString(),
                                      header3: "Tarih",
                                      content3: perAccidentCase.caseDate!
                                          .substring(0, 16),
                                      navigationContentText: "Detaylar",
                                      onClick: () {
                                        ref
                                            .read(currentCustomFlexibleAppBarState
                                                .notifier)
                                            .changeContentFlexibleManager(
                                                CustomFlexibleModel(
                                                    header1: "Olay Baslik",
                                                    header2:
                                                        "Etkilenen Calisan Sayı",
                                                    header3: "Tarih",
                                                    content1: perAccidentCase.caseName ??
                                                        "-",
                                                    content2: perAccidentCase
                                                        .caseAffectedWorkerList!
                                                        .length
                                                        .toString(),
                                                    content3: perAccidentCase
                                                        .caseDate!
                                                        .substring(0, 16),
                                                    backAppBarTitle: "Olay Detay",
                                                    photoUrl: perAccidentCase
                                                        .casePhotos!.isNotEmpty ? perAccidentCase
                                                        .casePhotos!.first : null));
                                        ref
                                            .read(currentCrisisState.notifier)
                                            .changeCurrentInspection(
                                                perAccidentCase);
                                        NavigationService.instance.navigateToPage(
                                            path: NavigationConstants
                                                .crisisDetailPage);
                                      }),
                                );
                              })
                          : Center(
                              child: Padding(
                                padding:  EdgeInsets.only(top: 30.h),
                                child: Text(
                                  "Henüz bir Olay bulunmamaktadır",
                                  style: ThemeValueExtension.subtitle,
                                ),
                              ),
                            )
                      : const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                }),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  Row addCrisesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.5.w),
          child: Text("Olaylar",
              style: ThemeValueExtension.headline6
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        IconButton(
            onPressed: () {
              ref
                  .read(currentLoadingState.notifier)
                  .changeState(LoadingStates.loading);

              NavigationService.instance
                  .navigateToPage(path: NavigationConstants.addCrisesPage);
            },
            icon: Icon(
              Icons.add_alert_rounded,
              color: CustomColors.pinkColor,
              size: 3.5.h,
            ))
      ],
    );
  }
}
