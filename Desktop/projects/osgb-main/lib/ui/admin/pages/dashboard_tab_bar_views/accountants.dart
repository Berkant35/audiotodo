import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/ui/details/accountant/accountant_detail.dart';
import 'package:osgb/utilities/components/custom_card.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';


class Accountants extends ConsumerStatefulWidget {
  const Accountants({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AccountantsState();
}

class _AccountantsState extends ConsumerState<Accountants> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Accountant>>(
          future: ref
              .read(currentAdminWorksState.notifier)
              .getAccountantListWithType(ref),
          builder: (context, snapshot) {
            var customerList = snapshot.data;
            return snapshot.connectionState == ConnectionState.done
                ? customerList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemExtent: 15.h,
                        padding: EdgeInsets.only(bottom: 5.h),
                        itemCount: customerList.length,
                        itemBuilder: (context, index) {
                          var perAccountant = customerList[index];
                          return Padding(
                            padding: EdgeInsets.all(1.h),
                            child: CustomCard(
                                networkImage: perAccountant.photoURL,
                                header1: "Muhasebeci Adı",
                                content1:
                                    perAccountant.accountantName ?? "Adı Yok",
                                header2: "Email",
                                content2: perAccountant.accountantEmail ??
                                    "Belirtilmemiş",
                                header3: "Telefon Numarası",
                                content3: perAccountant.accountantPhoneNumber ??
                                    "Belirtilmemiş",
                                navigationContentText: "İncele",
                                onClick: () {
                                  ref
                                      .read(currentCustomFlexibleAppBarState
                                          .notifier)
                                      .changeContentFlexibleManager(
                                          CustomFlexibleModel(
                                              header1: "Muhasebeci Adı",
                                              header2: "Telefon",
                                              header3: "E-Mail",
                                              content1: perAccountant
                                                      .accountantName ??
                                                  "-",
                                              content2: perAccountant
                                                  .accountantPhoneNumber,
                                              content3:
                                                  perAccountant.accountantEmail,
                                              backAppBarTitle:
                                                  "Muhasebeci Detay",
                                              photoUrl:
                                                  perAccountant.photoURL));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AccountantDetail(
                                          accountant: perAccountant)));
                                }),
                          );
                        })
                    : Center(
                        child: Text(
                        "Henüz bir muhasebeci yok",
                        style: ThemeValueExtension.subtitle,
                      ))
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}
