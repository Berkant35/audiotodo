import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/models/worker.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/workers/worker_detail.dart';
import 'package:osgb/utilities/components/custom_flexible_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/customer.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

class WorkersOfCompany extends ConsumerStatefulWidget {
  final Customer customer;

  const WorkersOfCompany({Key? key, required this.customer}) : super(key: key);

  @override
  ConsumerState createState() => _WorkersOfCompanyState();
}

class _WorkersOfCompanyState extends ConsumerState<WorkersOfCompany> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Worker>?>(
          future: ref
              .read(currentAdminWorksState.notifier)
              .getWorkersOfCompany(widget.customer.rootUserID!),
          builder: (context, snapshot) {
            var workerList = snapshot.data;
            return snapshot.connectionState == ConnectionState.done
                ? workerList != null && workerList.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.w, top: 1.h),
                    child: Text(
                      "Çalışanlar (${workerList.length})",
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
                      itemCount: workerList.length,
                      itemBuilder: (context, index) {
                        var perWorker = workerList[index];
                        return Padding(
                          padding: EdgeInsets.all(1.h),
                          child: CustomCard(
                            networkImage: perWorker.photoURL,
                            header1: "Çalışan Adı",
                            content1:
                            perWorker.workerName ?? "Adı Yok",
                            header2: "Görev",
                            content2: perWorker.workerJob!,
                            header3: 'Çalışan Telefon',
                            content3: perWorker.workerPhoneNumber!,
                            navigationContentText: "İncele",
                            onClick: () async {



                              ref.read(currentCustomFlexibleAppBarState.notifier)
                              .changeContentFlexibleManager(CustomFlexibleModel(
                                header1: "Çalışan Adı",
                                header2: "Görevi",
                                header3: "Telefon",
                                content1:perWorker.workerName,
                                content2:perWorker.workerJob,
                                content3:perWorker.workerPhoneNumber,
                                photoUrl:perWorker.photoURL,
                                backAppBarTitle: "Çalışan Detay"
                              ));


                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WorkerDetail(
                                              worker: perWorker)));
                            },
                          ),
                        );
                      }),
                ),
              ],
            )
                : Center(
                child: Text(
                  "Oluşturulmuş bir çalışan yok",
                  style: ThemeValueExtension.subtitle,
                ))
                : const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
    );
  }
}
