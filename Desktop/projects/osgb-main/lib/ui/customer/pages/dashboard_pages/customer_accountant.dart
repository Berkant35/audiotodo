import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/monthly.dart';
import '../../../../models/yearly.dart';
import '../../../../utilities/components/accountant_alert_dialog.dart';
import '../../../../utilities/components/choose_year.dart';
import '../../../../utilities/components/custom_elevated_button.dart';
import '../../../../utilities/components/seperate_padding.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../utilities/init/theme/custom_colors.dart';
import '../../../common/payment_action_list.dart';

class CustomerAccountant extends ConsumerStatefulWidget {
  const CustomerAccountant({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerAccountantState();
}

class _CustomerAccountantState extends ConsumerState<CustomerAccountant> {
  String? choosedYear;
  bool isLoading = true;
  List<Monthly> monthlyList = [];
  List<Yearly> yearlyList = [];
  List<String> years = [];
  DateTime _selectedDate = DateTime(2022);

  @override
  void initState() {
    super.initState();
    ref
        .read(currentAccountantManagerState.notifier)
        .getAndSetCurrentPayment(
            ref.read(currentBaseModelState).customer!.rootUserID)
        .then((payment) {
      if (payment != null) {
        for (var yearObject in payment.paymentYearList!) {
          var yearModel = Yearly.fromJson(yearObject);
          yearlyList.add(yearModel);
          years.add(yearModel.currentYear.toString());
        }
        for (var monthObject in yearlyList.first.monthlyList!) {
          monthlyList.add(Monthly.fromJson(monthObject));
        }
        isLoading = false;
        setState(() {});

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? SingleChildScrollView(
      child: Padding(
        padding: seperatePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h,),
            Text("Ödemeler",style: ThemeValueExtension.headline6.copyWith(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 2.h,),
            ChooseYear(
              choosedYear: choosedYear,
              onSavedForYear: (String year) {
                choosedYear = year;
                for (var curYear in yearlyList) {
                  if (curYear.currentYear.toString() == year) {
                    monthlyList.clear();
                    curYear.monthlyList?.forEach((month) {
                      monthlyList.add(Monthly.fromJson(month));
                    });
                  }
                }
                setState(() {});
              },
              allYears: years,
            ),

            monthlyList.isNotEmpty
                ? buildTable(context, monthlyList)
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    )
        : const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
  Table buildTable(BuildContext context, List<Monthly> monthlyList) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      children: <TableRow>[
        tableHeaderRow(context),
        for (int i = 0; i < 12; i++) perRow(context, monthlyList, i),
      ],
    );
  }

  TableRow tableHeaderRow(BuildContext context)
  {
    return TableRow(
      children: <Widget>[
        headerTableRowInfo(context, "Aylar"),
        headerTableRowInfo(context, "Ödenen"),
        headerTableRowInfo(context, "Beklenen"),
        headerTableRowInfo(context, "İncele"),

      ],
    );
  }

  SizedBox headerTableRowInfo(BuildContext context, String content) {
    return SizedBox(
      height: 5.h,
      child: Center(
        child: Text(
          content,
          style: ThemeValueExtension.subtitle2
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TableRow perRow(BuildContext context, List<Monthly> sortedData, int i) {
    return TableRow(
      children: <Widget>[
        inTableText(
          sortedData[i].monthName!.toString(),
        ),
        inTableText(
          sortedData[i].amountOfDone.toString(),
        ),
        inTableText(sortedData[i].amountOfWaiting.toString()),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: CustomElevatedButton(
              height: 5.h,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentActionList(monthly: sortedData[i],)));
              },
              inButtonText: "İncele",
              inButtonTextStyle:
              ThemeValueExtension.subtitle4.copyWith(fontSize: 12.sp),
              primaryColor: CustomColors.orangeColorM,
            ),
          ),
        ),
      ],
    );
  }

  Center inTableText(String content) {
    return Center(
      child: SizedBox(
        height: 7.h,
        child: Center(
          child: Text(
            content,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Center infoTableRow(BuildContext context, String content) {
    return Center(
      child: Text(
        content,
      ),
    );
  }
}
