import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/async.dart';
import 'package:ntp/ntp.dart';
import 'package:osgb/line/network/database/fb_db_manager.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/monthly.dart';
import 'package:osgb/models/payment.dart';
import 'package:osgb/models/yearly.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

class AccountantWorkManager extends StateNotifier<Payment> {
  AccountantWorkManager(Payment state) : super(Payment());

  final fb = FirebaseDbManager();

  void changeCurrentPaymentState(Payment payment) {
    state = payment;
  }

  Future<void> addDebtToMonthly(String customerID, int amount,
      Monthly monthlyParameter, String year, WidgetRef ref) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);

      var payment = state;
      var tempYearlyList = <Yearly>[];
      for (var yearly in payment.paymentYearList!) {
        tempYearlyList
            .add(Yearly.fromJson(yearly is Yearly ? yearly.toJson() : yearly));
      }
      Yearly? choosedYearly;

      for (var perYear in tempYearlyList) {
        if (perYear.currentYear.toString() == year) {
          choosedYearly = perYear;
        }
      }

      var tempMonths = <Monthly>[];

      if (choosedYearly != null) {
        for (var monthObject in choosedYearly.monthlyList!) {
          tempMonths.add(Monthly.fromJson(monthObject));
        }
      }

      for (int i = 0; i < tempMonths.length; i++) {
        if (tempMonths[i].monthName == monthlyParameter.monthName) {
          tempMonths[i] = monthlyParameter;
          debugPrint("Parameter Monthly ${monthlyParameter.toJson()}");
        }
      }

      choosedYearly!.monthlyList!.clear();

      for (var month in tempMonths) {
        choosedYearly.monthlyList!.add(month.toJson());
      }

      for (int i = 0; i < tempYearlyList.length; i++) {
        if (choosedYearly.currentYear!.toString() ==
            tempYearlyList[i].currentYear.toString()) {
          debugPrint("Year Find");
          tempYearlyList[i] = choosedYearly;
          break;
        }
      }

      var objectListOfTempYearly = <dynamic>[];

      for (var tempYear in tempYearlyList) {
        objectListOfTempYearly.add(tempYear.toJson());
      }

      debugPrint(objectListOfTempYearly.toList().toString());

      state.paymentYearList = objectListOfTempYearly;

      await fb
          .updatePaymentYear(objectListOfTempYearly, customerID)
          .then((value) {
        debugPrint("Finito");
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }

  Future<Yearly?> addNewYear(String customerID, DateTime date) async {
    try {
      var ayear = yearly(date, customerID);

      return await fb.addDateToPayment(customerID, ayear).then((value) {
        if (value) {
          state.paymentYearList!.add(ayear);
          return ayear;
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint('$e<-Err');
    }
  }

  Future<Payment?> getAndSetCurrentPayment(String? customerID) async {
    try {
      return fb.getPayment(customerID!).then((value) {
        if (value != null) {
          changeCurrentPaymentState(value);
        } else {
          debugPrint("NULL");
        }
        return value;
      });
    } catch (e) {
      debugPrint("ViewModel getAndSetCurrentPayment $e");
      return null;
    }
  }

  Future<void> createPayment(String customerID) async {
    try {
      var date = await NTP.now();
      var uniquePaymentID = await nanoid();

      Payment newPayment = Payment(
        paymentID: uniquePaymentID,
        paymentYearList: [],
        customerID: customerID,
        workerCount: 0,
        currentInspectionCount: 0,
      );

      newPayment.paymentYearList!.add(yearly(date, customerID).toJson());

      await fb.createPaymentTable(newPayment).then((value) {
        if (value) {
          changeCurrentPaymentState(newPayment);
        } else {
          debugPrint("Err:");
        }
      });
    } catch (e) {
      debugPrint("Create Payment Error");
    }
  }

  Yearly yearly(DateTime date, String customerID) {
    return Yearly(
      currentYear: date.year,
      customerID: customerID,
      monthlyList: [
        Monthly(
            monthName: Months.ocak.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.subat.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.mart.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.nisan.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.mayis.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.haziran.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.temmuz.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.agustos.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.eylul.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.ekim.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.kasim.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
        Monthly(
            monthName: Months.aralik.text,
            amountOfDone: 0,
            amountOfWaiting: 0,
            paymentActionList: []).toJson(),
      ],
      waitingPay: 0,
      currentPay: 0,
    );
  }
}
