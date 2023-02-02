import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/ui/accountant/customer_accountant_detail.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../line/viewmodel/global_providers.dart';
import '../../models/customer.dart';
import '../../utilities/components/custom_card.dart';
import '../../utilities/constants/extension/context_extensions.dart';

class ConsumerForAccountant extends ConsumerStatefulWidget {
  const ConsumerForAccountant({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ConsumerForAccountantState();
}

class _ConsumerForAccountantState extends ConsumerState<ConsumerForAccountant> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: seperatePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                "Müşteriler",
                style: ThemeValueExtension.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<Customer>>(
                  future: ref
                      .read(currentAdminWorksState.notifier)
                      .getCustomerList(ref),
                  builder: futureBuilder),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }

  Widget futureBuilder(context, snapshot) {
    var customerList = snapshot.data;
    return snapshot.connectionState == ConnectionState.done
        ? customerList!.isNotEmpty
            ? createListView(customerList)
            : Center(
                child: Text(
                "Henüz bir iş yeri yok",
                style: ThemeValueExtension.subtitle,
              ))
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }

  ListView createListView(List<Customer> customerList) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 15.h,
        padding: EdgeInsets.only(bottom: 5.h),
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          var perCustomer = customerList[index];
          return Padding(
            padding: EdgeInsets.all(1.h),
            child: customCard(perCustomer, context),
          );
        });
  }

  CustomCard customCard(Customer perCustomer, BuildContext context) {
    return CustomCard(
        networkImage: perCustomer.photoURL,
        header1: "İş Yeri Adı",
        content1: perCustomer.customerName ?? "Adı Yok",
        header2: "E-Mail",
        content2: perCustomer.email!,
        header3: "Periyot",
        content3: perCustomer.dailyPeriod ?? "Belirtilmemiş",
        navigationContentText: "İncele",
        onClick: () {
          ref
              .read(currentCustomFlexibleAppBarState.notifier)
              .changeContentFlexibleManager(CustomFlexibleModel(
                  header1: "İş Yeri",
                  content1: perCustomer.customerName,
                  header2: "E-Mail",
                  content2: perCustomer.email,
                  header3: "Periyodu",
                  content3: perCustomer.dailyPeriod,
                  photoUrl: perCustomer.photoURL,
                  backAppBarTitle: "Muhasebe Detay"));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CustomerAccountantDetail(customer: perCustomer)));
        });
  }
}
