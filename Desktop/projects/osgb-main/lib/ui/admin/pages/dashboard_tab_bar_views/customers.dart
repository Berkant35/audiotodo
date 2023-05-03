import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/ui/details/customer/customer_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/customer.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../expert/pages/expert_customer_detail.dart';

class Customers extends ConsumerStatefulWidget {
  const Customers({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomersState();
}

class _CustomersState extends ConsumerState<Customers> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Customer>>(
          future:
              ref.read(currentAdminWorksState.notifier).getCustomerList(ref),
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
                          var perCustomer = customerList[index];
                          return Padding(
                            padding: EdgeInsets.all(1.h),
                            child: CustomCard(
                                networkImage: perCustomer.photoURL,
                                header1: "İş Yeri Adı",
                                content1: perCustomer.customerName ?? "Adı Yok",
                                header2: "Sektör",
                                content2: perCustomer.customerSector ??
                                    "Belirtilmemiş",
                                header3: "Tehlike Derecesi",
                                content3:
                                    perCustomer.dangerLevel ?? "Belirtilmemiş",
                                navigationContentText: "İncele",
                                onClick: () {
                                  if (ref.read(currentBaseModelState).expert ==
                                      null) {
                                    ref
                                        .read(currentCustomFlexibleAppBarState
                                            .notifier)
                                        .changeContentFlexibleManager(
                                            CustomFlexibleModel(
                                                header1: "İş Yeri",
                                                content1:
                                                    perCustomer.customerName,
                                                header2: "Tehlike Durumu",
                                                content2:
                                                    perCustomer.dangerLevel,
                                                header3: "E-Mail",
                                                content3: perCustomer.email,
                                                photoUrl: perCustomer.photoURL,
                                                backAppBarTitle:
                                                    "İş Yeri Detay",
                                                content4: perCustomer
                                                    .companyDetectNumber,
                                                header4: "Sicil No",
                                                header5: "Ziyaret Periyotu",
                                                content5:
                                                    perCustomer.dailyPeriod));

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerDetails(
                                                  customer: perCustomer,
                                                  onSaved: (value) =>
                                                      setState(() {}),
                                                )));
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ExpertCustomerDetail(
                                                  customer: perCustomer,
                                                )));
                                  }
                                }
                                ),
                          );
                        })
                    : Center(
                        child: Text(
                        "Henüz bir iş yeri yok",
                        style: ThemeValueExtension.subtitle,
                      ))
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}
