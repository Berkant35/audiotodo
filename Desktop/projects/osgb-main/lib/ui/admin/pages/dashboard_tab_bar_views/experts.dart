import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/ui/details/expert/common_expert_detail.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

class Experts extends ConsumerStatefulWidget {
  const Experts({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExpertsState();
}

class _ExpertsState extends ConsumerState<Experts> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Expert>>(
          future: ref
              .read(currentAdminWorksState.notifier)
              .getExpertListWithType(ref),
          builder: (context, snapshot) {
            var customerList = snapshot.data;
            return snapshot.connectionState == ConnectionState.done
                ? customerList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 5.h),
                        itemExtent: 15.h,
                        itemCount: customerList.length,
                        itemBuilder: (context, index) {
                          var perExpert = customerList[index];
                          return Padding(
                            padding: EdgeInsets.all(1.h),
                            child: CustomCard(
                                networkImage: perExpert.photoURL,
                                header1: "Uzman Adı",
                                content1: perExpert.expertName ?? "Adı Yok",
                                header2: "E-Mail",
                                content2:
                                    perExpert.expertMail ?? "Belirtilmemiş",
                                header3: "Telefon Numarası",
                                content3: perExpert.expertPhoneNumber ??
                                    "Belirtilmemiş",
                                navigationContentText: "İncele",
                                onClick: () {
                                  ref
                                      .read(currentCustomFlexibleAppBarState
                                          .notifier)
                                      .changeContentFlexibleManager(
                                          CustomFlexibleModel(
                                              header1: "Uzman Adı",
                                              header2: "Uzmanlık",
                                              header3: "E-Mail",
                                              content1:
                                                  perExpert.expertName ?? "-",
                                              content2: perExpert.expertMaster,
                                              content3:
                                                  perExpert.expertMail,
                                              backAppBarTitle: "Uzman Detay",
                                              photoUrl: perExpert.photoURL));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CommonExpertDetail(
                                          expert: perExpert)));
                                }),
                          );
                        })
                    : Center(
                        child: Text(
                        "Henüz bir uzman yok",
                        style: ThemeValueExtension.subtitle,
                      ))
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}
