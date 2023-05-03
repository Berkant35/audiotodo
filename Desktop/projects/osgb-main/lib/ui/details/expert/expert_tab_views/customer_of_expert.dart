import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/custom_functions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/customer.dart';
import '../../../../models/expert.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

import '../../customer/customer_details.dart';

class CustomerOfExpert extends ConsumerStatefulWidget {
  final Expert expert;

  const CustomerOfExpert({Key? key, required this.expert}) : super(key: key);

  @override
  ConsumerState createState() => _CustomerOfExpertState();
}

class _CustomerOfExpertState extends ConsumerState<CustomerOfExpert> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Customer>?>(
        future: ref
            .read(currentAdminWorksState.notifier)
            .getCustomerList(ref, expertId: widget.expert.rootUserID),
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
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var perCustomer = list[index];
                                return Padding(
                                      padding: EdgeInsets.all(1.h),
                                      child: CustomCard(
                                          networkImage: perCustomer.photoURL,
                                          header1: "Şirket Adı",
                                          content1: perCustomer.customerName!,
                                          header2: "Sektör",
                                          content2:
                                          "${perCustomer.customerSector}",
                                          header3: "Tehlike Derecesi",
                                          content3: perCustomer.dangerLevel ?? "Belirtilmemiş",
                                          navigationContentText: "",
                                          onClick: () {
                                          }));
                              }),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Atanmış bir iş yeri bulunamadı!",
                        style: ThemeValueExtension.subtitle,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        });
  }
}
