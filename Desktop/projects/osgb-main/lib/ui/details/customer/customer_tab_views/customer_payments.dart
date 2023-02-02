import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/monthly.dart';
import 'package:osgb/models/payment.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/customer.dart';
import '../../../../models/yearly.dart';
import '../../../../utilities/components/accountant_alert_dialog.dart';
import '../../../../utilities/components/choose_year.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../utilities/init/theme/custom_colors.dart';
import '../../../common/payment_action_list.dart';

class CustomerPayments extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerPayments({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerPaymentsState();
}

class _CustomerPaymentsState extends ConsumerState<CustomerPayments> {
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
        .getAndSetCurrentPayment(widget.customer.rootUserID)
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
        debugPrint("Year List ${yearlyList.length}");
        debugPrint("Monthly List ${monthlyList.length}");
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
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text(
                                "Yeni Yılı Ekle",
                                style: ThemeValueExtension.subtitle2,
                              ),
                              content: SizedBox(
                                width: 90.w,
                                height: 70.h,
                                child: YearPicker(
                                  firstDate:
                                      DateTime(DateTime.now().year - 100, 1),
                                  lastDate:
                                      DateTime(DateTime.now().year + 100, 1),
                                  initialDate: DateTime.now(),
                                  selectedDate: _selectedDate,
                                  onChanged: (DateTime dateTime) {
                                    if (!years
                                        .contains(dateTime.year.toString())) {
                                      ref
                                          .read(currentAccountantManagerState
                                              .notifier)
                                          .addNewYear(
                                              widget.customer.rootUserID!,
                                              dateTime)
                                          .then((year) {
                                        if (year != null) {
                                          choosedYear =
                                              year.currentYear!.toString();
                                          years.add(choosedYear.toString());
                                          yearlyList.add(year);
                                          monthlyList.clear();

                                          for (var monthObject
                                              in year.monthlyList!) {
                                            monthlyList.add(
                                                Monthly.fromJson(monthObject));
                                          }
                                          choosedYear =
                                              year.currentYear.toString();
                                          setState(() {
                                            NavigationService.instance
                                                .navigatePopUp();
                                          });
                                        }
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Seçilen Yıl Zaten Oluşturulmuş");
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Yeni Yıl Girişi Ekle",
                        style: ThemeValueExtension.subtitle2
                            .copyWith(color: CustomColors.secondaryColor),
                      )),
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
        5: FlexColumnWidth(),
      },
      children: <TableRow>[
        tableHeaderRow(context),
        for (int i = 0; i < 12; i++) perRow(context, monthlyList, i),
      ],
    );
  }

  TableRow tableHeaderRow(BuildContext context) {
    return TableRow(
      children: <Widget>[
        headerTableRowInfo(context, "Aylar"),
        headerTableRowInfo(context, "Ödenen"),
        headerTableRowInfo(context, "Beklenen"),
        ref.read(currentRole) != Roles.customer
            ? headerTableRowInfo(context, "İşlem")
            : const SizedBox(),
        ref.read(currentRole) != Roles.customer
            ? headerTableRowInfo(context, "İncele")
            : const SizedBox(),
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
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AccountantAlertDialog(
                        monthly: sortedData[i],
                        choosedYear: choosedYear ?? years.first,
                        customerID: widget.customer.rootUserID!,
                        setStateCase: () => setState(() {}),
                        customerPushToken: widget.customer.pushToken!,
                      );
                    });
              },
              inButtonTextStyle:
                  ThemeValueExtension.subtitle4.copyWith(fontSize: 12.sp),
              inButtonText: "İşlem",
              primaryColor: CustomColors.secondaryColorM,
            ),
          ),
        ),
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
