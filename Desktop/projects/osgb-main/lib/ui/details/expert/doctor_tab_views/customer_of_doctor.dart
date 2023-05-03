import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/main.dart';
import 'package:osgb/models/doctor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/customer.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';


class CustomerOfDoctor extends ConsumerStatefulWidget {
  final Doctor doctor;

  const CustomerOfDoctor({Key? key, required this.doctor}) : super(key: key);

  @override
  ConsumerState createState() => _CustomerOfDoctorState();
}

class _CustomerOfDoctorState extends ConsumerState<CustomerOfDoctor> {
  @override
  Widget build(BuildContext context) {

    logger.i("Doctor: ${widget.doctor.toJson()}");

    return FutureBuilder<List<Customer>?>(
        future: ref
            .read(currentAdminWorksState.notifier)
            .getCustomerList(ref, doctorId: widget.doctor.rootUserID),
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
                                          onClick: () {}
                                      )
                                );
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
