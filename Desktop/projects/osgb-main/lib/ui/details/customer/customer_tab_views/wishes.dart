import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/workers/confirm_add_worker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

class Wishes extends ConsumerStatefulWidget {
  const Wishes({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _WishesState();
}

class _WishesState extends ConsumerState<Wishes> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<DemandWorker>?>(
          future: ref.read(currentAdminWorksState.notifier).getDemands(),
          builder: (context, snapshot) {
            var demandList = snapshot.data;
            return snapshot.connectionState == ConnectionState.done
                ? demandList != null && demandList.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w,top: 1.h),
                            child: Text(
                              "Talepler (${demandList.length})",
                              style: ThemeValueExtension.headline6
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemExtent: 15.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              itemCount: demandList.length,
                              itemBuilder: (context, index) {
                                var perDemand = demandList[index];
                                return Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: CustomCard(
                                    networkImage:
                                        perDemand.demandByCustomer!.photoURL,
                                    header1: "İş Yeri Adı",
                                    content1:
                                        perDemand.demandByCustomer!.customerName ??
                                            "Adı Yok",
                                    header2: "Talep",
                                    content2:
                                        "${perDemand.demandWorker!.workerName} çalışan eklemesi talebi",
                                    header3: 'İş Yeri Telefon',
                                    content3: perDemand
                                        .demandByCustomer!.customerPhoneNumber!,
                                    navigationContentText: "Değerlendir",
                                    onClick: () async {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ConfirmAddWorker(
                                                  demandWorker: perDemand)));
                                    },
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                    : Center(
                        child: Text(
                        "Oluşturulmuş bir talep yok",
                        style: ThemeValueExtension.subtitle,
                      ))
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}
