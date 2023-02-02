import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/viewmodel/global_providers.dart';
import '../../models/customer.dart';
import '../../models/monthly.dart';
import '../../models/yearly.dart';
import '../../utilities/components/accountant_alert_dialog.dart';
import '../../utilities/components/choose_year.dart';
import '../../utilities/components/custom_elevated_button.dart';
import '../../utilities/components/custom_flexible_bar.dart';
import '../../utilities/components/seperate_padding.dart';
import '../../utilities/constants/app/enums.dart';
import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../../utilities/init/theme/custom_colors.dart';
import '../common/payment_action_list.dart';

class CustomerAccountantDetail extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerAccountantDetail({Key? key, required this.customer})
      : super(key: key);

  @override
  ConsumerState createState() => _CustomerAccountantDetailState();
}

class _CustomerAccountantDetailState
    extends ConsumerState<CustomerAccountantDetail> {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
        flexibleSpace: CustomFlexibleBar(
          firstHeader: ref.watch(currentCustomFlexibleAppBarState).header1,
          secondHeader: ref.watch(currentCustomFlexibleAppBarState).header2,
          thirdHeader: ref.watch(currentCustomFlexibleAppBarState).header3,
          firstInfo: ref.watch(currentCustomFlexibleAppBarState).content1,
          secondInfo: ref.watch(currentCustomFlexibleAppBarState).content2,
          thirdInfo: ref.watch(currentCustomFlexibleAppBarState).content3,
          headerPhoto: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
          appBarTitle:
              ref.watch(currentCustomFlexibleAppBarState).backAppBarTitle!,
          role: Roles.customer,
        ),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return !isLoading
        ? SingleChildScrollView(
            child: scrollBody(context),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }

  Padding scrollBody(BuildContext context) {
    return Padding(
      padding: seperatePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chooseYear(),
          addNewYearTextButton(context),
          tablePart(context),
          space(),
        ],
      ),
    );
  }

  RenderObjectWidget tablePart(BuildContext context) {
    return monthlyList.isNotEmpty
        ? buildTable(context, monthlyList)
        : const SizedBox();
  }

  SizedBox space() {
    return SizedBox(
      height: 20.h,
    );
  }

  ChooseYear chooseYear() {
    return ChooseYear(
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
    );
  }

  TextButton addNewYearTextButton(BuildContext context) {
    return TextButton(
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
                  child: yearPicker(),
                ),
              );
            },
          );
        },
        child: Text(
          "Yeni Yıl Girişi Ekle",
          style: ThemeValueExtension.subtitle2
              .copyWith(color: CustomColors.secondaryColor),
        ));
  }

  YearPicker yearPicker() {
    return YearPicker(
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime(DateTime.now().year + 100, 1),
      initialDate: DateTime.now(),
      selectedDate: _selectedDate,
      onChanged: (DateTime dateTime) {
        if (!years.contains(dateTime.year.toString())) {
          ref
              .read(currentAccountantManagerState.notifier)
              .addNewYear(widget.customer.rootUserID!, dateTime)
              .then((year) {
            if (year != null) {
              choosedYear = year.currentYear!.toString();
              years.add(choosedYear.toString());
              yearlyList.add(year);
              monthlyList.clear();

              for (var monthObject in year.monthlyList!) {
                monthlyList.add(Monthly.fromJson(monthObject));
              }
              choosedYear = year.currentYear.toString();
              setState(() {
                NavigationService.instance.navigatePopUp();
              });
            }
          });
        } else {
          Fluttertoast.showToast(msg: "Seçilen Yıl Zaten Oluşturulmuş");
        }
      },
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
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
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
                        customerPushToken: widget.customer.pushToken,
                      );
                    });
              },
              inButtonText: "İşlem",
              inButtonTextStyle:
                  ThemeValueExtension.subtitle4.copyWith(fontSize: 12.sp),
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
                    builder: (context) => PaymentActionList(
                          monthly: sortedData[i],
                        )));
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
